-- PostgreSQL pasa a ser el unico motor: las colecciones de Mongo de identity,
-- audit, gallery y notification se vuelven tablas en el esquema de su dueno.
-- Lo que en Mongo era un documento anidado queda en JSONB; lo que se filtra u
-- ordena va en columnas con su indice. La semilla vuelve a crear los datos, asi
-- que no hay copia desde Mongo ni periodo de doble escritura.

-- identity: sesiones de refresh. Solo se guarda el SHA-256 del token. En Mongo
-- un indice TTL borraba las vencidas; ahora lo hace un barrido de identity
-- apoyado en refresh_sessions_expires_idx.
CREATE TABLE identity.refresh_sessions (
  token_hash TEXT PRIMARY KEY,
  user_id UUID NOT NULL,
  family_id UUID NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked_at TIMESTAMPTZ,
  replaced_by_hash TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT refresh_sessions_token_hash_check CHECK (token_hash ~ '^[0-9a-f]{64}$'),
  CONSTRAINT refresh_sessions_replaced_by_hash_check
    CHECK (replaced_by_hash IS NULL OR replaced_by_hash ~ '^[0-9a-f]{64}$')
);

CREATE INDEX refresh_sessions_user_idx ON identity.refresh_sessions (user_id);
CREATE INDEX refresh_sessions_family_idx ON identity.refresh_sessions (family_id);
CREATE INDEX refresh_sessions_expires_idx ON identity.refresh_sessions (expires_at);

-- audit: informe completo, 1 a 1 con su resumen. La llave es la del resumen y
-- se guarda en la misma transaccion, asi no puede quedar un informe sin
-- resumen. Por eso sobra la referencia mongo_report_id.
CREATE TABLE audit.reports (
  summary_id UUID PRIMARY KEY REFERENCES audit.audit_summaries (id) ON DELETE CASCADE,
  lot_id UUID NOT NULL,
  decided_by TEXT NOT NULL,
  -- Expediente de evidencias; null en los informes sin expediente.
  dossier JSONB,
  assessment JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT reports_decided_by_check CHECK (decided_by IN ('RULES', 'AI', 'FALLBACK')),
  CONSTRAINT reports_assessment_object_check CHECK (jsonb_typeof(assessment) = 'object'),
  CONSTRAINT reports_dossier_object_check CHECK (dossier IS NULL OR jsonb_typeof(dossier) = 'object')
);

CREATE INDEX reports_lot_created_idx ON audit.reports (lot_id, created_at DESC);

ALTER TABLE audit.audit_summaries DROP COLUMN mongo_report_id;

-- gallery: obras de la galeria social y actividad del feed. Los ids son los
-- deterministas que arma gallery-service (PROPIA:<obra>:<duena>, follow:...),
-- para que repetir un evento no duplique la fila.
CREATE TABLE gallery.items (
  id TEXT PRIMARY KEY,
  owner_id UUID NOT NULL,
  lot_id UUID,
  source TEXT NOT NULL,
  visibility TEXT NOT NULL,
  title TEXT NOT NULL,
  artist_name TEXT,
  image_keys TEXT[] NOT NULL DEFAULT '{}',
  acquired_at TIMESTAMPTZ NOT NULL,
  CONSTRAINT items_source_check CHECK (source IN ('PROPIA', 'GANADA', 'GRATUITA')),
  CONSTRAINT items_visibility_check CHECK (visibility IN ('PUBLIC', 'PRIVATE')),
  CONSTRAINT items_title_check CHECK (char_length(btrim(title)) > 0)
);

CREATE INDEX items_owner_acquired_idx ON gallery.items (owner_id, acquired_at DESC);

CREATE TABLE gallery.activity (
  id TEXT PRIMARY KEY,
  actor_id UUID NOT NULL,
  verb TEXT NOT NULL,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  visibility TEXT NOT NULL,
  summary TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT activity_verb_check CHECK (verb IN ('PUBLISH', 'BID', 'WIN', 'FOLLOW', 'AUDIT')),
  CONSTRAINT activity_object_type_check CHECK (object_type IN ('LOT', 'AUCTION', 'USER', 'AUDIT')),
  CONSTRAINT activity_visibility_check CHECK (visibility IN ('PUBLIC', 'PRIVATE'))
);

-- El feed lee lo publico mas lo propio del lector, del mas reciente al mas antiguo.
CREATE INDEX activity_public_created_idx ON gallery.activity (created_at DESC) WHERE visibility = 'PUBLIC';
CREATE INDEX activity_actor_created_idx ON gallery.activity (actor_id, created_at DESC);

-- notification: esquema propio. Es el unico servicio que antes no tenia nada en
-- Postgres; recibe su inbox y su rol de grupo como los demas.
CREATE SCHEMA IF NOT EXISTS notification;

CREATE TABLE notification.notifications (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL,
  kind TEXT NOT NULL,
  payload JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  read_at TIMESTAMPTZ,
  CONSTRAINT notifications_kind_check CHECK (kind IN ('AUDIT', 'AUCTION_CLOSED')),
  CONSTRAINT notifications_payload_object_check CHECK (jsonb_typeof(payload) = 'object')
);

CREATE INDEX notifications_user_created_idx ON notification.notifications (user_id, created_at DESC);

CREATE TABLE notification.inbox (
  event_id TEXT PRIMARY KEY,
  event_type TEXT NOT NULL,
  processed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'notification_rw') THEN
    CREATE ROLE notification_rw NOLOGIN;
  END IF;
END $$;

GRANT USAGE ON SCHEMA notification TO notification_rw;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA notification TO notification_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA notification GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO notification_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA notification GRANT USAGE, SELECT ON SEQUENCES TO notification_rw;

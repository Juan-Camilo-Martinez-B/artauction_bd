-- Varios idiomas (F18 de la plataforma): por ahora espanol e ingles.
--
-- 1. Cada cuenta guarda el idioma en que ve la plataforma.
-- 2. Cada obra guarda el idioma en que se escribio su ficha (detectado al
--    traducirla) y sus traducciones automaticas a los demas idiomas. El texto
--    original nunca se toca: es el que vale si hay diferencias.
-- 3. Una cola de traduccion, con el mismo patron que la de auditoria (0019):
--    estado, intentos, disponibilidad y lease, y una sola pendiente por obra.

ALTER TABLE identity.users
  ADD COLUMN locale TEXT NOT NULL DEFAULT 'es',
  ADD CONSTRAINT users_locale_check CHECK (locale IN ('es', 'en'));

ALTER TABLE catalog.lots
  ADD COLUMN source_locale TEXT,
  ADD CONSTRAINT lots_source_locale_check CHECK (source_locale IS NULL OR source_locale IN ('es', 'en'));

-- Traduccion de los textos de una ficha a un idioma. source_hash es la huella
-- (SHA-256) del texto original que se tradujo: si la ficha cambia, deja de
-- coincidir y la traduccion se rehace.
CREATE TABLE catalog.lot_translations (
  lot_id UUID NOT NULL REFERENCES catalog.lots(id) ON DELETE CASCADE,
  locale TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  materials TEXT NOT NULL,
  provenance TEXT,
  source_hash TEXT NOT NULL,
  model TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (lot_id, locale),
  CONSTRAINT lot_translations_locale_check CHECK (locale IN ('es', 'en')),
  CONSTRAINT lot_translations_source_hash_check CHECK (source_hash ~ '^[0-9a-f]{64}$')
);

CREATE TABLE catalog.translation_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lot_id UUID NOT NULL REFERENCES catalog.lots(id) ON DELETE CASCADE,
  source_hash TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDIENTE',
  attempts INTEGER NOT NULL DEFAULT 0,
  available_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  lease_until TIMESTAMPTZ,
  last_error TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  CONSTRAINT translation_requests_status_check CHECK (status IN ('PENDIENTE', 'COMPLETADA', 'FALLIDA')),
  CONSTRAINT translation_requests_attempts_check CHECK (attempts >= 0),
  CONSTRAINT translation_requests_source_hash_check CHECK (source_hash ~ '^[0-9a-f]{64}$')
);

-- Una sola traduccion pendiente por obra: si la ficha cambia antes de
-- traducirse, la pendiente se actualiza con la huella nueva.
CREATE UNIQUE INDEX translation_requests_pending_lot_uidx
  ON catalog.translation_requests (lot_id)
  WHERE status = 'PENDIENTE';

-- El worker solo recorre las pendientes, por orden de disponibilidad.
CREATE INDEX translation_requests_due_idx
  ON catalog.translation_requests (available_at)
  WHERE status = 'PENDIENTE';

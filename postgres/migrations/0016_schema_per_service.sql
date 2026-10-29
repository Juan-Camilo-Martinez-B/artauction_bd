-- Expand: un esquema por microservicio.
--
-- Cada contexto del backend pasa a ser dueño exclusivo de su esquema. Las
-- tablas se mueven sin copiar datos (SET SCHEMA conserva filas, índices,
-- restricciones y triggers). Las llaves foráneas entre esquemas se eliminan:
-- la integridad entre servicios la garantizan los casos de uso y los eventos.
--
-- Compatibilidad: el monolito sigue leyendo public. Por eso se crean vistas
-- simples en public con el mismo nombre de cada tabla. Postgres las actualiza
-- de forma automática (INSERT, UPDATE, DELETE, ON CONFLICT y FOR UPDATE pasan a
-- la tabla base). Las vistas se eliminan en la migración de contract, cuando el
-- monolito deje de existir.

CREATE SCHEMA IF NOT EXISTS identity;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS auction;
CREATE SCHEMA IF NOT EXISTS wallet;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS gallery;
-- Cola pg-boss de audit-service. pg-boss crea sus tablas al arrancar.
CREATE SCHEMA IF NOT EXISTS audit_queue;

ALTER TABLE public.users SET SCHEMA identity;

ALTER TABLE public.lots SET SCHEMA catalog;
ALTER TABLE public.lot_images SET SCHEMA catalog;
ALTER TABLE public.categories SET SCHEMA catalog;
ALTER TABLE public.lot_categories SET SCHEMA catalog;

ALTER TABLE public.auctions SET SCHEMA auction;
ALTER TABLE public.bids SET SCHEMA auction;
ALTER TABLE public.transactions SET SCHEMA auction;
ALTER FUNCTION public.auctions_reject_backward_update() SET SCHEMA auction;

ALTER TABLE public.wallets SET SCHEMA wallet;
ALTER TABLE public.payment_orders SET SCHEMA wallet;
ALTER TABLE public.wallet_entries SET SCHEMA wallet;
ALTER TABLE public.bid_holds SET SCHEMA wallet;

ALTER TABLE public.audit_summaries SET SCHEMA audit;

ALTER TABLE public.follows SET SCHEMA gallery;
ALTER TABLE public.personal_galleries SET SCHEMA gallery;
ALTER TABLE public.personal_gallery_artworks SET SCHEMA gallery;

-- Elimina toda llave foránea cuya tabla y cuya referencia quedaron en esquemas
-- distintos. Se calcula sobre el catálogo para no depender de nombres.
DO $$
DECLARE
  fk RECORD;
BEGIN
  FOR fk IN
    SELECT c.conname, n.nspname AS schema_name, t.relname AS table_name
    FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    JOIN pg_class r ON r.oid = c.confrelid
    WHERE c.contype = 'f'
      AND t.relnamespace <> r.relnamespace
      AND n.nspname IN ('identity', 'catalog', 'auction', 'wallet', 'audit', 'gallery')
  LOOP
    EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', fk.schema_name, fk.table_name, fk.conname);
  END LOOP;
END $$;

-- Outbox de los productores de eventos y inbox de los consumidores.
-- outbox.payload es el evento de dominio en JSON; la capa api del servicio lo
-- traduce al mensaje protobuf al entregarlo. inbox.event_id hace idempotente
-- al consumidor.
DO $$
DECLARE
  producer TEXT;
  consumer TEXT;
BEGIN
  FOREACH producer IN ARRAY ARRAY['catalog', 'auction', 'audit'] LOOP
    EXECUTE format(
      'CREATE TABLE IF NOT EXISTS %I.outbox (
         id UUID PRIMARY KEY,
         seq BIGINT GENERATED ALWAYS AS IDENTITY,
         event_type TEXT NOT NULL,
         aggregate_id TEXT NOT NULL,
         payload JSONB NOT NULL,
         occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
         available_at TIMESTAMPTZ NOT NULL DEFAULT now(),
         attempts INTEGER NOT NULL DEFAULT 0,
         last_error TEXT,
         published_at TIMESTAMPTZ,
         CONSTRAINT outbox_attempts_check CHECK (attempts >= 0)
       )',
      producer
    );
    EXECUTE format('CREATE UNIQUE INDEX IF NOT EXISTS outbox_seq_key ON %I.outbox (seq)', producer);
    EXECUTE format(
      'CREATE INDEX IF NOT EXISTS outbox_pending_idx ON %I.outbox (available_at, seq) WHERE published_at IS NULL',
      producer
    );
  END LOOP;

  FOREACH consumer IN ARRAY ARRAY['catalog', 'auction', 'wallet', 'audit', 'gallery'] LOOP
    EXECUTE format(
      'CREATE TABLE IF NOT EXISTS %I.inbox (
         event_id TEXT PRIMARY KEY,
         event_type TEXT NOT NULL,
         processed_at TIMESTAMPTZ NOT NULL DEFAULT now()
       )',
      consumer
    );
  END LOOP;
END $$;

-- Un rol de grupo sin login por servicio, con permisos solo sobre su esquema.
-- Los usuarios con login y contraseña los crea scripts/roles/create-logins.sh a
-- partir del entorno; ninguna contraseña entra en el historial.
DO $$
DECLARE
  service TEXT;
  role_name TEXT;
BEGIN
  FOREACH service IN ARRAY ARRAY['identity', 'catalog', 'auction', 'wallet', 'audit', 'gallery'] LOOP
    role_name := service || '_rw';
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role_name) THEN
      EXECUTE format('CREATE ROLE %I NOLOGIN', role_name);
    END IF;
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO %I', service, role_name);
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO %I', service, role_name);
    EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I TO %I', service, role_name);
    EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA %I TO %I', service, role_name);
    EXECUTE format(
      'ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO %I',
      service,
      role_name
    );
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE, SELECT ON SEQUENCES TO %I', service, role_name);
  END LOOP;
END $$;

-- pg-boss administra sus propias tablas: audit_rw es dueño de la cola.
ALTER SCHEMA audit_queue OWNER TO audit_rw;

-- Vistas de compatibilidad para el monolito (se eliminan en contract).
CREATE VIEW public.users AS SELECT * FROM identity.users;
CREATE VIEW public.lots AS SELECT * FROM catalog.lots;
CREATE VIEW public.lot_images AS SELECT * FROM catalog.lot_images;
CREATE VIEW public.categories AS SELECT * FROM catalog.categories;
CREATE VIEW public.lot_categories AS SELECT * FROM catalog.lot_categories;
CREATE VIEW public.auctions AS SELECT * FROM auction.auctions;
CREATE VIEW public.bids AS SELECT * FROM auction.bids;
CREATE VIEW public.transactions AS SELECT * FROM auction.transactions;
CREATE VIEW public.wallets AS SELECT * FROM wallet.wallets;
CREATE VIEW public.payment_orders AS SELECT * FROM wallet.payment_orders;
CREATE VIEW public.wallet_entries AS SELECT * FROM wallet.wallet_entries;
CREATE VIEW public.bid_holds AS SELECT * FROM wallet.bid_holds;
CREATE VIEW public.audit_summaries AS SELECT * FROM audit.audit_summaries;
CREATE VIEW public.follows AS SELECT * FROM gallery.follows;
CREATE VIEW public.personal_galleries AS SELECT * FROM gallery.personal_galleries;
CREATE VIEW public.personal_gallery_artworks AS SELECT * FROM gallery.personal_gallery_artworks;

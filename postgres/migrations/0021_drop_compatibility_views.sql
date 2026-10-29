-- Contract de 0016.
--
-- Las vistas de compatibilidad de public existian para que el monolito siguiera
-- funcionando mientras cada contexto pasaba a su microservicio. Desde F9 el
-- monolito ya no existe y ningun servicio lee public: se eliminan.
--
-- Tambien se eliminan dos esquemas sin uso:
-- - pgboss: la cola de auditoria del monolito (audit-service usa su tabla
--   audit.audit_requests desde F7).
-- - audit_queue: reservado en 0016 para pg-boss, nunca usado.
--
-- En public solo queda schema_migrations, el registro de migraciones.

DROP VIEW IF EXISTS
  public.users,
  public.lots,
  public.lot_images,
  public.categories,
  public.lot_categories,
  public.auctions,
  public.bids,
  public.transactions,
  public.wallets,
  public.payment_orders,
  public.wallet_entries,
  public.bid_holds,
  public.audit_summaries,
  public.follows,
  public.personal_galleries,
  public.personal_gallery_artworks;

DROP SCHEMA IF EXISTS pgboss CASCADE;
DROP SCHEMA IF EXISTS audit_queue CASCADE;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name <> 'schema_migrations') THEN
    RAISE EXCEPTION 'public debe quedar solo con schema_migrations';
  END IF;
END $$;

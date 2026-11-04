-- Borra las obras de la prueba de punta a punta: titulo "E2E ..." y vendedor
-- con cuenta e2e-*, mas todo lo que depende de ellas en cada esquema (salas,
-- auditorias, galeria, sala 3D y avisos). Una sola transaccion: si algo falla,
-- no se borra nada. Las cuentas e2e-* se conservan.
--
-- No toca el bolsillo: si alguna de esas obras tiene pujas o ventas, se aborta
-- sin borrar, porque quitarlas descuadraria las retenciones y los movimientos.
-- Las imagenes del bucket quedan huerfanas; las borra
-- `npm run storage:prune` en artauction_backend.
\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE doomed ON COMMIT DROP AS
SELECT l.id
FROM catalog.lots l
JOIN identity.users u ON u.id = l.seller_id
WHERE l.title ILIKE 'e2e%' AND u.email LIKE 'e2e-%';

CREATE TEMP TABLE doomed_auctions ON COMMIT DROP AS
SELECT id FROM auction.auctions WHERE lot_id IN (SELECT id FROM doomed);

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM auction.bids WHERE auction_id IN (SELECT id FROM doomed_auctions))
     OR EXISTS (SELECT 1 FROM auction.transactions WHERE auction_id IN (SELECT id FROM doomed_auctions)) THEN
    RAISE EXCEPTION 'Hay pujas o ventas sobre obras e2e: no se borra nada';
  END IF;
END $$;

SELECT 'obras e2e a borrar' AS paso, count(*) FROM doomed;
DELETE FROM notification.notifications WHERE payload->>'lotId' IN (SELECT id::text FROM doomed);
DELETE FROM gallery.personal_gallery_artworks WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM gallery.items WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM gallery.activity WHERE object_id IN (SELECT id::text FROM doomed);
DELETE FROM auction.auctions WHERE id IN (SELECT id FROM doomed_auctions);
DELETE FROM audit.reports WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM audit.audit_summaries WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM audit.audit_requests WHERE lot_id IN (SELECT id FROM doomed);
-- Imagenes, categorias y revisiones caen en cascada con la obra.
DELETE FROM catalog.lots WHERE id IN (SELECT id FROM doomed);

COMMIT;

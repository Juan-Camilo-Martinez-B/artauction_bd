-- Borra las obras tridimensionales que no tienen modelo 3D. Desde F16 una
-- escultura, un jarron o un objeto solo se expone con su modelo real; las que
-- se subieron solo con foto se retiran de la plataforma.
--
-- Por cada obra se borra lo que depende de ella en cada esquema: salas, pujas,
-- ventas, auditorias, galeria, sala 3D y avisos. El bolsillo no pierde
-- movimientos: una venta se anula con asientos contrarios (REEMBOLSO al
-- comprador por lo que pago y ANULACION al vendedor por lo que cobro, sin la
-- comision, que la plataforma devuelve) y las retenciones de pujas vivas
-- vuelven al saldo de cada postor (LIBERACION).
--
-- Una sola transaccion. Sin `-v apply=1` es una vista previa: hace todo y lo
-- revierte, asi que tambien comprueba que el borrado real saldria bien. Volver
-- a ejecutarlo no reembolsa dos veces: las obras borradas ya no aparecen.
--
-- Las imagenes del bucket quedan huerfanas; las borra `npm run storage:prune`
-- en artauction_backend.
\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE doomed ON COMMIT DROP AS
SELECT l.id, l.title, l.status
FROM catalog.lots l
WHERE l.representation_kind = 'THREE_D'
  AND NOT EXISTS (SELECT 1 FROM catalog.lot_models m WHERE m.lot_id = l.id);

CREATE TEMP TABLE doomed_auctions ON COMMIT DROP AS
SELECT id, lot_id FROM auction.auctions WHERE lot_id IN (SELECT id FROM doomed);

-- La comision guardada al cerrar la sala dice cuanto pago el comprador (bruto)
-- y cuanto cobro el vendedor (bruto menos comision).
CREATE TEMP TABLE refunds ON COMMIT DROP AS
SELECT t.auction_id, t.lot_id, t.buyer_id, f.seller_id, f.gross_coins, f.gross_coins - f.fee_coins AS net_coins
FROM auction.transactions t
JOIN wallet.platform_fees f ON f.auction_id = t.auction_id
WHERE t.auction_id IN (SELECT id FROM doomed_auctions);

-- Retenciones de pujas vivas: confirmadas (bid_holds) y reservas sin confirmar.
CREATE TEMP TABLE released ON COMMIT DROP AS
SELECT auction_id, bidder_id AS user_id, coins
FROM wallet.bid_holds WHERE auction_id IN (SELECT id FROM doomed_auctions)
UNION ALL
SELECT auction_id, bidder_id, reserved_coins
FROM wallet.hold_reservations WHERE auction_id IN (SELECT id FROM doomed_auctions) AND status = 'PENDIENTE';

DO $$
BEGIN
  -- Una venta sin comision registrada no se sabe anular: mejor no tocar nada.
  IF EXISTS (
    SELECT 1 FROM auction.transactions t
    WHERE t.auction_id IN (SELECT id FROM doomed_auctions)
      AND NOT EXISTS (SELECT 1 FROM refunds r WHERE r.auction_id = t.auction_id)
  ) THEN
    RAISE EXCEPTION 'Hay ventas sin liquidar en el bolsillo: no se borra nada';
  END IF;
  -- Lo que se devuelve debe ser exactamente lo que el comprador canjeo.
  IF EXISTS (
    SELECT 1 FROM refunds r
    WHERE r.gross_coins <> (
      SELECT coalesce(sum(e.coins), 0) FROM wallet.wallet_entries e
      WHERE e.auction_id = r.auction_id AND e.user_id = r.buyer_id AND e.kind = 'CANJE'
    )
  ) THEN
    RAISE EXCEPTION 'El canje de alguna venta no coincide con su precio: no se borra nada';
  END IF;
  IF EXISTS (
    SELECT 1 FROM (SELECT seller_id, sum(net_coins) AS owed FROM refunds GROUP BY seller_id) s
    JOIN wallet.wallets w ON w.user_id = s.seller_id
    WHERE w.balance < s.owed
  ) THEN
    RAISE EXCEPTION 'Algun vendedor no tiene saldo para devolver sus ventas: no se borra nada';
  END IF;
END $$;

\echo
\echo 'Obras tridimensionales sin modelo 3D:'
SELECT d.status AS estado, left(d.title, 48) AS obra, u.email AS vendedor
FROM doomed d
JOIN catalog.lots l ON l.id = d.id
JOIN identity.users u ON u.id = l.seller_id
ORDER BY d.status, d.title;

\echo 'Ventas que se anulan:'
SELECT left(d.title, 40) AS obra, b.email AS comprador, r.gross_coins AS reembolso, s.email AS vendedor, r.net_coins AS anulacion
FROM refunds r
JOIN doomed d ON d.id = r.lot_id
JOIN identity.users b ON b.id = r.buyer_id
JOIN identity.users s ON s.id = r.seller_id
ORDER BY d.title;

-- Movimientos del bolsillo, con el signo que aplican al saldo.
CREATE TEMP TABLE movements ON COMMIT DROP AS
SELECT user_id, 'LIBERACION'::text AS kind, coins, auction_id, coins AS delta FROM released
UNION ALL
SELECT buyer_id, 'REEMBOLSO', gross_coins, auction_id, gross_coins FROM refunds
UNION ALL
SELECT seller_id, 'ANULACION', net_coins, auction_id, -net_coins FROM refunds;

UPDATE wallet.hold_reservations SET status = 'LIBERADA'
WHERE auction_id IN (SELECT id FROM doomed_auctions) AND status = 'PENDIENTE';
DELETE FROM wallet.bid_holds WHERE auction_id IN (SELECT id FROM doomed_auctions);

UPDATE wallet.wallets w
SET balance = w.balance + m.delta, updated_at = now()
FROM (SELECT user_id, sum(delta) AS delta FROM movements GROUP BY user_id) m
WHERE w.user_id = m.user_id;

INSERT INTO wallet.wallet_entries (user_id, kind, coins, auction_id)
SELECT user_id, kind, coins, auction_id FROM movements WHERE coins > 0;

-- La comision vuelve con el reembolso.
DELETE FROM wallet.platform_fees WHERE auction_id IN (SELECT auction_id FROM refunds);

DELETE FROM notification.notifications
WHERE payload->>'lotId' IN (SELECT id::text FROM doomed)
   OR payload->>'auctionId' IN (SELECT id::text FROM doomed_auctions);
DELETE FROM gallery.personal_gallery_artworks WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM gallery.items WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM gallery.activity
WHERE object_id IN (SELECT id::text FROM doomed) OR object_id IN (SELECT id::text FROM doomed_auctions);
DELETE FROM auction.transactions WHERE auction_id IN (SELECT id FROM doomed_auctions);
-- La sala apunta a su puja ganadora: se suelta antes de borrar las pujas.
UPDATE auction.auctions SET winning_bid_id = NULL WHERE id IN (SELECT id FROM doomed_auctions);
DELETE FROM auction.bids WHERE auction_id IN (SELECT id FROM doomed_auctions);
DELETE FROM auction.auctions WHERE id IN (SELECT id FROM doomed_auctions);
DELETE FROM audit.reports WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM audit.audit_summaries WHERE lot_id IN (SELECT id FROM doomed);
DELETE FROM audit.audit_requests WHERE lot_id IN (SELECT id FROM doomed);
-- Imagenes, categorias y revisiones caen en cascada con la obra.
DELETE FROM catalog.lots WHERE id IN (SELECT id FROM doomed);

SELECT
  (SELECT count(*) FROM doomed) AS obras,
  (SELECT count(*) FROM doomed_auctions) AS salas,
  (SELECT count(*) FROM refunds) AS ventas_anuladas,
  (SELECT coalesce(sum(gross_coins), 0) FROM refunds) AS artacoins_reembolsadas,
  (SELECT count(*) FROM released) AS retenciones_liberadas;

\if :{?apply}
COMMIT;
\echo 'Borrado aplicado.'
\else
ROLLBACK;
\echo 'Vista previa: no se borro nada. Para aplicarlo, repetir con --apply.'
\endif

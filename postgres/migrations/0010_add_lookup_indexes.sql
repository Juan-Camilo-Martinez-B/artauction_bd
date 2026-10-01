-- Índices de lectura del catálogo, del cierre de subastas y del grafo social.
-- Los índices parciales no se declaran en Prisma: viven solo en SQL.

CREATE INDEX lots_seller_id_idx ON lots (seller_id);
CREATE INDEX lots_status_idx ON lots (status);
CREATE INDEX lots_public_catalog_idx ON lots (created_at DESC)
  WHERE visibility = 'PUBLIC'
    AND status IN ('APROBADO', 'EN_SUBASTA', 'CERRADO');

CREATE INDEX lot_images_lot_id_idx ON lot_images (lot_id);

CREATE INDEX auctions_active_ends_at_idx ON auctions (ends_at)
  WHERE status = 'ACTIVA';

CREATE INDEX bids_auction_id_created_at_idx ON bids (auction_id, created_at DESC);
CREATE INDEX bids_bidder_id_idx ON bids (bidder_id);

CREATE INDEX transactions_buyer_id_idx ON transactions (buyer_id);
CREATE INDEX transactions_seller_id_idx ON transactions (seller_id);

CREATE INDEX audit_summaries_lot_id_created_at_idx ON audit_summaries (lot_id, created_at DESC);

CREATE INDEX follows_followee_id_idx ON follows (followee_id);

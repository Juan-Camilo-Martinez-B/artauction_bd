-- Cada puja guarda su idempotency_key. La unicidad llega en la migración siguiente.
-- Una puja puede ser la ganadora de como máximo una subasta.

CREATE TABLE bids (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id UUID NOT NULL,
  bidder_id UUID NOT NULL,
  amount NUMERIC(12, 2) NOT NULL,
  idempotency_key TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT bids_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES auctions (id) ON DELETE RESTRICT,
  CONSTRAINT bids_bidder_id_fkey FOREIGN KEY (bidder_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT bids_idempotency_key_check CHECK (char_length(btrim(idempotency_key)) >= 8)
);

ALTER TABLE auctions
  ADD CONSTRAINT auctions_winning_bid_id_key UNIQUE (winning_bid_id);

ALTER TABLE auctions
  ADD CONSTRAINT auctions_winning_bid_id_fkey
  FOREIGN KEY (winning_bid_id) REFERENCES bids (id) ON DELETE RESTRICT;

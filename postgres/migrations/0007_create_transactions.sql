-- Liquidación de una subasta cerrada. Hay como máximo una transacción por subasta.

CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id UUID NOT NULL,
  lot_id UUID NOT NULL,
  buyer_id UUID NOT NULL,
  seller_id UUID NOT NULL,
  amount NUMERIC(12, 2) NOT NULL,
  currency CHAR(3) NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDIENTE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT transactions_auction_id_key UNIQUE (auction_id),
  CONSTRAINT transactions_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES auctions (id) ON DELETE RESTRICT,
  CONSTRAINT transactions_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES lots (id) ON DELETE RESTRICT,
  CONSTRAINT transactions_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT transactions_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT transactions_parties_check CHECK (buyer_id <> seller_id),
  CONSTRAINT transactions_status_check CHECK (
    status IN ('PENDIENTE', 'COMPLETADA', 'FALLIDA', 'REEMBOLSADA')
  ),
  CONSTRAINT transactions_currency_check CHECK (currency ~ '^[A-Z]{3}$')
);

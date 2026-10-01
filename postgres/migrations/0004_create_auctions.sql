-- Una subasta por lote en el MVP. winning_bid_id se relaciona en la migración de pujas.
-- El reloj de cierre es ends_at. initial_ends_at no se mueve cuando hay anti-sniping.

CREATE TABLE auctions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lot_id UUID NOT NULL,
  start_price NUMERIC(12, 2) NOT NULL,
  current_price NUMERIC(12, 2) NOT NULL,
  min_increment NUMERIC(12, 2) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ NOT NULL,
  initial_ends_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'PROGRAMADA',
  winner_id UUID,
  winning_bid_id UUID,
  extension_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT auctions_lot_id_key UNIQUE (lot_id),
  CONSTRAINT auctions_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES lots (id) ON DELETE RESTRICT,
  CONSTRAINT auctions_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT auctions_status_check CHECK (status IN ('PROGRAMADA', 'ACTIVA', 'CERRADA', 'CANCELADA')),
  CONSTRAINT auctions_currency_check CHECK (currency ~ '^[A-Z]{3}$'),
  CONSTRAINT auctions_extension_count_check CHECK (extension_count >= 0)
);

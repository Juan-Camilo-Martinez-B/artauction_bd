-- Bolsillo de artacoins y pasarela simulada.
-- No se guarda el número completo de la tarjeta, la caducidad ni el código.

CREATE TABLE wallets (
  user_id UUID PRIMARY KEY,
  balance INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT wallets_balance_check CHECK (balance >= 0)
);

CREATE TABLE payment_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  coins INTEGER NOT NULL,
  amount_cents INTEGER NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  status TEXT NOT NULL,
  card_brand TEXT NOT NULL,
  card_last4 CHAR(4) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT payment_orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT payment_orders_coins_check CHECK (coins BETWEEN 1 AND 100000),
  CONSTRAINT payment_orders_amount_cents_check CHECK (amount_cents > 0),
  CONSTRAINT payment_orders_currency_check CHECK (currency ~ '^[A-Z]{3}$'),
  CONSTRAINT payment_orders_status_check CHECK (status IN ('APROBADO', 'RECHAZADO')),
  CONSTRAINT payment_orders_card_last4_check CHECK (card_last4 ~ '^[0-9]{4}$')
);

CREATE TABLE wallet_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  kind TEXT NOT NULL,
  coins INTEGER NOT NULL,
  auction_id UUID,
  payment_order_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT wallet_entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT wallet_entries_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES auctions (id) ON DELETE RESTRICT,
  CONSTRAINT wallet_entries_payment_order_id_fkey FOREIGN KEY (payment_order_id) REFERENCES payment_orders (id) ON DELETE RESTRICT,
  CONSTRAINT wallet_entries_kind_check CHECK (kind IN ('RECARGA', 'RETENCION', 'LIBERACION', 'CANJE')),
  CONSTRAINT wallet_entries_coins_check CHECK (coins > 0)
);

CREATE INDEX wallet_entries_user_id_created_at_idx ON wallet_entries (user_id, created_at DESC);

CREATE TABLE bid_holds (
  auction_id UUID NOT NULL,
  bidder_id UUID NOT NULL,
  coins INTEGER NOT NULL,
  CONSTRAINT bid_holds_pkey PRIMARY KEY (auction_id, bidder_id),
  CONSTRAINT bid_holds_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES auctions (id) ON DELETE RESTRICT,
  CONSTRAINT bid_holds_bidder_id_fkey FOREIGN KEY (bidder_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT bid_holds_coins_check CHECK (coins > 0)
);

CREATE INDEX bid_holds_bidder_id_idx ON bid_holds (bidder_id);

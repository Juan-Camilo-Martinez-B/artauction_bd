-- Expand para wallet-service.
--
-- 1. Recargas idempotentes: la clave que manda el cliente es unica por usuario
--    y se guarda una huella del contenido para detectar una clave reutilizada
--    con otros datos. Las filas antiguas quedan con la clave en NULL.
-- 2. Retenciones TCC: cada puja reserva artacoins (PENDIENTE) y la reserva se
--    confirma o se libera despues. Caduca si nadie la confirma.
-- 3. Venta: el vendedor recibe el precio menos la comision de la plataforma.

ALTER TABLE wallet.payment_orders
  ADD COLUMN idempotency_key TEXT,
  ADD COLUMN request_hash TEXT;

ALTER TABLE wallet.payment_orders
  ADD CONSTRAINT payment_orders_idempotency_key_check
    CHECK (idempotency_key IS NULL OR idempotency_key ~ '^[A-Za-z0-9_-]{8,100}$'),
  ADD CONSTRAINT payment_orders_request_hash_check
    CHECK (request_hash IS NULL OR request_hash ~ '^[0-9a-f]{64}$');

CREATE UNIQUE INDEX payment_orders_user_idempotency_key_uidx
  ON wallet.payment_orders (user_id, idempotency_key)
  WHERE idempotency_key IS NOT NULL;

CREATE TABLE wallet.hold_reservations (
  reservation_id TEXT PRIMARY KEY,
  auction_id UUID NOT NULL,
  bidder_id UUID NOT NULL,
  previous_coins INTEGER NOT NULL,
  next_coins INTEGER NOT NULL,
  reserved_coins INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDIENTE',
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT hold_reservations_status_check CHECK (status IN ('PENDIENTE', 'CONFIRMADA', 'LIBERADA')),
  CONSTRAINT hold_reservations_coins_check CHECK (
    previous_coins >= 0 AND next_coins > previous_coins AND reserved_coins = next_coins - previous_coins
  )
);

CREATE INDEX hold_reservations_pending_idx ON wallet.hold_reservations (expires_at) WHERE status = 'PENDIENTE';
CREATE INDEX hold_reservations_auction_bidder_idx ON wallet.hold_reservations (auction_id, bidder_id);

ALTER TABLE wallet.wallet_entries DROP CONSTRAINT wallet_entries_kind_check;
ALTER TABLE wallet.wallet_entries ADD CONSTRAINT wallet_entries_kind_check
  CHECK (kind IN ('RECARGA', 'RETENCION', 'LIBERACION', 'CANJE', 'VENTA'));

-- Comision cobrada por cada subasta vendida. La llave primaria por subasta hace
-- imposible cobrarla dos veces.
CREATE TABLE wallet.platform_fees (
  auction_id UUID PRIMARY KEY,
  seller_id UUID NOT NULL,
  gross_coins INTEGER NOT NULL,
  fee_coins INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT platform_fees_coins_check CHECK (gross_coins > 0 AND fee_coins >= 0 AND fee_coins <= gross_coins)
);

-- Las tablas nuevas heredan los permisos por defecto de wallet_rw (0016); se
-- conceden tambien de forma explicita por si la migracion la aplica otro rol.
GRANT SELECT, INSERT, UPDATE, DELETE ON wallet.hold_reservations, wallet.platform_fees TO wallet_rw;

-- Compra inmediata: cada sala tiene un precio con el que cualquiera puede
-- llevarse la obra al instante y cerrar la subasta. Lo calcula auction-service
-- (la salida por BUY_NOW_FACTOR, redondeada hacia arriba a multiplos de 50) y
-- no cambia durante la sala.

ALTER TABLE auction.auctions ADD COLUMN buy_now_price NUMERIC(12,2);

-- Las salas existentes reciben la misma regla, con el factor por defecto (3).
UPDATE auction.auctions SET buy_now_price = ceil(start_price * 3 / 50) * 50;

ALTER TABLE auction.auctions ALTER COLUMN buy_now_price SET NOT NULL;
ALTER TABLE auction.auctions ADD CONSTRAINT auctions_buy_now_price_check CHECK (buy_now_price > start_price);

-- Por que cerro la sala: al vencer el tiempo o por una compra inmediata.
ALTER TABLE auction.auctions ADD COLUMN closed_by TEXT;
UPDATE auction.auctions SET closed_by = 'TIME' WHERE status = 'CERRADA';
-- closed_by IS NOT NULL es explicito: NULL IN (...) da NULL y un CHECK lo dejaria pasar.
ALTER TABLE auction.auctions ADD CONSTRAINT auctions_closed_by_check CHECK (
  CASE WHEN status = 'CERRADA' THEN closed_by IS NOT NULL AND closed_by IN ('TIME', 'BUY_NOW') ELSE closed_by IS NULL END
);

-- La compra inmediata se guarda como una puja mas, marcada: asi gana la sala,
-- reutiliza la reserva del bolsillo y su clave de idempotencia.
ALTER TABLE auction.bids ADD COLUMN kind TEXT NOT NULL DEFAULT 'BID';
ALTER TABLE auction.bids ADD CONSTRAINT bids_kind_check CHECK (kind IN ('BID', 'BUY_NOW'));

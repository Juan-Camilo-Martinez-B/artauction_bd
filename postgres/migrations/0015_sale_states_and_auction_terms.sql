-- Estados de venta, duración fijada por la auditoría y pujas activas.
-- Una obra vendida sale del catálogo. Si la sala cierra vacía, la misma subasta se reprograma.

ALTER TABLE lots DROP CONSTRAINT lots_status_check;
ALTER TABLE lots ADD CONSTRAINT lots_status_check CHECK (
  status IN (
    'BORRADOR',
    'PENDIENTE_AUDITORIA',
    'APROBADO',
    'PUBLICADA',
    'REVISION_MANUAL',
    'EN_SUBASTA',
    'CERRADO',
    'VENDIDA'
  )
);

UPDATE lots SET status = 'PUBLICADA' WHERE status = 'APROBADO';

ALTER TABLE auctions
  ADD COLUMN duration_minutes INTEGER NOT NULL DEFAULT 60,
  ADD COLUMN sale_description TEXT;

ALTER TABLE auctions
  ADD CONSTRAINT auctions_duration_minutes_check CHECK (duration_minutes BETWEEN 30 AND 180);

ALTER TABLE bids
  ADD COLUMN active BOOLEAN NOT NULL DEFAULT true;

CREATE UNIQUE INDEX bids_active_amount_uidx ON bids (auction_id, amount) WHERE active;

DROP INDEX IF EXISTS lots_public_catalog_idx;
CREATE INDEX lots_public_catalog_idx ON lots (created_at DESC)
  WHERE visibility = 'PUBLIC'
    AND status IN ('APROBADO', 'PUBLICADA', 'EN_SUBASTA');

CREATE OR REPLACE FUNCTION auctions_reject_backward_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.current_price < OLD.current_price
     AND current_setting('artauction.allow_auction_rewind', true) IS DISTINCT FROM 'on' THEN
    RAISE EXCEPTION 'current_price cannot decrease from % to %', OLD.current_price, NEW.current_price
      USING ERRCODE = 'check_violation';
  END IF;

  IF NEW.ends_at < OLD.ends_at THEN
    RAISE EXCEPTION 'ends_at cannot move backwards'
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN NEW;
END;
$$;

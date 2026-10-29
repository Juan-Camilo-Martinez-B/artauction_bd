-- Contract de 0018.
--
-- Desde F7 audit-service envia el vendedor y el titulo en AuditCompleted, y la
-- auditoria del monolito ya no crea subastas. El trigger que completaba la
-- copia desde catalog.lots era la unica lectura entre esquemas: se elimina.
--
-- Precondicion: ninguna subasta sin copia. Si existiera alguna, la migracion
-- falla en lugar de dejar datos que auction-service no puede validar.

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM auction.auctions WHERE seller_id IS NULL OR lot_title IS NULL) THEN
    RAISE EXCEPTION 'hay subastas sin seller_id o lot_title; completar la copia antes de 0020';
  END IF;
END $$;

DROP TRIGGER IF EXISTS auctions_fill_lot_copy ON auction.auctions;
DROP FUNCTION IF EXISTS auction.fill_lot_copy();

ALTER TABLE auction.auctions
  ALTER COLUMN seller_id SET NOT NULL,
  ALTER COLUMN lot_title SET NOT NULL;

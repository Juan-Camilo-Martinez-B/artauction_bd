-- Expand para auction-service.
--
-- auction-service valida las pujas sin leer el esquema catalog: guarda una
-- copia del vendedor y del titulo de la obra en cada subasta. La copia llega en
-- los eventos AuditCompleted y LotPublished y en la apertura manual.
--
-- Transitorio: hasta que audit-service exista (F7), la auditoria del monolito
-- crea subastas sin esos datos. Un trigger los completa desde catalog.lots solo
-- cuando vienen vacios. Es la unica lectura entre esquemas y se elimina en la
-- migracion de contract de F7.

ALTER TABLE auction.auctions
  ADD COLUMN seller_id UUID,
  ADD COLUMN lot_title TEXT;

UPDATE auction.auctions AS a
   SET seller_id = l.seller_id,
       lot_title = l.title
  FROM catalog.lots AS l
 WHERE l.id = a.lot_id
   AND (a.seller_id IS NULL OR a.lot_title IS NULL);

CREATE OR REPLACE FUNCTION auction.fill_lot_copy()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
BEGIN
  IF NEW.seller_id IS NULL OR NEW.lot_title IS NULL THEN
    SELECT COALESCE(NEW.seller_id, l.seller_id), COALESCE(NEW.lot_title, l.title)
      INTO NEW.seller_id, NEW.lot_title
      FROM catalog.lots AS l
     WHERE l.id = NEW.lot_id;
  END IF;
  RETURN NEW;
END;
$$;

-- SECURITY DEFINER: corre con el dueno de la funcion (quien aplica las
-- migraciones), asi auction_rw no necesita permisos sobre catalog.
REVOKE ALL ON FUNCTION auction.fill_lot_copy() FROM PUBLIC;

CREATE TRIGGER auctions_fill_lot_copy
BEFORE INSERT ON auction.auctions
FOR EACH ROW
EXECUTE FUNCTION auction.fill_lot_copy();

-- Indices para el planificador: subastas por abrir y por cerrar.
CREATE INDEX IF NOT EXISTS auctions_due_to_open_idx ON auction.auctions (starts_at) WHERE status = 'PROGRAMADA';
CREATE INDEX IF NOT EXISTS auctions_due_to_close_idx ON auction.auctions (ends_at) WHERE status = 'ACTIVA';

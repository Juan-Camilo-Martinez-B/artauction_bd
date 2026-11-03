-- Propiedad en la galeria: solo se exhibe lo que es de uno.
--
-- PROYECTO: proyecto propio sin auditar (catalog.lots en PERSONAL). Pasa a
-- PROPIA cuando el autor lo envia al catalogo.
-- PROPIA: obra del autor en el catalogo que todavia no se vende.
-- GANADA: obra ganada en subasta. Al venderse, la obra deja de ser del autor.
-- GRATUITA desaparece: colgaba cualquier obra publica ajena (era de prueba).

DELETE FROM gallery.items WHERE source = 'GRATUITA';

-- Una obra con dueno por subasta ya no es del autor.
DELETE FROM gallery.items AS own
WHERE own.source = 'PROPIA'
  AND EXISTS (
    SELECT 1 FROM gallery.items AS won
    WHERE won.source = 'GANADA' AND won.lot_id = own.lot_id AND won.owner_id <> own.owner_id
  );

-- La sala 3D solo conserva las obras que su dueno tiene en la galeria. Esto
-- descuelga las anadidas como prueba y las vendidas en la sala del autor.
DELETE FROM gallery.personal_gallery_artworks AS placed
USING gallery.personal_galleries AS room
WHERE placed.gallery_id = room.id
  AND NOT EXISTS (
    SELECT 1 FROM gallery.items AS item
    WHERE item.owner_id = room.owner_id AND item.lot_id = placed.lot_id
  );

ALTER TABLE gallery.items DROP CONSTRAINT items_source_check;
ALTER TABLE gallery.items ADD CONSTRAINT items_source_check CHECK (source IN ('PROYECTO', 'PROPIA', 'GANADA'));

-- Toda obra de la galeria es una obra del catalogo: sin obra no hay dueno.
ALTER TABLE gallery.items ALTER COLUMN lot_id SET NOT NULL;

-- Una sola entrada por obra y dueno, para comprobar la propiedad al colgar.
CREATE UNIQUE INDEX items_owner_lot_uidx ON gallery.items (owner_id, lot_id);

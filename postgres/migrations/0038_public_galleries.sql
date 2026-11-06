-- Explorar galerias publicas.
--
-- 1. Vista previa de cada obra: gallery-service la pide a catalog la primera vez
--    que la obra se expone y la guarda aqui.
-- 2. Lo que ya se ve en el catalogo tambien se ve en la galeria publica de quien
--    lo publico. Desde ahora lo hace el evento LotListed; aqui, lo ya publicado.
-- 3. Indice para listar las galerias: solo las obras publicas de cada persona.

ALTER TABLE gallery.items ADD COLUMN preview_url TEXT;

UPDATE gallery.items i
SET visibility = 'PUBLIC'
FROM catalog.lots l
WHERE l.id = i.lot_id
  AND i.source = 'PROPIA'
  AND l.visibility = 'PUBLIC'
  AND l.status IN ('PUBLICADA', 'EN_SUBASTA');

CREATE INDEX items_public_owner_idx ON gallery.items (owner_id, acquired_at DESC) WHERE visibility = 'PUBLIC';

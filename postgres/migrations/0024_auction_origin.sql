-- Origen de cada subasta (F11), para que la rotacion del catalogo solo recicle
-- sus propias salas:
--   SCHEDULED  la programo el sistema al aprobar la obra (ventana de 15 min a 48 h);
--   MANUAL     la abrio el vendedor o un administrador con sus propios terminos;
--   ROTATION   la creo la cartelera de subastas rotativas.
-- Una sala ROTATION que cerro sin pujas queda PROGRAMADA lejos; la rotacion la
-- adelanta cuando necesita llenar un hueco. Las filas existentes nacieron del
-- programador o de una apertura manual que no se puede distinguir: quedan SCHEDULED.
ALTER TABLE auction.auctions
  ADD COLUMN origin TEXT NOT NULL DEFAULT 'SCHEDULED',
  ADD CONSTRAINT auctions_origin_check CHECK (origin IN ('SCHEDULED', 'MANUAL', 'ROTATION'));

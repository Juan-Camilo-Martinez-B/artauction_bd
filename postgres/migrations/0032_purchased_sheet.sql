-- Ficha guardada de una obra comprada. Al venderse, la obra sale del catalogo
-- publico y su ficha original ya no se puede abrir; la galeria del comprador
-- guarda una copia fija, como certificado de la compra: los datos de la obra,
-- su imagen, el score de autenticidad, el precio pagado, la fecha y si fue por
-- subasta o por compra inmediata. La escribe gallery-service; las compras
-- anteriores la reciben la primera vez que se abre su ficha.
ALTER TABLE gallery.items ADD COLUMN sheet JSONB;

-- Solo una obra ganada tiene ficha guardada.
ALTER TABLE gallery.items ADD CONSTRAINT items_sheet_check CHECK (sheet IS NULL OR (source = 'GANADA' AND jsonb_typeof(sheet) = 'object'));

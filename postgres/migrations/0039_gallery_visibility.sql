-- Visibilidad de la galeria 3D. Es privada hasta que su duena decida abrirla:
-- solo una galeria publica se muestra a otras personas y sale al explorar.

ALTER TABLE gallery.personal_galleries
  ADD COLUMN visibility TEXT NOT NULL DEFAULT 'PRIVATE' CHECK (visibility IN ('PUBLIC', 'PRIVATE'));

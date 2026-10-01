-- Claves de Cloud Storage y hash perceptual. El binario no se guarda en Postgres.

CREATE TABLE lot_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lot_id UUID NOT NULL,
  object_key TEXT NOT NULL,
  position INTEGER NOT NULL,
  perceptual_hash TEXT,
  width_px INTEGER,
  height_px INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT lot_images_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES lots (id) ON DELETE CASCADE,
  CONSTRAINT lot_images_lot_id_position_key UNIQUE (lot_id, position),
  CONSTRAINT lot_images_position_check CHECK (position >= 0),
  CONSTRAINT lot_images_object_key_check CHECK (char_length(btrim(object_key)) > 0),
  CONSTRAINT lot_images_dimensions_check CHECK (
    (width_px IS NULL AND height_px IS NULL)
    OR (width_px > 0 AND height_px > 0)
  )
);

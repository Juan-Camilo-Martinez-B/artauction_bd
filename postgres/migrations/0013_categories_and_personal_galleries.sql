-- Categorías de catálogo y galería personal 3D.
-- Una obra puede tener varias categorías y, como máximo, una principal.
-- Las obras ya cargadas solo se clasifican cuando el material o el título lo permiten.
-- El boceto sin ficha queda sin categoría.

CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  image_key TEXT,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO categories (id, name, slug, description)
VALUES
  ('d0000000-0000-4000-8000-000000000001', 'Pinturas', 'pinturas', 'Óleo, acrílico y otras obras sobre un soporte plano.'),
  ('d0000000-0000-4000-8000-000000000002', 'Fotografía', 'fotografia', 'Imagen fotográfica impresa o digital.'),
  ('d0000000-0000-4000-8000-000000000003', 'Escultura', 'escultura', 'Volumen exento, pensado para verse en el espacio.'),
  ('d0000000-0000-4000-8000-000000000004', 'Cerámica y jarrones', 'ceramica', 'Barro, porcelana y piezas de torno.'),
  ('d0000000-0000-4000-8000-000000000005', 'Objetos artísticos', 'objetos-artisticos', 'Relojes, piezas decorativas y objetos de diseño.'),
  ('d0000000-0000-4000-8000-000000000006', 'Arte digital', 'arte-digital', 'Obra nacida o exhibida como imagen digital.'),
  ('d0000000-0000-4000-8000-000000000007', 'Otras', 'otras', 'Piezas que no encajan en las categorías anteriores.')
ON CONFLICT (slug) DO NOTHING;

ALTER TABLE lots
  ADD COLUMN representation_kind TEXT;

ALTER TABLE lots
  ADD CONSTRAINT lots_representation_kind_check CHECK (
    representation_kind IS NULL OR representation_kind IN ('TWO_D', 'THREE_D', 'OTHER')
  );

CREATE TABLE lot_categories (
  lot_id UUID NOT NULL,
  category_id UUID NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT false,
  PRIMARY KEY (lot_id, category_id),
  CONSTRAINT lot_categories_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES lots (id) ON DELETE CASCADE,
  CONSTRAINT lot_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX lot_categories_one_primary_idx
  ON lot_categories (lot_id)
  WHERE is_primary;

CREATE INDEX lot_categories_category_id_idx ON lot_categories (category_id);

-- Retrato al óleo: pintura mural. Reloj: objeto tridimensional. Estudio acrílico: pintura.
-- No se inventa categoría para el boceto sin ficha.

INSERT INTO lot_categories (lot_id, category_id, is_primary)
SELECT 'b0000000-0000-4000-8000-000000000001', id, true
FROM categories
WHERE slug = 'pinturas'
  AND EXISTS (SELECT 1 FROM lots WHERE id = 'b0000000-0000-4000-8000-000000000001')
ON CONFLICT DO NOTHING;

INSERT INTO lot_categories (lot_id, category_id, is_primary)
SELECT 'b0000000-0000-4000-8000-000000000002', id, true
FROM categories
WHERE slug = 'objetos-artisticos'
  AND EXISTS (SELECT 1 FROM lots WHERE id = 'b0000000-0000-4000-8000-000000000002')
ON CONFLICT DO NOTHING;

INSERT INTO lot_categories (lot_id, category_id, is_primary)
SELECT 'b0000000-0000-4000-8000-000000000003', id, true
FROM categories
WHERE slug = 'pinturas'
  AND EXISTS (SELECT 1 FROM lots WHERE id = 'b0000000-0000-4000-8000-000000000003')
ON CONFLICT DO NOTHING;

UPDATE lots
SET representation_kind = 'TWO_D'
WHERE id IN (
  'b0000000-0000-4000-8000-000000000001',
  'b0000000-0000-4000-8000-000000000003'
)
AND representation_kind IS NULL;

UPDATE lots
SET representation_kind = 'THREE_D'
WHERE id = 'b0000000-0000-4000-8000-000000000002'
  AND representation_kind IS NULL;

UPDATE lots
SET representation_kind = 'TWO_D'
WHERE id = 'b0000000-0000-4000-8000-000000000004'
  AND materials = 'Grafito sobre papel'
  AND representation_kind IS NULL;

CREATE TABLE personal_galleries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  preferences JSONB NOT NULL DEFAULT '{}'::jsonb,
  suggested_config JSONB,
  applied_config JSONB,
  config_version INTEGER NOT NULL DEFAULT 1,
  customization_status TEXT NOT NULL DEFAULT 'SIN_PERSONALIZAR',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT personal_galleries_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT personal_galleries_status_check CHECK (
    customization_status IN ('SIN_PERSONALIZAR', 'PERSONALIZADA', 'EDITADA')
  )
);

CREATE TABLE personal_gallery_artworks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gallery_id UUID NOT NULL,
  lot_id UUID NOT NULL,
  pos_x DOUBLE PRECISION NOT NULL DEFAULT 0,
  pos_y DOUBLE PRECISION NOT NULL DEFAULT 1.5,
  pos_z DOUBLE PRECISION NOT NULL DEFAULT -3.8,
  rot_y DOUBLE PRECISION NOT NULL DEFAULT 0,
  scale DOUBLE PRECISION NOT NULL DEFAULT 1,
  support TEXT NOT NULL DEFAULT 'WALL',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT personal_gallery_artworks_gallery_id_fkey FOREIGN KEY (gallery_id) REFERENCES personal_galleries (id) ON DELETE CASCADE,
  CONSTRAINT personal_gallery_artworks_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES lots (id) ON DELETE RESTRICT,
  CONSTRAINT personal_gallery_artworks_support_check CHECK (
    support IN ('WALL', 'PEDESTAL', 'FLOOR', 'PLATFORM', 'NICHE')
  ),
  CONSTRAINT personal_gallery_artworks_scale_check CHECK (scale > 0 AND scale <= 3),
  UNIQUE (gallery_id, lot_id)
);

CREATE INDEX personal_gallery_artworks_lot_id_idx ON personal_gallery_artworks (lot_id);

-- Obra publicada por un vendedor. El estado sigue el ciclo de vida del lote.

CREATE TABLE lots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id UUID NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  artist_name TEXT,
  creation_year INTEGER,
  materials TEXT NOT NULL,
  width_cm NUMERIC(8, 2),
  height_cm NUMERIC(8, 2),
  depth_cm NUMERIC(8, 2),
  provenance TEXT,
  status TEXT NOT NULL DEFAULT 'BORRADOR',
  visibility TEXT NOT NULL DEFAULT 'PRIVATE',
  authenticity_score SMALLINT,
  suggested_price_min NUMERIC(12, 2),
  suggested_price_max NUMERIC(12, 2),
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT lots_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES users (id) ON DELETE RESTRICT,
  CONSTRAINT lots_status_check CHECK (
    status IN (
      'BORRADOR',
      'PENDIENTE_AUDITORIA',
      'APROBADO',
      'REVISION_MANUAL',
      'EN_SUBASTA',
      'CERRADO'
    )
  ),
  CONSTRAINT lots_visibility_check CHECK (visibility IN ('PUBLIC', 'PRIVATE')),
  CONSTRAINT lots_title_check CHECK (char_length(btrim(title)) >= 3),
  CONSTRAINT lots_currency_check CHECK (currency ~ '^[A-Z]{3}$'),
  CONSTRAINT lots_creation_year_check CHECK (creation_year IS NULL OR creation_year BETWEEN 1 AND 2100)
);

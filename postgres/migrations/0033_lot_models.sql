-- Modelo 3D de una obra tridimensional: un archivo GLB (el formato que exporta
-- Blender) que el vendedor sube de forma opcional. Con el, la sala 3D muestra
-- la pieza completa y en volumen real en lugar de su foto.
--
-- catalog-service valida el archivo antes de registrarlo (cabecera glTF, sin
-- recursos externos, tamano y triangulos dentro de los limites) y guarda lo
-- medido: la auditoria lo usa como evidencia. Los triangulos no fijan precio.
CREATE TABLE catalog.lot_models (
  lot_id UUID PRIMARY KEY REFERENCES catalog.lots(id) ON DELETE CASCADE,
  object_key TEXT NOT NULL,
  bytes INTEGER NOT NULL,
  triangle_count INTEGER NOT NULL,
  vertex_count INTEGER NOT NULL,
  -- Caja que envuelve el modelo, en sus unidades: sirve para escalarlo a las
  -- medidas declaradas y para comparar sus proporciones con ellas.
  size_x NUMERIC(14,6) NOT NULL,
  size_y NUMERIC(14,6) NOT NULL,
  size_z NUMERIC(14,6) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT lot_models_object_key_check CHECK (object_key ~ '^lots/[0-9a-f-]{36}/model-[A-Za-z0-9_-]+\.glb$'),
  -- 30 MB como maximo: la sala debe cargar rapido.
  CONSTRAINT lot_models_bytes_check CHECK (bytes > 0 AND bytes <= 31457280),
  -- Ni un esbozo de pocas caras ni un modelo que vuelva lenta la sala.
  CONSTRAINT lot_models_triangles_check CHECK (triangle_count BETWEEN 1000 AND 300000),
  CONSTRAINT lot_models_vertices_check CHECK (vertex_count > 0),
  CONSTRAINT lot_models_size_check CHECK (size_x > 0 AND size_y > 0 AND size_z > 0)
);

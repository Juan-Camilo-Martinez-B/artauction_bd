-- Obras de ejemplo de Marta Vendedora, con imagen, score y resumen de auditoría.
-- El borrador no tiene resumen: todavía no entra a la cola.

INSERT INTO lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
)
VALUES
  (
    'b0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000002',
    'Retrato de la costa',
    'Óleo firmado. La tela y el bastidor coinciden con el último cuarto del siglo XIX.',
    'Elena Vásquez',
    1894,
    'Óleo sobre lienzo',
    60.00, 80.00, 3.50,
    'Colección particular, Cartagena.',
    'APROBADO',
    'PUBLIC',
    86,
    2400.00, 3800.00,
    'USD'
  ),
  (
    'b0000000-0000-4000-8000-000000000002',
    'a0000000-0000-4000-8000-000000000002',
    'Reloj de carruaje',
    'Caja de latón esmaltada. El mecanismo está completo y la esfera no fue reemplazada.',
    'Taller anónimo',
    1910,
    'Latón y esmalte',
    12.00, 12.00, 6.00,
    'Taller familiar, Bogotá.',
    'APROBADO',
    'PUBLIC',
    74,
    400.00, 700.00,
    'USD'
  ),
  (
    'b0000000-0000-4000-8000-000000000003',
    'a0000000-0000-4000-8000-000000000002',
    'Estudio con pigmento moderno',
    'La ficha declara 1760, pero el aglutinante descrito es acrílico. Queda en revisión manual.',
    'Atribución dudosa',
    1760,
    'Acrílico sobre tabla',
    40.00, 50.00, 2.00,
    'Procedencia no documentada.',
    'REVISION_MANUAL',
    'PRIVATE',
    28,
    50.00, 120.00,
    'USD'
  ),
  (
    'b0000000-0000-4000-8000-000000000004',
    'a0000000-0000-4000-8000-000000000002',
    'Boceto sin ficha',
    'Borrador del vendedor. No tiene auditoría ni subasta.',
    NULL,
    NULL,
    'Grafito sobre papel',
    21.00, 29.70, NULL,
    NULL,
    'BORRADOR',
    'PRIVATE',
    NULL,
    NULL, NULL,
    'USD'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO lot_images (id, lot_id, object_key, position, perceptual_hash, width_px, height_px)
VALUES
  (
    'b1000000-0000-4000-8000-000000000001',
    'b0000000-0000-4000-8000-000000000001',
    'lots/b0000000-0000-4000-8000-000000000001/0.jpg',
    0, 'a4c91e0b77d2', 1600, 2000
  ),
  (
    'b1000000-0000-4000-8000-000000000002',
    'b0000000-0000-4000-8000-000000000002',
    'lots/b0000000-0000-4000-8000-000000000002/0.jpg',
    0, '11ab90c4de77', 1200, 1200
  ),
  (
    'b1000000-0000-4000-8000-000000000003',
    'b0000000-0000-4000-8000-000000000003',
    'lots/b0000000-0000-4000-8000-000000000003/0.jpg',
    0, '90ff12ab3344', 1400, 1600
  ),
  (
    'b1000000-0000-4000-8000-000000000004',
    'b0000000-0000-4000-8000-000000000004',
    'lots/b0000000-0000-4000-8000-000000000004/0.jpg',
    0, NULL, 800, 1100
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_summaries (
  id, lot_id, score, price_min, price_max, verdict, has_critical_inconsistency,
  mongo_report_id, model_name, prompt_version
)
VALUES
  (
    'e0000000-0000-4000-8000-000000000001',
    'b0000000-0000-4000-8000-000000000001',
    86, 2400.00, 3800.00, 'APROBADO', false,
    'f0000000-0000-4000-8000-000000000001',
    'gemini-2.5-flash', 'v1'
  ),
  (
    'e0000000-0000-4000-8000-000000000002',
    'b0000000-0000-4000-8000-000000000002',
    74, 400.00, 700.00, 'APROBADO', false,
    'f0000000-0000-4000-8000-000000000002',
    'gemini-2.5-flash', 'v1'
  ),
  (
    'e0000000-0000-4000-8000-000000000003',
    'b0000000-0000-4000-8000-000000000003',
    28, 50.00, 120.00, 'REVISION_MANUAL', true,
    'f0000000-0000-4000-8000-000000000003',
    'gemini-2.5-flash', 'v1'
  )
ON CONFLICT (id) DO NOTHING;

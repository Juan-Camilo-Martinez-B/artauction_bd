-- Catálogo público tomado de la colección de dominio público del Metropolitan Museum of Art.
-- Las imágenes viven en el CDN del museo. Postgres guarda la ficha y la dirección.

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000032aa',
  'a0000000-0000-4000-8000-000000000002',
  'Study in Black and Green (Oil Sketch)',
  'Study in Black and Green (Oil Sketch) entra al catálogo como pintura de John White Alexander, datada en ca. 1906. Material: Oil on canvas. Contexto: American.',
  'John White Alexander',
  1906,
  'Oil on canvas',
  40.60,
  50.80,
  NULL,
  'Marguerite and Frank A. Cosgrove Jr. Fund, 1995',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  92,
  4300.00,
  5200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000032aa',
  'c0000000-0000-4000-8000-0000000032aa',
  'https://images.metmuseum.org/CRDImages/ad/web-large/DP105798.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000032aa', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000000295d',
  'a0000000-0000-4000-8000-000000000002',
  'Wyoming Valley, Pennsylvania',
  'Wyoming Valley, Pennsylvania entra al catálogo como pintura de Jasper Francis Cropsey, datada en 1864. Material: Oil on canvas. Contexto: American.',
  'Jasper Francis Cropsey',
  1864,
  'Oil on canvas',
  61.00,
  38.10,
  NULL,
  'Bequest of Collis P. Huntington, 1900',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  77,
  2675.00,
  3575.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000000295d',
  'c0000000-0000-4000-8000-00000000295d',
  'https://images.metmuseum.org/CRDImages/ad/web-large/ap25.110.63.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000000295d', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000003259',
  'a0000000-0000-4000-8000-000000000002',
  'Family Group of Four on Sofa',
  'Family Group of Four on Sofa entra al catálogo como pintura de un artista no identificado, datada en ca. 1830s. Material: Oil on canvas. Contexto: American.',
  NULL,
  NULL,
  'Oil on canvas',
  132.70,
  91.40,
  NULL,
  'Gift of Edgar William and Bernice Chrysler Garbisch, 1970',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  89,
  3425.00,
  4325.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000003259',
  'c0000000-0000-4000-8000-000000003259',
  'https://images.metmuseum.org/CRDImages/ad/web-large/ap1970.283.4.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000003259', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000002f5a',
  'a0000000-0000-4000-8000-000000000002',
  'Landscape with Goatherd',
  'Landscape with Goatherd entra al catálogo como pintura de John Singer Sargent, datada en 1890–1891. Material: Oil on canvas. Contexto: American.',
  'John Singer Sargent',
  1890,
  'Oil on canvas',
  81.00,
  61.60,
  NULL,
  'Gift of Mrs. Francis Ormond, 1950',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  76,
  4675.00,
  5575.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000002f5a',
  'c0000000-0000-4000-8000-000000002f5a',
  'https://images.metmuseum.org/CRDImages/ad/web-large/DT2941.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000002f5a', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000002b80',
  'a0000000-0000-4000-8000-000000000002',
  'Searchlight on Harbor Entrance, Santiago de Cuba',
  'Searchlight on Harbor Entrance, Santiago de Cuba entra al catálogo como pintura de Winslow Homer, datada en 1902. Material: Oil on canvas. Contexto: American.',
  'Winslow Homer',
  1902,
  'Oil on canvas',
  128.30,
  77.50,
  NULL,
  'Gift of George A. Hearn, 1906',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  78,
  6300.00,
  7200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000002b80',
  'c0000000-0000-4000-8000-000000002b80',
  'https://images.metmuseum.org/CRDImages/ad/web-large/DP-21455-001.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000002b80', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000000309b',
  'a0000000-0000-4000-8000-000000000002',
  'Two Arab Women',
  'Two Arab Women entra al catálogo como pintura de John Singer Sargent, datada en 1905 (?). Material: Oil on canvas. Contexto: American.',
  'John Singer Sargent',
  1905,
  'Oil on canvas',
  64.10,
  53.30,
  NULL,
  'Gift of Mrs. Francis Ormond, 1950',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  85,
  3175.00,
  4075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000000309b',
  'c0000000-0000-4000-8000-00000000309b',
  'https://images.metmuseum.org/CRDImages/ad/web-large/DT212006.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000000309b', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000002e465',
  'a0000000-0000-4000-8000-000000000002',
  'Vase of Flowers Resting on Foliate Scrolls',
  'Vase of Flowers Resting on Foliate Scrolls entra al catálogo como escultura de French Painter, datada en 1770–90. Material: Oil on canvas.',
  'French Painter',
  1770,
  'Oil on canvas',
  78.10,
  117.20,
  NULL,
  'Gift of J. Pierpont Morgan, 1906',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  71,
  5175.00,
  6075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000002e465',
  'c0000000-0000-4000-8000-00000002e465',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP278046.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000002e465', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000070156',
  'a0000000-0000-4000-8000-000000000002',
  'Valley with Fir (Shade on the Mountain)',
  'Valley with Fir (Shade on the Mountain) entra al catálogo como pintura de Henri-Edmond Cross (Henri-Edmond Delacroix), datada en 1909. Material: Oil on canvas.',
  'Henri-Edmond Cross (Henri-Edmond Delacroix)',
  1909,
  'Oil on canvas',
  90.20,
  73.70,
  NULL,
  'Robert Lehman Collection, 1975',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  82,
  6175.00,
  7075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000070156',
  'c0000000-0000-4000-8000-000000070156',
  'https://images.metmuseum.org/CRDImages/rl/web-large/DT3110.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000070156', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000070117',
  'a0000000-0000-4000-8000-000000000002',
  'Piazza San Marco, Venice',
  'Piazza San Marco, Venice entra al catálogo como pintura de Luca Carlevaris, datada en ca. 1709. Material: Oil on canvas.',
  'Luca Carlevaris',
  1709,
  'Oil on canvas',
  120.00,
  50.50,
  NULL,
  'Robert Lehman Collection, 1975',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  71,
  2925.00,
  3825.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000070117',
  'c0000000-0000-4000-8000-000000070117',
  'https://images.metmuseum.org/CRDImages/rl/web-large/DT3063.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000070117', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000000293d',
  'a0000000-0000-4000-8000-000000000002',
  'Augustus Saint-Gaudens',
  'Augustus Saint-Gaudens entra al catálogo como pintura de Kenyon Cox, datada en 1887, replica 1908. Material: Oil on canvas. Contexto: American.',
  'Kenyon Cox',
  1887,
  'Oil on canvas',
  119.70,
  85.10,
  NULL,
  'Gift of friends of the artist, through August F. Jaccaci, 1908',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  71,
  3300.00,
  4200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000000293d',
  'c0000000-0000-4000-8000-00000000293d',
  'https://images.metmuseum.org/CRDImages/ad/web-large/DT2583.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000000293d', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000c7490',
  'a0000000-0000-4000-8000-000000000002',
  'Lady with a Turkish Headdress (hotos)',
  'Lady with a Turkish Headdress (hotos) entra al catálogo como pintura de un artista no identificado, datada en mid-17th century. Material: Oil on canvas.',
  NULL,
  NULL,
  'Oil on canvas',
  NULL,
  NULL,
  NULL,
  'Purchase, 2017 NoRuz at The Met Benefit, 2019',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  72,
  3675.00,
  4575.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000c7490',
  'c0000000-0000-4000-8000-0000000c7490',
  'https://images.metmuseum.org/CRDImages/is/web-large/LC-2019_299.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000c7490', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000e0691',
  'a0000000-0000-4000-8000-000000000002',
  'Sisters',
  'Sisters entra al catálogo como pintura de un artista no identificado, datada en early 19th century. Material: Oil on canvas.',
  NULL,
  NULL,
  'Oil on canvas',
  NULL,
  NULL,
  NULL,
  'Purchase, 2017 and 2018 NoRuz at The Met Benefits, 2024',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  77,
  5675.00,
  6575.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000e0691',
  'c0000000-0000-4000-8000-0000000e0691',
  'https://images.metmuseum.org/CRDImages/is/web-large/LC-2024_572.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000e0691', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000002c6a',
  'a0000000-0000-4000-8000-000000000002',
  'Autumn Study, View over Hanging Rock, Newport, R.I.',
  'Autumn Study, View over Hanging Rock, Newport, R.I. entra al catálogo como pintura de John La Farge, datada en 1868. Material: Oil on canvas. Contexto: American.',
  'John La Farge',
  1868,
  'Oil on canvas',
  64.10,
  76.80,
  NULL,
  'Gift of Dr. Frank Jewett Mather Jr., 1949',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  78,
  3175.00,
  4075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000002c6a',
  'c0000000-0000-4000-8000-000000002c6a',
  'https://images.metmuseum.org/CRDImages/ad/web-large/ap49.76.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000002c6a', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000002f63',
  'a0000000-0000-4000-8000-000000000002',
  'Mannequin in the Snow',
  'Mannequin in the Snow entra al catálogo como pintura de John Singer Sargent, datada en ca. 1891–93. Material: Oil on canvas. Contexto: American.',
  'John Singer Sargent',
  1891,
  'Oil on canvas',
  76.20,
  63.50,
  NULL,
  'Gift of Mrs. Francis Ormond, 1950',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  85,
  5800.00,
  6700.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000002f63',
  'c0000000-0000-4000-8000-000000002f63',
  'https://images.metmuseum.org/CRDImages/ad/web-large/DP161223.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000002f63', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000000295e',
  'a0000000-0000-4000-8000-000000000002',
  'Skating on the Wissahickon',
  'Skating on the Wissahickon entra al catálogo como pintura de Johan Mengels Culverhouse, datada en 1875. Material: Oil on canvas. Contexto: American.',
  'Johan Mengels Culverhouse',
  1875,
  'Oil on canvas',
  95.30,
  61.00,
  NULL,
  'Purchase, Rogers, Morris K. Jesup and Maria DeWitt Jesup Funds, and Charles and Anita Blatt Gift, 1974',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  78,
  2800.00,
  3700.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000000295e',
  'c0000000-0000-4000-8000-00000000295e',
  'https://images.metmuseum.org/CRDImages/ad/web-large/ap1974.263.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000000295e', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000007015c',
  'a0000000-0000-4000-8000-000000000002',
  'Tahitian Women Bathing',
  'Tahitian Women Bathing entra al catálogo como pintura de Paul Gauguin, datada en 1892. Material: Oil on paper, laid down on canvas.',
  'Paul Gauguin',
  1892,
  'Oil on paper, laid down on canvas',
  89.50,
  109.90,
  NULL,
  'Robert Lehman Collection, 1975',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  88,
  2300.00,
  3200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000007015c',
  'c0000000-0000-4000-8000-00000007015c',
  'https://images.metmuseum.org/CRDImages/rl/web-large/DP-34475-001.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000007015c', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000053167',
  'a0000000-0000-4000-8000-000000000002',
  'Arcadian landscape',
  'Arcadian landscape entra al catálogo como pintura de George Barret, the younger, datada en 1820–42. Material: Watercolor over graphite.',
  'George Barret, the younger',
  1820,
  'Watercolor over graphite',
  26.40,
  20.00,
  NULL,
  'Gift of Michael Hall Esquire, in honor of William Valentiner, 2000',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  83,
  1925.00,
  2825.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000053167',
  'c0000000-0000-4000-8000-000000053167',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP800739.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000053167', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000005259a',
  'a0000000-0000-4000-8000-000000000002',
  'Landscape',
  'Landscape entra al catálogo como pintura de Henri-Joseph Harpignies, datada en 1900. Material: Watercolor, graphite.',
  'Henri-Joseph Harpignies',
  1900,
  'Watercolor, graphite',
  19.80,
  28.10,
  NULL,
  'Bequest of David Gardiner, 1928',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  78,
  3550.00,
  4450.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000005259a',
  'c0000000-0000-4000-8000-00000005259a',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP806747.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000005259a', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000704c0',
  'a0000000-0000-4000-8000-000000000002',
  'Landscape',
  'Landscape entra al catálogo como pintura de Auguste Renoir, datada en 1889. Material: Watercolor on off-white laid paper.',
  'Auguste Renoir',
  1889,
  'Watercolor on off-white laid paper',
  31.90,
  22.60,
  NULL,
  'Robert Lehman Collection, 1975',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  72,
  4425.00,
  5325.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000704c0',
  'c0000000-0000-4000-8000-0000000704c0',
  'https://images.metmuseum.org/CRDImages/rl/web-large/CT_28246.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000704c0', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000052f4e',
  'a0000000-0000-4000-8000-000000000002',
  'Landscape',
  'Landscape entra al catálogo como pintura de Constant Troyon, datada en 1825–65. Material: Watercolor.',
  'Constant Troyon',
  1825,
  'Watercolor',
  18.10,
  12.90,
  NULL,
  'Mr. and Mrs. Isaac D. Fletcher Collection, Bequest of Isaac D. Fletcher, 1917',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  92,
  4175.00,
  5075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000052f4e',
  'c0000000-0000-4000-8000-000000052f4e',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP808407.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000052f4e', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000000342a',
  'a0000000-0000-4000-8000-000000000002',
  'Mountain Landscape',
  'Mountain Landscape entra al catálogo como pintura de Alexander H. Wyant. Material: Watercolor on brown paper. Contexto: American.',
  'Alexander H. Wyant',
  NULL,
  'Watercolor on brown paper',
  43.20,
  27.90,
  NULL,
  'Gift of John K. Howat, 1977',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  86,
  6050.00,
  6950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000000342a',
  'c0000000-0000-4000-8000-00000000342a',
  'https://images.metmuseum.org/CRDImages/ad/web-large/ap1977.184.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000000342a', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000058e00',
  'a0000000-0000-4000-8000-000000000002',
  'Landscape',
  'Landscape entra al catálogo como pintura de Thomas Rowlandson, datada en 1780–1827. Material: Watercolor, graphite, pen and ink.',
  'Thomas Rowlandson',
  1780,
  'Watercolor, graphite, pen and ink',
  26.90,
  17.20,
  NULL,
  'Bequest of Vera A. H. Pratt, 1978',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  76,
  5050.00,
  5950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000058e00',
  'c0000000-0000-4000-8000-000000058e00',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP805029.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000058e00', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003d4eb',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Aphrodite',
  'Marble statue of Aphrodite entra al catálogo como escultura de un artista no identificado, datada en 1st or 2nd century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  NULL,
  NULL,
  NULL,
  'Rogers Fund, 1921',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  77,
  5925.00,
  6825.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003d4eb',
  'c0000000-0000-4000-8000-00000003d4eb',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DP117040.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003d4eb', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003e290',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Herakles',
  'Marble statue of Herakles entra al catálogo como escultura de un artista no identificado, datada en 1st century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  NULL,
  NULL,
  NULL,
  'Gift of Richard C. Hunt, 1948',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  86,
  3175.00,
  4075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003e290',
  'c0000000-0000-4000-8000-00000003e290',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DP271747.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003e290', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003e3cd',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Hermes',
  'Marble statue of Hermes entra al catálogo como escultura de Polykleitos, datada en 1st or 2nd century CE. Material: Marble, Pentellic. Contexto: Roman.',
  'Polykleitos',
  NULL,
  'Marble, Pentellic',
  74.90,
  181.00,
  59.70,
  'Gift of The Hearst Foundation, 1956',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  91,
  5800.00,
  6700.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003e3cd',
  'c0000000-0000-4000-8000-00000003e3cd',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DP253642.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003e3cd', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003e2e9',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Aphrodite',
  'Marble statue of Aphrodite entra al catálogo como escultura de un artista no identificado, datada en 1st or 2nd century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  NULL,
  NULL,
  NULL,
  'Purchase, 1952',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  71,
  5050.00,
  5950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003e2e9',
  'c0000000-0000-4000-8000-00000003e2e9',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DP138723.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003e2e9', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003eb6f',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Dionysus',
  'Marble statue of Dionysus entra al catálogo como escultura de un artista no identificado, datada en 1st–2nd century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  19.40,
  33.70,
  12.70,
  'Bequest of Adrienne Minassian, 1994',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  95,
  4925.00,
  5825.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003eb6f',
  'c0000000-0000-4000-8000-00000003eb6f',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DP117048.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003eb6f', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003d4d6',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Aphrodite',
  'Marble statue of Aphrodite entra al catálogo como escultura de un artista no identificado, datada en 1st–2nd century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  18.40,
  38.10,
  12.70,
  'Rogers Fund, 1921',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  82,
  3300.00,
  4200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003d4d6',
  'c0000000-0000-4000-8000-00000003d4d6',
  'https://images.metmuseum.org/CRDImages/gr/web-large/LC-21_88_70d.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003d4d6', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003e87f',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Pan',
  'Marble statue of Pan entra al catálogo como escultura de un artista no identificado, datada en 1st century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  NULL,
  NULL,
  NULL,
  'The Bothmer Purchase Fund, 1992',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  71,
  3425.00,
  4325.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003e87f',
  'c0000000-0000-4000-8000-00000003e87f',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DT6835.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003e87f', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003e4ea',
  'a0000000-0000-4000-8000-000000000002',
  'Marble statue of Hermes',
  'Marble statue of Hermes entra al catálogo como escultura de un artista no identificado, datada en 1st or 2nd century CE. Material: Marble. Contexto: Roman.',
  NULL,
  NULL,
  'Marble',
  NULL,
  NULL,
  NULL,
  'Gift of Mrs. Alice Lorris, in memory of Dr. S. Lorris, 1965',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  90,
  4425.00,
  5325.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003e4ea',
  'c0000000-0000-4000-8000-00000003e4ea',
  'https://images.metmuseum.org/CRDImages/gr/web-large/250346.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003e4ea', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000000c7e2',
  'a0000000-0000-4000-8000-000000000002',
  'Standing Avalokiteshvara, the Bodhisattva of Infinite Compassion',
  'Standing Avalokiteshvara, the Bodhisattva of Infinite Compassion entra al catálogo como escultura de un artista no identificado, datada en ca. 7th century. Material: Gilt bronze. Contexto: Vietnam.',
  NULL,
  NULL,
  'Gilt bronze',
  NULL,
  NULL,
  NULL,
  'Gift of Enid A. Haupt, 1993',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  72,
  6300.00,
  7200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000000c7e2',
  'c0000000-0000-4000-8000-00000000c7e2',
  'https://images.metmuseum.org/CRDImages/as/web-large/DP145420.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000000c7e2', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000009889',
  'a0000000-0000-4000-8000-000000000002',
  'Seated Deity Holding a Double Vajra',
  'Seated Deity Holding a Double Vajra entra al catálogo como escultura de un artista no identificado, datada en last quarter of the 10th–first half of the 11th century. Material: Bronze. Contexto: Indonesia (Java, Ngandjuk).',
  NULL,
  NULL,
  'Bronze',
  NULL,
  NULL,
  NULL,
  'Samuel Eilenberg Collection, Gift of Samuel Eilenberg, 1987',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  93,
  3550.00,
  4450.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000009889',
  'c0000000-0000-4000-8000-000000009889',
  'https://images.metmuseum.org/CRDImages/as/web-large/1987_142_6.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000009889', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000009885',
  'a0000000-0000-4000-8000-000000000002',
  'Seated Male Deity Holding a Parasol and an Unidentified Object',
  'Seated Male Deity Holding a Parasol and an Unidentified Object entra al catálogo como escultura de un artista no identificado, datada en fourth quarter of the 10th–century. Material: Bronze. Contexto: Indonesia (Java, Ngandjuk).',
  NULL,
  NULL,
  'Bronze',
  NULL,
  NULL,
  NULL,
  'Anonymous Gift, 1986',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  89,
  3050.00,
  3950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000009885',
  'c0000000-0000-4000-8000-000000009885',
  'https://images.metmuseum.org/CRDImages/as/web-large/264838.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000009885', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003d4aa',
  'a0000000-0000-4000-8000-000000000002',
  'Bronze horse',
  'Bronze horse entra al catálogo como escultura de un artista no identificado, datada en 8th century BCE. Material: Bronze. Contexto: Greek, Corinthian ?.',
  NULL,
  NULL,
  'Bronze',
  13.30,
  17.60,
  3.50,
  'Rogers Fund, 1921',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  90,
  2425.00,
  3325.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003d4aa',
  'c0000000-0000-4000-8000-00000003d4aa',
  'https://images.metmuseum.org/CRDImages/gr/web-large/DP-44413-001.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003d4aa', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000002e351',
  'a0000000-0000-4000-8000-000000000002',
  'The Age of Bronze (L''Age d''airain)',
  'The Age of Bronze (L''Age d''airain) entra al catálogo como escultura de Auguste Rodin, datada en modeled 1876, cast ca. 1906. Material: Bronze.',
  'Auguste Rodin',
  1876,
  'Bronze',
  NULL,
  NULL,
  NULL,
  'Gift of Mrs. John W. Simpson, 1907',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  81,
  3050.00,
  3950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000002e351',
  'c0000000-0000-4000-8000-00000002e351',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP-13618-001.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000002e351', id, true FROM catalog.categories WHERE slug = 'escultura'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000704f7',
  'a0000000-0000-4000-8000-000000000002',
  'A Jaguar Devouring a Deer',
  'A Jaguar Devouring a Deer entra al catálogo como pintura de Antoine-Louis Barye, datada en after 1840. Material: transfer watercolor on heavy wove paper.',
  'Antoine-Louis Barye',
  1840,
  'transfer watercolor on heavy wove paper',
  23.70,
  14.30,
  NULL,
  'Robert Lehman Collection, 1975',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  75,
  2050.00,
  2950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000704f7',
  'c0000000-0000-4000-8000-0000000704f7',
  'https://images.metmuseum.org/CRDImages/rl/web-large/sf-rlc-1975-1-568.JPG',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000704f7', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000586c0',
  'a0000000-0000-4000-8000-000000000002',
  'Design for a Porcelain Vase',
  'Design for a Porcelain Vase entra al catálogo como pintura de Anonymous, French, 19th century, datada en 19th century. Material: Pen and black ink, watercolor, gouache.',
  'Anonymous, French, 19th century',
  NULL,
  'Pen and black ink, watercolor, gouache',
  12.60,
  16.60,
  NULL,
  'Harris Brisbane Dick Fund, 1944',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  92,
  4300.00,
  5200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000586c0',
  'c0000000-0000-4000-8000-0000000586c0',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP809101.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000586c0', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000056d3a',
  'a0000000-0000-4000-8000-000000000002',
  'Design for a Porcelain Vase with Bronze Mount',
  'Design for a Porcelain Vase with Bronze Mount entra al catálogo como pintura de Anonymous, French, 19th century, datada en 19th century. Material: Graphite, watercolor, gouache, and gold gilt.',
  'Anonymous, French, 19th century',
  NULL,
  'Graphite, watercolor, gouache, and gold gilt',
  29.00,
  43.40,
  NULL,
  'The Elisha Whittelsey Collection, The Elisha Whittelsey Fund, 1953',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  84,
  6175.00,
  7075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000056d3a',
  'c0000000-0000-4000-8000-000000056d3a',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP812409.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000056d3a', id, true FROM catalog.categories WHERE slug = 'pinturas'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000003081d',
  'a0000000-0000-4000-8000-000000000002',
  'Vase',
  'Vase entra al catálogo como cerámica de Chelsea Porcelain Manufactory, datada en 1756–60. Material: Soft-paste porcelain.',
  'Chelsea Porcelain Manufactory',
  1756,
  'Soft-paste porcelain',
  NULL,
  NULL,
  NULL,
  'Gift of Mr. and Mrs. Howard Eric, 1940',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  89,
  5800.00,
  6700.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000003081d',
  'c0000000-0000-4000-8000-00000003081d',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP-15275-023.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000003081d', id, true FROM catalog.categories WHERE slug = 'ceramica'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000032d18',
  'a0000000-0000-4000-8000-000000000002',
  'Vase',
  'Vase entra al catálogo como cerámica de Royal Porcelain Manufactory, Berlin, datada en 1820–25. Material: Hard-paste porcelain.',
  'Royal Porcelain Manufactory, Berlin',
  1820,
  'Hard-paste porcelain',
  29.80,
  43.70,
  28.90,
  'Purchase, Robert L. Isaacson Gift, 1993',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  92,
  5175.00,
  6075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000032d18',
  'c0000000-0000-4000-8000-000000032d18',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP156496.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000032d18', id, true FROM catalog.categories WHERE slug = 'ceramica'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000321f0',
  'a0000000-0000-4000-8000-000000000002',
  'Vase (one of a pair)',
  'Vase (one of a pair) entra al catálogo como cerámica de Chelsea Porcelain Manufactory, datada en ca. 1762. Material: Soft-paste porcelain decorated in polychrome enamels, gold.',
  'Chelsea Porcelain Manufactory',
  1762,
  'Soft-paste porcelain decorated in polychrome enamels, gold',
  NULL,
  NULL,
  NULL,
  'Gift of Irwin Untermyer, 1970',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  70,
  4300.00,
  5200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000321f0',
  'c0000000-0000-4000-8000-0000000321f0',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP-13079-018.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000321f0', id, true FROM catalog.categories WHERE slug = 'ceramica'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000321ef',
  'a0000000-0000-4000-8000-000000000002',
  'Vase (one of a pair)',
  'Vase (one of a pair) entra al catálogo como cerámica de Chelsea Porcelain Manufactory, datada en ca. 1762. Material: Soft-paste porcelain decorated in polychrome enamels, gold.',
  'Chelsea Porcelain Manufactory',
  1762,
  'Soft-paste porcelain decorated in polychrome enamels, gold',
  NULL,
  NULL,
  NULL,
  'Gift of Irwin Untermyer, 1970',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  95,
  4175.00,
  5075.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000321ef',
  'c0000000-0000-4000-8000-0000000321ef',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP-13079-018.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000321ef', id, true FROM catalog.categories WHERE slug = 'ceramica'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000004056c',
  'a0000000-0000-4000-8000-000000000002',
  '[Performer in Bugaku-style Costume]',
  '[Performer in Bugaku-style Costume] entra al catálogo como fotografía de Unknown, datada en 1880s. Material: Albumen silver print with applied color.',
  'Unknown',
  NULL,
  'Albumen silver print with applied color',
  NULL,
  NULL,
  NULL,
  'Mrs. Jackson Burke Gift, 1983',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  92,
  4050.00,
  4950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000004056c',
  'c0000000-0000-4000-8000-00000004056c',
  'https://images.metmuseum.org/CRDImages/ph/web-large/DP71210.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000004056c', id, true FROM catalog.categories WHERE slug = 'fotografia'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000006718f',
  'a0000000-0000-4000-8000-000000000002',
  'From the Girls series (N59) promoting Little Beauties Pressed Cigarettes for Allen & Ginter brand tobacco products',
  'From the Girls series (N59) promoting Little Beauties Pressed Cigarettes for Allen & Ginter brand tobacco products entra al catálogo como fotografía de Allen & Ginter, datada en ca. 1888. Material: Albumen photograph.',
  'Allen & Ginter',
  1888,
  'Albumen photograph',
  3.80,
  7.00,
  NULL,
  'The Jefferson R. Burdick Collection, Gift of Jefferson R. Burdick',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  91,
  2550.00,
  3450.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000006718f',
  'c0000000-0000-4000-8000-00000006718f',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP839432.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000006718f', id, true FROM catalog.categories WHERE slug = 'fotografia'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000067298',
  'a0000000-0000-4000-8000-000000000002',
  'Maude, from the Actresses and Celebrities series (N60, Type 2) promoting Little Beauties Cigarettes for Allen & Ginter brand tobacco products',
  'Maude, from the Actresses and Celebrities series (N60, Type 2) promoting Little Beauties Cigarettes for Allen & Ginter brand tobacco products entra al catálogo como fotografía de Allen & Ginter, datada en 1887. Material: Albumen photograph.',
  'Allen & Ginter',
  1887,
  'Albumen photograph',
  3.80,
  6.00,
  NULL,
  'The Jefferson R. Burdick Collection, Gift of Jefferson R. Burdick',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  70,
  3300.00,
  4200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000067298',
  'c0000000-0000-4000-8000-000000067298',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP839484.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000067298', id, true FROM catalog.categories WHERE slug = 'fotografia'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000009e654',
  'a0000000-0000-4000-8000-000000000002',
  'Miss Biggar, from the Actors and Actresses series (N145-8) issued by Duke Sons & Co. to promote Duke Cigarettes',
  'Miss Biggar, from the Actors and Actresses series (N145-8) issued by Duke Sons & Co. to promote Duke Cigarettes entra al catálogo como fotografía de W. Duke, Sons & Co., datada en ca. 1891. Material: Albumen photograph.',
  'W. Duke, Sons & Co.',
  1891,
  'Albumen photograph',
  3.50,
  6.80,
  NULL,
  'The Jefferson R. Burdick Collection, Gift of Jefferson R. Burdick',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  80,
  5550.00,
  6450.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000009e654',
  'c0000000-0000-4000-8000-00000009e654',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP840621.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000009e654', id, true FROM catalog.categories WHERE slug = 'fotografia'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000009e973',
  'a0000000-0000-4000-8000-000000000002',
  'Mlle. Rordame, from the Actors and Actresses series (N145-8) issued by Duke Sons & Co. to promote Duke Cigarettes',
  'Mlle. Rordame, from the Actors and Actresses series (N145-8) issued by Duke Sons & Co. to promote Duke Cigarettes entra al catálogo como fotografía de W. Duke, Sons & Co., datada en ca. 1891. Material: Albumen photograph.',
  'W. Duke, Sons & Co.',
  1891,
  'Albumen photograph',
  3.50,
  6.80,
  NULL,
  'The Jefferson R. Burdick Collection, Gift of Jefferson R. Burdick',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  73,
  3675.00,
  4575.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000009e973',
  'c0000000-0000-4000-8000-00000009e973',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP840804.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000009e973', id, true FROM catalog.categories WHERE slug = 'fotografia'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000a00bd',
  'a0000000-0000-4000-8000-000000000002',
  'Milly Meyer, from the Actresses series (N245) issued by Kinney Brothers to promote Sweet Caporal Cigarettes',
  'Milly Meyer, from the Actresses series (N245) issued by Kinney Brothers to promote Sweet Caporal Cigarettes entra al catálogo como fotografía de Kinney Brothers Tobacco Company, datada en 1890. Material: Albumen photograph.',
  'Kinney Brothers Tobacco Company',
  1890,
  'Albumen photograph',
  3.70,
  6.40,
  NULL,
  'The Jefferson R. Burdick Collection, Gift of Jefferson R. Burdick',
  'TWO_D',
  'APROBADO',
  'PUBLIC',
  81,
  4300.00,
  5200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000a00bd',
  'c0000000-0000-4000-8000-0000000a00bd',
  'https://images.metmuseum.org/CRDImages/dp/web-large/DP859128.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000a00bd', id, true FROM catalog.categories WHERE slug = 'fotografia'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-000000030bd9',
  'a0000000-0000-4000-8000-000000000002',
  'Clock',
  'Clock entra al catálogo como objeto artístico de Jean Martin, datada en ca. 1780. Material: Case: Carrara marble, gilt-bronze mounts; Movement: brass, steel.',
  'Jean Martin',
  1780,
  'Case: Carrara marble, gilt-bronze mounts; Movement: brass, steel',
  40.60,
  39.40,
  16.50,
  'Fletcher Fund, 1945',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  83,
  5050.00,
  5950.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-000000030bd9',
  'c0000000-0000-4000-8000-000000030bd9',
  'https://images.metmuseum.org/CRDImages/es/web-large/ES7765.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-000000030bd9', id, true FROM catalog.categories WHERE slug = 'objetos-artisticos'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-0000000c8dc3',
  'a0000000-0000-4000-8000-000000000002',
  'Mantel clock (horloge de cheminée)',
  'Mantel clock (horloge de cheminée) entra al catálogo como objeto artístico de Jean-Joseph de Saint Germain, datada en ca. 1745. Material: Gilded and chased bronze; white enamel.',
  'Jean-Joseph de Saint Germain',
  1745,
  'Gilded and chased bronze; white enamel',
  52.10,
  61.00,
  21.60,
  'Bequest of Mrs. Charles Wrightsman, 2019',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  75,
  5300.00,
  6200.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-0000000c8dc3',
  'c0000000-0000-4000-8000-0000000c8dc3',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP-20708-015.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-0000000c8dc3', id, true FROM catalog.categories WHERE slug = 'objetos-artisticos'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000002ff27',
  'a0000000-0000-4000-8000-000000000002',
  'Clock',
  'Clock entra al catálogo como objeto artístico de un artista no identificado, datada en late 17th century. Material: Gilt bronze.',
  NULL,
  NULL,
  'Gilt bronze',
  9.50,
  10.80,
  NULL,
  'Gift of Mrs. Simon Guggenheim, 1929',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  83,
  5800.00,
  6700.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000002ff27',
  'c0000000-0000-4000-8000-00000002ff27',
  'https://images.metmuseum.org/CRDImages/es/web-large/73328.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000002ff27', id, true FROM catalog.categories WHERE slug = 'objetos-artisticos'
ON CONFLICT DO NOTHING;

INSERT INTO catalog.lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  'c0000000-0000-4000-8000-00000002e5f6',
  'a0000000-0000-4000-8000-000000000002',
  'Clock ornament',
  'Clock ornament entra al catálogo como objeto artístico de un artista no identificado, datada en 18th century. Material: Gilt bronze.',
  NULL,
  NULL,
  'Gilt bronze',
  15.60,
  5.40,
  1.00,
  'Gift of J. Pierpont Morgan, 1906',
  'THREE_D',
  'APROBADO',
  'PUBLIC',
  82,
  4425.00,
  5325.00,
  'USD'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  'c1000000-0000-4000-8000-00000002e5f6',
  'c0000000-0000-4000-8000-00000002e5f6',
  'https://images.metmuseum.org/CRDImages/es/web-large/DP278499.jpg',
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;
INSERT INTO catalog.lot_categories (lot_id, category_id, is_primary)
SELECT 'c0000000-0000-4000-8000-00000002e5f6', id, true FROM catalog.categories WHERE slug = 'objetos-artisticos'
ON CONFLICT DO NOTHING;


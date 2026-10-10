import { writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const searches = [
  { q: 'oil on canvas', want: 16 },
  { q: 'watercolor landscape', want: 6 },
  { q: 'marble statue', want: 8 },
  { q: 'bronze sculpture', want: 6 },
  { q: 'porcelain vase', want: 6 },
  { q: 'albumen photograph', want: 6 },
  { q: 'gilt bronze clock', want: 4 },
];

const sellerId = 'a0000000-0000-4000-8000-000000000002';
const seen = new Set();
const works = [];

for (const search of searches) {
  const found = await searchObjects(search.q);
  let taken = 0;
  for (const objectId of found) {
    if (taken >= search.want) {
      break;
    }
    if (seen.has(objectId)) {
      continue;
    }
    const object = await readObject(objectId);
    if (!object) {
      continue;
    }
    seen.add(objectId);
    works.push(object);
    taken += 1;
  }
}

if (works.length < 50) {
  throw new Error(`Solo se reunieron ${works.length} obras con imagen.`);
}

const lines = [
  '-- Catálogo público tomado de la colección de dominio público del Metropolitan Museum of Art.',
  '-- Las imágenes viven en el CDN del museo. Postgres guarda la ficha y la dirección.',
  '',
];

for (const work of works) {
  const lotId = uuid('c0000000', work.objectID);
  const imageId = uuid('c1000000', work.objectID);
  const kind = classify(work);
  lines.push(`INSERT INTO lots (
  id, seller_id, title, description, artist_name, creation_year, materials,
  width_cm, height_cm, depth_cm, provenance, representation_kind, status, visibility,
  authenticity_score, suggested_price_min, suggested_price_max, currency
) VALUES (
  '${lotId}',
  '${sellerId}',
  ${sql(clip(work.title, 180))},
  ${sql(describe(work, kind.label))},
  ${work.artistDisplayName ? sql(clip(work.artistDisplayName, 120)) : 'NULL'},
  ${year(work.objectDate)},
  ${sql(clip(work.medium || 'Material no especificado en la ficha', 240))},
  ${cm(work.measures.width)},
  ${cm(work.measures.height)},
  ${cm(work.measures.depth)},
  ${sql(clip(work.creditLine || 'The Metropolitan Museum of Art. Imagen de dominio público.', 400))},
  '${kind.representation}',
  'APROBADO',
  'PUBLIC',
  ${70 + (work.objectID % 26)},
  ${money(work.objectID, 0)},
  ${money(work.objectID, 900)},
  'USD'
) ON CONFLICT (id) DO NOTHING;`);
  lines.push(`INSERT INTO lot_images (id, lot_id, object_key, position, width_px, height_px)
VALUES (
  '${imageId}',
  '${lotId}',
  ${sql(work.image)},
  0,
  NULL,
  NULL
) ON CONFLICT (id) DO NOTHING;`);
  lines.push(`INSERT INTO lot_categories (lot_id, category_id, is_primary)
SELECT '${lotId}', id, true FROM categories WHERE slug = '${kind.slug}'
ON CONFLICT DO NOTHING;`);
  lines.push('');
}

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const target = path.join(root, 'postgres/seeds/004_public_catalog.sql');
await writeFile(target, `${lines.join('\n')}\n`, 'utf8');
console.log(`works ${works.length}`);
console.log(target);

async function searchObjects(q) {
  const url = `https://collectionapi.metmuseum.org/public/collection/v1.1/search?hasImages=true&isPublicDomain=true&q=${encodeURIComponent(q)}&limit=80`;
  const payload = await readJson(url);
  if (!Array.isArray(payload.objectIDs)) {
    throw new Error(`La búsqueda «${q}» no devolvió obras.`);
  }
  return payload.objectIDs;
}

async function readObject(objectId) {
  const payload = await readJson(`https://collectionapi.metmuseum.org/public/collection/v1/objects/${objectId}`);
  const image = typeof payload.primaryImageSmall === 'string' && payload.primaryImageSmall.startsWith('https://')
    ? payload.primaryImageSmall
    : payload.primaryImage;
  if (!payload.isPublicDomain || typeof image !== 'string' || !image.startsWith('https://') || typeof payload.title !== 'string') {
    return null;
  }
  const title = payload.title.trim();
  if (title.length < 3) {
    return null;
  }
  return {
    objectID: payload.objectID,
    title,
    artistDisplayName: typeof payload.artistDisplayName === 'string' ? payload.artistDisplayName.trim() : '',
    objectDate: typeof payload.objectDate === 'string' ? payload.objectDate : '',
    medium: typeof payload.medium === 'string' ? payload.medium.trim() : '',
    culture: typeof payload.culture === 'string' ? payload.culture.trim() : '',
    creditLine: typeof payload.creditLine === 'string' ? payload.creditLine.trim() : '',
    classification: `${payload.classification ?? ''} ${payload.objectName ?? ''} ${payload.department ?? ''}`,
    image,
    measures: measures(typeof payload.dimensions === 'string' ? payload.dimensions : ''),
  };
}

async function readJson(url) {
  const response = await fetch(url);
  if (!response.ok) {
    return {};
  }
  return response.json();
}

function classify(work) {
  const blob = `${work.classification} ${work.medium}`.toLowerCase();
  if (/photograph|photo|albumen|daguerreotype/.test(blob)) {
    return { slug: 'fotografia', representation: 'TWO_D', label: 'fotografía' };
  }
  if (/ceramic|porcelain|vase|earthenware|stoneware/.test(blob)) {
    return { slug: 'ceramica', representation: 'THREE_D', label: 'cerámica' };
  }
  if (/clock|watch|furniture/.test(blob)) {
    return { slug: 'objetos-artisticos', representation: 'THREE_D', label: 'objeto artístico' };
  }
  if (/sculpture|statue|bronze figure|marble/.test(blob)) {
    return { slug: 'escultura', representation: 'THREE_D', label: 'escultura' };
  }
  if (/painting|oil|canvas|watercolor|drawing|print/.test(blob)) {
    return { slug: 'pinturas', representation: 'TWO_D', label: 'pintura' };
  }
  return { slug: 'otras', representation: 'TWO_D', label: 'obra' };
}

function describe(work, label) {
  const artist = work.artistDisplayName || 'un artista no identificado';
  const when = work.objectDate ? `, datada en ${work.objectDate}` : '';
  const culture = work.culture ? ` Contexto: ${work.culture}.` : '';
  return clip(
    `${work.title} entra al catálogo como ${label} de ${artist}${when}. Material: ${work.medium || 'no especificado'}.${culture}`,
    500,
  );
}

function measures(dimensions) {
  const match = dimensions.match(/\(([0-9.]+)\s*(?:×|x)\s*([0-9.]+)(?:\s*(?:×|x)\s*([0-9.]+))?\s*cm\)/i);
  if (!match) {
    return { height: null, width: null, depth: null };
  }
  return { height: match[1], width: match[2], depth: match[3] ?? null };
}

function year(value) {
  const match = value.match(/\b(1[0-9]{3}|20[0-2][0-9])\b/);
  return match ? match[1] : 'NULL';
}

function money(objectId, extra) {
  return (1800 + (objectId % 37) * 125 + extra).toFixed(2);
}

function cm(value) {
  if (value == null) {
    return 'NULL';
  }
  const number = Number(value);
  if (!Number.isFinite(number) || number <= 0 || number > 999) {
    return 'NULL';
  }
  return number.toFixed(2);
}

function uuid(prefix, objectId) {
  return `${prefix}-0000-4000-8000-${objectId.toString(16).padStart(12, '0')}`;
}

function clip(value, max) {
  const text = value.replace(/\s+/g, ' ').trim();
  return text.length <= max ? text : `${text.slice(0, max - 1).trimEnd()}…`;
}

function sql(value) {
  return `'${value.replaceAll("'", "''")}'`;
}

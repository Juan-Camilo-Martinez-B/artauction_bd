-- Informes de auditoria, galeria social y feed de la semilla. Antes vivian en
-- Mongo (scripts/seed/mongo-samples.mjs); desde 0022 son tablas de cada
-- servicio. Los informes tienen la forma que escribe audit-service, asi la cola
-- de revision muestra los hallazgos de la semilla con sus evidencias.

INSERT INTO audit.reports (summary_id, lot_id, decided_by, dossier, assessment, created_at)
VALUES
  (
    'e0000000-0000-4000-8000-000000000001',
    'b0000000-0000-4000-8000-000000000001',
    'AI',
    '{
      "lot": {
        "lotId": "b0000000-0000-4000-8000-000000000001",
        "sellerId": "a0000000-0000-4000-8000-000000000002",
        "status": "PENDIENTE_AUDITORIA",
        "title": "Retrato de la costa",
        "description": "Semilla local alineada con audit_summaries.",
        "artistName": "Elena Vásquez",
        "creationYear": 1894,
        "materials": "Óleo sobre lienzo",
        "widthCm": null,
        "heightCm": null,
        "provenance": "",
        "images": []
      },
      "evidence": [
        { "code": "lot.declared_year", "value": "1894" },
        { "code": "lot.declared_materials", "value": "Óleo sobre lienzo" }
      ],
      "ruleFindings": [],
      "hash": "0000000000000000000000000000000000000000000000000000000000000001"
    }',
    '{
      "model": "gemini-2.5-flash",
      "promptVersion": "v2",
      "score": 86,
      "critical": false,
      "priceMin": 2400,
      "priceMax": 3800,
      "findings": []
    }',
    '2026-09-30T12:00:00Z'
  ),
  (
    'e0000000-0000-4000-8000-000000000003',
    'b0000000-0000-4000-8000-000000000003',
    'RULES',
    '{
      "lot": {
        "lotId": "b0000000-0000-4000-8000-000000000003",
        "sellerId": "a0000000-0000-4000-8000-000000000002",
        "status": "PENDIENTE_AUDITORIA",
        "title": "Estudio con pigmento moderno",
        "description": "La ficha declara 1760, pero el aglutinante descrito es acrílico. Queda en revisión manual.",
        "artistName": "Atribución dudosa",
        "creationYear": 1760,
        "materials": "Acrílico sobre tabla",
        "widthCm": null,
        "heightCm": null,
        "provenance": "",
        "images": []
      },
      "evidence": [
        { "code": "lot.declared_year", "value": "1760" },
        { "code": "lot.declared_materials", "value": "Acrílico sobre tabla" }
      ],
      "ruleFindings": [
        {
          "code": "MATERIAL_ANACHRONISM",
          "severity": "CRITICAL",
          "message": "La pintura acrilica no existia en 1760 (aparece hacia 1950).",
          "evidence": ["lot.declared_year", "lot.declared_materials"]
        }
      ],
      "hash": "0000000000000000000000000000000000000000000000000000000000000003"
    }',
    '{
      "model": "rules",
      "promptVersion": "none",
      "score": 28,
      "critical": true,
      "priceMin": 50,
      "priceMax": 120,
      "findings": [
        {
          "code": "MATERIAL_ANACHRONISM",
          "severity": "CRITICAL",
          "message": "La pintura acrilica no existia en 1760 (aparece hacia 1950).",
          "evidence": ["lot.declared_year", "lot.declared_materials"]
        }
      ]
    }',
    '2026-09-30T12:00:00Z'
  )
ON CONFLICT (summary_id) DO NOTHING;

-- Los ids siguen el esquema de gallery-service (PROPIA:<obra>:<duena>,
-- follow:<quien>:<a quien>): un evento repetido sobre la semilla no la duplica.
INSERT INTO gallery.items (id, owner_id, lot_id, source, visibility, title, artist_name, image_keys, acquired_at)
VALUES
  (
    'PROPIA:b0000000-0000-4000-8000-000000000001:a0000000-0000-4000-8000-000000000002',
    'a0000000-0000-4000-8000-000000000002',
    'b0000000-0000-4000-8000-000000000001',
    'PROPIA', 'PUBLIC', 'Retrato de la costa', 'Elena Vásquez', '{}', '2026-09-30T12:00:00Z'
  ),
  (
    'PROPIA:b0000000-0000-4000-8000-000000000003:a0000000-0000-4000-8000-000000000002',
    'a0000000-0000-4000-8000-000000000002',
    'b0000000-0000-4000-8000-000000000003',
    'PROPIA', 'PRIVATE', 'Estudio con pigmento moderno', 'Atribución dudosa', '{}', '2026-09-30T12:00:00Z'
  ),
  (
    'GRATUITA:seed:a0000000-0000-4000-8000-000000000003:lamina-de-estudio',
    'a0000000-0000-4000-8000-000000000003',
    NULL,
    'GRATUITA', 'PUBLIC', 'Lámina de estudio', 'Taller abierto', '{}', '2026-09-30T12:00:00Z'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO gallery.activity (id, actor_id, verb, object_type, object_id, visibility, summary, created_at)
VALUES
  (
    'publish:b0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000002',
    'PUBLISH', 'LOT', 'b0000000-0000-4000-8000-000000000001',
    'PUBLIC', 'Marta publicó Retrato de la costa', '2026-09-30T12:00:00Z'
  ),
  (
    'follow:a0000000-0000-4000-8000-000000000003:a0000000-0000-4000-8000-000000000002',
    'a0000000-0000-4000-8000-000000000003',
    'FOLLOW', 'USER', 'a0000000-0000-4000-8000-000000000002',
    'PUBLIC', 'Leo siguió a Marta Vendedora', '2026-09-30T12:00:00Z'
  )
ON CONFLICT (id) DO NOTHING;

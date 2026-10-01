import path from 'node:path';
import { pathToFileURL } from 'node:url';
import mongoose from 'mongoose';
import { applyIndexes } from '../../mongo/indexes/apply.mjs';
import { Activity } from '../../mongo/schemas/activity-feed.schema.mjs';
import { AuditReport } from '../../mongo/schemas/audit-report.schema.mjs';
import { EventLog } from '../../mongo/schemas/event-log.schema.mjs';
import { GalleryItem } from '../../mongo/schemas/gallery-item.schema.mjs';

const SELLER = 'a0000000-0000-4000-8000-000000000002';
const LEO = 'a0000000-0000-4000-8000-000000000003';
const PORTRAIT = 'b0000000-0000-4000-8000-000000000001';
const CLOCK = 'b0000000-0000-4000-8000-000000000002';
const ANACHRONISM = 'b0000000-0000-4000-8000-000000000003';

const reports = [
  {
    summaryId: 'e0000000-0000-4000-8000-000000000001',
    lotId: PORTRAIT,
    score: 86,
    priceMin: 2400,
    priceMax: 3800,
    title: 'Retrato de la costa',
    materials: 'Óleo sobre lienzo',
    year: 1894,
    findings: [],
  },
  {
    summaryId: 'e0000000-0000-4000-8000-000000000002',
    lotId: CLOCK,
    score: 74,
    priceMin: 400,
    priceMax: 700,
    title: 'Reloj de carruaje',
    materials: 'Latón y esmalte',
    year: 1910,
    findings: [],
  },
  {
    summaryId: 'e0000000-0000-4000-8000-000000000003',
    lotId: ANACHRONISM,
    score: 28,
    priceMin: 50,
    priceMax: 120,
    title: 'Estudio con pigmento moderno',
    materials: 'Acrílico sobre tabla',
    year: 1760,
    findings: [
      {
        code: 'MATERIAL_YEAR_CONFLICT',
        severity: 'CRITICAL',
        message: 'El acrílico no existe como aglutinante comercial en 1760.',
      },
    ],
  },
];

export async function seedMongo(uri) {
  await applyIndexes(uri);
  await mongoose.connect(uri);
  try {
    for (const report of reports) {
      await AuditReport.updateOne(
        { summaryId: report.summaryId },
        {
          $setOnInsert: {
            lotId: report.lotId,
            summaryId: report.summaryId,
            model: 'gemini-2.5-flash',
            promptVersion: 'v1',
            input: {
              title: report.title,
              description: 'Semilla local alineada con audit_summaries.',
              materials: report.materials,
              creationYear: report.year,
              imageHashes: [],
            },
            findings: report.findings,
            authenticityScore: report.score,
            suggestedPriceMin: report.priceMin,
            suggestedPriceMax: report.priceMax,
            createdAt: new Date('2026-09-30T12:00:00.000Z'),
          },
        },
        { upsert: true },
      );
    }

    const gallery = [
      {
        ownerId: SELLER,
        lotId: PORTRAIT,
        source: 'PROPIA',
        visibility: 'PUBLIC',
        title: 'Retrato de la costa',
        artistName: 'Elena Vásquez',
      },
      {
        ownerId: SELLER,
        lotId: CLOCK,
        source: 'PROPIA',
        visibility: 'PUBLIC',
        title: 'Reloj de carruaje',
        artistName: 'Taller anónimo',
      },
      {
        ownerId: SELLER,
        lotId: ANACHRONISM,
        source: 'PROPIA',
        visibility: 'PRIVATE',
        title: 'Estudio con pigmento moderno',
        artistName: 'Atribución dudosa',
      },
      {
        ownerId: LEO,
        source: 'GRATUITA',
        visibility: 'PUBLIC',
        title: 'Lámina de estudio',
        artistName: 'Taller abierto',
      },
    ];

    for (const item of gallery) {
      const filter = item.lotId
        ? { ownerId: item.ownerId, lotId: item.lotId }
        : { ownerId: item.ownerId, title: item.title, source: 'GRATUITA' };
      await GalleryItem.updateOne(
        filter,
        {
          $setOnInsert: {
            ...item,
            imageKeys: [],
            acquiredAt: new Date('2026-09-30T12:00:00.000Z'),
          },
        },
        { upsert: true },
      );
    }

    const activity = [
      {
        actorId: SELLER,
        verb: 'PUBLISH',
        objectType: 'LOT',
        objectId: PORTRAIT,
        visibility: 'PUBLIC',
        summary: 'Marta publicó Retrato de la costa',
      },
      {
        actorId: LEO,
        verb: 'FOLLOW',
        objectType: 'USER',
        objectId: SELLER,
        visibility: 'PUBLIC',
        summary: 'Leo siguió a Marta Vendedora',
      },
      {
        actorId: LEO,
        verb: 'BID',
        objectType: 'AUCTION',
        objectId: 'c0000000-0000-4000-8000-000000000001',
        visibility: 'PUBLIC',
        summary: 'Leo pujó por el reloj de carruaje',
      },
    ];

    for (const entry of activity) {
      await Activity.updateOne(
        { actorId: entry.actorId, verb: entry.verb, objectId: entry.objectId },
        { $setOnInsert: { ...entry, createdAt: new Date('2026-09-30T12:00:00.000Z') } },
        { upsert: true },
      );
    }

    await EventLog.updateOne(
      { correlationId: 'seed-audit-portrait' },
      {
        $setOnInsert: {
          source: 'worker',
          name: 'audit.completed',
          correlationId: 'seed-audit-portrait',
          payload: { lotId: PORTRAIT, score: 86 },
          occurredAt: new Date('2026-09-30T12:00:00.000Z'),
        },
      },
      { upsert: true },
    );
  } finally {
    await mongoose.disconnect();
  }
}

function isDirectRun() {
  if (!process.argv[1]) {
    return false;
  }
  return import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href;
}

if (isDirectRun()) {
  const uri = process.env.MONGODB_URI;
  if (!uri) {
    console.error('MONGODB_URI is required');
    process.exit(1);
  }
  await seedMongo(uri);
}

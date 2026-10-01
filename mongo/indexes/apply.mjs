import path from 'node:path';
import { pathToFileURL } from 'node:url';
import mongoose from 'mongoose';
import { activityFeedIndexSpecs } from './activity-feed.mjs';
import { auditReportIndexSpecs } from './audit-reports.mjs';
import { eventLogIndexSpecs } from './event-logs.mjs';
import { galleryItemIndexSpecs } from './gallery-items.mjs';

const groups = [
  ['audit_reports', auditReportIndexSpecs],
  ['gallery_items', galleryItemIndexSpecs],
  ['activity_feed', activityFeedIndexSpecs],
  ['event_logs', eventLogIndexSpecs],
];

export async function applyIndexes(uri) {
  await mongoose.connect(uri);
  try {
    const db = mongoose.connection.db;
    if (!db) {
      throw new Error('MongoDB connection has no database handle');
    }
    for (const [collection, specs] of groups) {
      await db.collection(collection).createIndexes(specs);
    }
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
  await applyIndexes(uri);
}

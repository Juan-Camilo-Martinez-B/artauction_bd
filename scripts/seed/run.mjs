import { spawn } from 'node:child_process';
import { readdir } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { seedMongo } from './mongo-samples.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');

function runPsql(file) {
  const databaseUrl = process.env.DATABASE_URL;
  return new Promise((resolve, reject) => {
    const child = spawn('psql', ['-v', 'ON_ERROR_STOP=1', '-f', file, databaseUrl], {
      stdio: 'inherit',
    });
    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`psql exited ${code} for ${file}`));
    });
  });
}

const databaseUrl = process.env.DATABASE_URL;
if (!databaseUrl) {
  console.error('DATABASE_URL is required');
  process.exit(1);
}

const seedDir = path.join(root, 'postgres/seeds');
const files = (await readdir(seedDir)).filter((name) => name.endsWith('.sql')).sort();
for (const name of files) {
  await runPsql(path.join(seedDir, name));
}

if (process.env.MONGODB_URI) {
  await seedMongo(process.env.MONGODB_URI);
} else {
  console.log('MONGODB_URI is not set; mongo samples were skipped');
}

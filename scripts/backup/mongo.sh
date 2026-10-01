#!/usr/bin/env bash
# Archivo comprimido de MongoDB. No incluye la URI en el nombre del fichero.
set -euo pipefail

if [[ -z "${MONGODB_URI:-}" ]]; then
  echo "MONGODB_URI is required" >&2
  exit 1
fi

backup_dir="${BACKUP_DIR:-./backups}"
mkdir -p "$backup_dir"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
output="${backup_dir}/mongo-${stamp}.archive.gz"

mongodump --uri="$MONGODB_URI" --archive="$output" --gzip
echo "$output"

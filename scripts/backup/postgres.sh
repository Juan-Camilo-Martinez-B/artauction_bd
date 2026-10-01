#!/usr/bin/env bash
# Volcado lógico de Postgres en formato custom. El directorio de salida no se versiona.
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi

backup_dir="${BACKUP_DIR:-./backups}"
mkdir -p "$backup_dir"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
output="${backup_dir}/postgres-${stamp}.dump"

pg_dump --format=custom --no-owner --file="$output" --dbname="$DATABASE_URL"
echo "$output"

#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "${root}/scripts/migrate/assert.sql"

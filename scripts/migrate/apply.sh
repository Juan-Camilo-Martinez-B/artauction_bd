#!/usr/bin/env bash
# Aplica postgres/migrations en orden lexicográfico, una vez cada archivo.
# Cada archivo corre dentro de una transacción junto con su registro.
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
dir="${root}/postgres/migrations"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 <<'SQL'
CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
SQL

shopt -s nullglob
mapfile -t files < <(printf '%s\n' "$dir"/*.sql | sort)

for file in "${files[@]}"; do
  version="$(basename "$file")"
  already="$(psql "$DATABASE_URL" -tA -v ON_ERROR_STOP=1 \
    -c "SELECT 1 FROM schema_migrations WHERE version = '${version}'")"
  if [[ "$already" == "1" ]]; then
    echo "skip ${version}"
    continue
  fi
  echo "apply ${version}"
  {
    echo "BEGIN;"
    cat "$file"
    printf "INSERT INTO schema_migrations (version) VALUES ('%s');\n" "$version"
    echo "COMMIT;"
  } | psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q
done

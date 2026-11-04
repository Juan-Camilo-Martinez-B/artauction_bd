#!/usr/bin/env bash
# Borra las obras de la e2e de la base de DATABASE_URL (ver delete-e2e-lots.sql).
# Pensado para la base de desarrollo: se niega a correr si NODE_ENV=production.
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi
if [[ "${NODE_ENV:-}" == "production" ]]; then
  echo "No se borran datos de prueba con NODE_ENV=production" >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Las opciones van antes de la conexion: psql en Windows ignora las que vienen despues.
psql -X -q -P pager=off -f "${root}/scripts/maintenance/delete-e2e-lots.sql" -d "$DATABASE_URL"

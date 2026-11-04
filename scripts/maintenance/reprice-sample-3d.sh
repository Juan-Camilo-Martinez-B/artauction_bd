#!/usr/bin/env bash
# Corrige en la base de DATABASE_URL el precio de las obras 3D de muestra
# que quedaron con el rango generico de la auditoria local (ver reprice-sample-3d.sql).
# Sin --apply solo muestra los precios nuevos. Se niega a correr con NODE_ENV=production.
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi
if [[ "${NODE_ENV:-}" == "production" ]]; then
  echo "No se cambian precios con NODE_ENV=production" >&2
  exit 1
fi

apply=()
if [[ "${1:-}" == "--apply" ]]; then
  apply=(-v apply=1)
elif [[ -n "${1:-}" ]]; then
  echo "Uso: reprice-sample-3d.sh [--apply]" >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Las opciones van antes de la conexion: psql en Windows ignora las que vienen despues.
psql -X -q -P pager=off "${apply[@]}" -f "${root}/scripts/maintenance/reprice-sample-3d.sql" -d "$DATABASE_URL"

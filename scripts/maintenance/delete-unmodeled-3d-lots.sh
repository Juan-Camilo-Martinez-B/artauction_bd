#!/usr/bin/env bash
# Borra de la base de DATABASE_URL las obras tridimensionales sin modelo 3D,
# anulando sus ventas con reembolso (ver delete-unmodeled-3d-lots.sql).
# Sin --apply solo muestra lo que borraria. Se niega a correr con NODE_ENV=production.
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi
if [[ "${NODE_ENV:-}" == "production" ]]; then
  echo "No se borran obras con NODE_ENV=production" >&2
  exit 1
fi

apply=()
if [[ "${1:-}" == "--apply" ]]; then
  apply=(-v apply=1)
elif [[ -n "${1:-}" ]]; then
  echo "Uso: delete-unmodeled-3d-lots.sh [--apply]" >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Las opciones van antes de la conexion: psql en Windows ignora las que vienen despues.
psql -X -q -P pager=off "${apply[@]}" -f "${root}/scripts/maintenance/delete-unmodeled-3d-lots.sql" -d "$DATABASE_URL"

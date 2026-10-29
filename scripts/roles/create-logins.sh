#!/usr/bin/env bash
# Crea o actualiza un usuario con login por microservicio y lo une al rol de
# grupo de su esquema (identity_rw, catalog_rw, ...). Las contraseñas salen del
# entorno: <SERVICIO>_DB_PASSWORD, por ejemplo CATALOG_DB_PASSWORD. Si falta la
# variable de un servicio, ese servicio se omite. Es idempotente.
set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "DATABASE_URL is required" >&2
  exit 1
fi

for service in identity catalog auction wallet audit gallery; do
  var="$(echo "${service}" | tr '[:lower:]' '[:upper:]')_DB_PASSWORD"
  password="${!var:-}"
  if [[ -z "${password}" ]]; then
    echo "skip ${service}: ${var} is not set"
    continue
  fi
  if [[ "${#password}" -lt 16 ]]; then
    echo "${var} must have at least 16 characters" >&2
    exit 1
  fi
  login="${service}_svc"
  # La contraseña viaja como variable de psql y se cita con :'password', así no
  # se interpola en el texto del comando ni queda en el historial de la shell.
  psql -v ON_ERROR_STOP=1 -q -v login="${login}" -v grp="${service}_rw" -v schema="${service}" \
    -v password="${password}" "$DATABASE_URL" <<'SQL'
SELECT format('CREATE ROLE %I LOGIN', :'login')
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = :'login')
\gexec
SELECT format('ALTER ROLE %I WITH LOGIN PASSWORD %L', :'login', :'password')
\gexec
SELECT format('GRANT %I TO %I', :'grp', :'login')
\gexec
SELECT format('ALTER ROLE %I SET search_path = %I', :'login', :'schema')
\gexec
SQL
  echo "ready ${login}"
done

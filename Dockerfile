# syntax=docker/dockerfile:1

# Imagen de un solo uso: aplica las migraciones SQL ya versionadas.
# Pensada para un Cloud Run Job. No genera migraciones nuevas.

FROM node:24-alpine

RUN apk add --no-cache postgresql-client bash

WORKDIR /app
COPY postgres/migrations ./postgres/migrations
COPY scripts/migrate/apply.sh ./scripts/migrate/apply.sh

USER node
CMD ["bash", "scripts/migrate/apply.sh"]

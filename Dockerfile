# syntax=docker/dockerfile:1

# Imagen de un solo uso para la base de datos. Por defecto aplica las
# migraciones SQL ya versionadas (Cloud Run Job). Tambien trae los scripts para
# crear los logins de cada servicio y sembrar una base vacia, que usa el
# docker compose del backend. No genera migraciones nuevas.

FROM node:24-alpine

RUN apk add --no-cache postgresql-client bash

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
COPY postgres/migrations ./postgres/migrations
COPY postgres/seeds ./postgres/seeds
COPY scripts/migrate ./scripts/migrate
COPY scripts/roles ./scripts/roles
COPY scripts/seed ./scripts/seed

USER node
CMD ["bash", "scripts/migrate/apply.sh"]

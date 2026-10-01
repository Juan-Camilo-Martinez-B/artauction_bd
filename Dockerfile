# syntax=docker/dockerfile:1

# Imagen de un solo uso: aplica migraciones Postgres ya generadas.
# No crea migraciones nuevas. Pensada para un Cloud Run Job, no para un servicio.
# El esquema de Mongo se aplica con los scripts de este repositorio, fuera de esta imagen.

FROM node:24-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:24-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./package.json
COPY postgres ./postgres
USER node
CMD ["npx", "prisma", "migrate", "deploy", "--schema", "postgres/prisma/schema.prisma"]

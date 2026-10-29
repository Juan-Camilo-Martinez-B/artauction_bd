# ArtAuction AI — Database

Esquemas versionados de **ArtAuction AI**. Este repositorio es la fuente de verdad del modelo. El backend lo consume por tag semántico; no hay importaciones por ruta local ni transacciones distribuidas entre motores.

## Motores

| Motor | Qué guarda | Por qué |
|---|---|---|
| Postgres (Neon) | Un esquema por microservicio: `identity`, `catalog`, `auction`, `wallet`, `audit`, `gallery` | Integridad, pujas con bloqueo de fila, outbox transaccional, cola pg-boss |
| MongoDB (Atlas M0) | `audit_reports`, `gallery_items`, `activity_feed`, `event_logs` | Documentos de auditoría, galería y feed de actividad |

Las referencias cruzadas son UUID. Un informe en Mongo apunta al lote de Postgres por su id; no hay un commit que abarque los dos motores.

## Esquema por servicio

Desde `v0.4.0` cada microservicio del backend es dueño de un esquema y se conecta con un rol que no ve los demás. No hay llaves foráneas entre esquemas; la integridad entre servicios la sostienen los eventos del outbox. Desde `v0.8.0` ya no quedan vistas de compatibilidad: `public` solo guarda el registro de migraciones. El detalle, los roles y el outbox están en [docs/modelo-datos/esquemas-por-servicio.md](docs/modelo-datos/esquemas-por-servicio.md).

## Diseño que las migraciones deben respetar

- **Expand/contract.** Cada cambio de esquema es compatible hacia atrás con la versión del backend que sigue en producción. Primero se amplía, se despliega el código que entiende ambas formas y solo después se retira lo viejo.
- **Pujas.** `idempotency_key` único por puja. El precio almacenado no tiene un camino de actualización que lo disminuya.
- **Auditoría.** `audit_summaries` (Postgres) guarda score y rango de precio. `audit_reports` (Mongo) guarda modelo, versión de prompt, entrada y fecha.
- **Privacidad.** La visibilidad de una obra y de un perfil es un dato, no una convención del cliente. Los índices de lectura pública no deben devolver obras privadas.

## Estructura

```
postgres/prisma       schema Prisma
postgres/migrations   SQL versionado
scripts/roles         usuarios con login por microservicio
postgres/seeds        datos de ejemplo relacionales
mongo/schemas         esquemas Mongoose
mongo/indexes         índices de las cuatro colecciones
scripts/backup        respaldo de Postgres y Mongo
scripts/seed          carga de semillas
docs/modelo-datos     diagrama y descripción del modelo
CHANGELOG.md          historial semántico del esquema
```

Los tags `v0.1.0`, `v0.2.0`, … marcan esquemas que el backend puede fijar.

## Convenciones

- Commits en [Conventional Commits](https://www.conventionalcommits.org/).
- Rama `main`. Cambios de esquema en `feat/...`, integración con `merge --no-ff`.
- Prettier formatea SQL, Prisma, JSON y Markdown. ESLint cubre los scripts en `scripts/`.
- `commitlint.config.cjs` fija el mensaje. Husky se instala con las herramientas de los scripts.
- Las cadenas de conexión viven en `.env.example` como plantilla. Los volcados locales (`backups/`, `*.dump`, `*.sql.gz`) no se versionan.

## Imagen

El `Dockerfile` aplica `scripts/migrate/apply.sh` con el cliente de Postgres. Sirve para un Cloud Run Job. No genera migraciones nuevas dentro de la imagen. Los índices de Mongo se crean con `npm run indexes:mongo`, fuera de esa imagen.

## CI

El workflow de `.github/workflows/ci.yml` aplica las migraciones dos veces sobre Postgres 16, comprueba que el precio no retrocede y crea los índices en Mongo 7.

## Uso local

```bash
export DATABASE_URL=postgresql://artauction:artauction@localhost:5432/artauction
export MONGODB_URI=mongodb://localhost:27017/artauction
npm run migrate
npm run seed
npm run indexes:mongo
```

Para conectar los microservicios, crea sus usuarios con contraseñas propias (mínimo 16 caracteres) y ejecuta `npm run roles`:

```bash
export IDENTITY_DB_PASSWORD=... CATALOG_DB_PASSWORD=... AUCTION_DB_PASSWORD=...
export WALLET_DB_PASSWORD=... AUDIT_DB_PASSWORD=... GALLERY_DB_PASSWORD=...
npm run roles
```

La semilla SQL crea cuatro cuentas con la contraseña local `DevPassword!234`. No sirve en producción.

`npm run backup:postgres` y `npm run backup:mongo` escriben en `BACKUP_DIR` (por defecto `./backups`), que no se versiona.

## Estado

Tag `v0.8.0`: retiro de las vistas de compatibilidad de `public` y de los esquemas sin uso `pgboss` y `audit_queue`. `v0.7.0`: cola de auditorías y caché de evaluaciones de la IA en `audit`, y retiro del trigger transitorio de 0018 (ya no hay lecturas entre esquemas). `v0.6.0`: copia del vendedor y del título en `auction.auctions` para auction-service. `v0.5.0`: recargas idempotentes, reservas TCC y comisión por venta. `v0.4.0`: un esquema por microservicio, roles aislados, outbox e inbox. `v0.3.0`: categorías, tipo de representación y galería personal.

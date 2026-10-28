# Changelog

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el versionado [Semantic Versioning](https://semver.org/lang/es/).

Cada tag de este repositorio es un esquema que el backend puede fijar. Un cambio incompatible de lectura o de escritura incrementa el minor hasta el primer `v1.0.0`; a partir de ahí, un cambio incompatible incrementa el major.

## [Unreleased]

## [0.6.0] - 2026-10-28

### Added

- `auction.auctions.seller_id` y `auction.auctions.lot_title`: copia del vendedor y del título de la obra, para que auction-service valide pujas sin leer `catalog`. La migración rellena las subastas existentes.
- Índices parciales `auctions_due_to_open_idx` y `auctions_due_to_close_idx` para el programador de aperturas y cierres.
- Comprobación en `assert.sql` del relleno de la copia.

### Deprecated

- Trigger transitorio `auctions_fill_lot_copy` (`auction.fill_lot_copy()`, `SECURITY DEFINER`): completa la copia desde `catalog.lots` cuando la subasta llega sin ella, como hace la auditoría del monolito. Es la única lectura entre esquemas y se elimina en la migración de contract de F7, cuando audit-service envíe la copia en `AuditCompleted`.

## [0.5.0] - 2026-10-28

### Added

- Recargas idempotentes: `wallet.payment_orders.idempotency_key` única por usuario y `request_hash` con la huella del contenido.
- `wallet.hold_reservations` para las retenciones TCC de las pujas (pendiente, confirmada o liberada, con vencimiento).
- Movimiento `VENTA` en `wallet.wallet_entries` y `wallet.platform_fees` para la comisión de cada venta, una sola vez por subasta.
- Comprobaciones en `assert.sql`: clave de recarga repetida y reserva que no cuadra.

## [0.4.0] - 2026-10-27

### Added

- Un esquema por microservicio: `identity`, `catalog`, `auction`, `wallet`, `audit`, `gallery` y `audit_queue` para pg-boss.
- Roles de grupo `<servicio>_rw` con permisos solo sobre su esquema, y `scripts/roles/create-logins.sh` para los usuarios con login.
- Tablas `outbox` en los productores de eventos e `inbox` en los consumidores.
- Vistas de compatibilidad en `public` con el nombre de cada tabla movida, para el monolito durante la migración.
- Comprobaciones en `assert.sql`: sin llaves foráneas entre esquemas y sin acceso de un rol a un esquema ajeno.
- Guía `docs/modelo-datos/esquemas-por-servicio.md`.

### Changed

- Las semillas y las comprobaciones escriben en las tablas calificadas por esquema.
- `postgres/prisma/schema.prisma` se regenera por introspección e incluye el bolsillo y los estados de venta que faltaban.

### Removed

- Llaves foráneas entre contextos, como `lots.seller_id -> users.id` y `bids.bidder_id -> users.id`. La integridad entre servicios la sostienen los eventos.

## [0.3.0] - 2026-10-10

### Added

- Categorías de catálogo y vínculo obra-categoría, con una sola categoría principal.
- `lots.representation_kind` para distinguir obra plana y volumen.
- Galería personal por usuario, con preferencias, configuración y colocación de obras.

## [0.2.0] - 2026-09-30

### Added

- Colecciones `audit_reports`, `gallery_items`, `activity_feed` y `event_logs`, con sus índices.
- Semillas locales de usuarios, obras y subastas, y documentos Mongo alineados por UUID.
- Scripts de respaldo de Postgres y MongoDB.
- Runner idempotente de migraciones SQL y comprobación de que el precio de la subasta no retrocede.
- Diagrama del modelo y guía de migraciones expand/contract.
- CI con Postgres y Mongo efímeros.

## [0.1.0] - 2026-09-30

### Added

- Estructura del repositorio de esquemas versionados.
- Tablas `users`, `lots`, `lot_images`, `auctions`, `bids`, `transactions`, `audit_summaries` y `follows`.
- Índice único de `bids.idempotency_key` y enlace de la puja ganadora.
- Índices de catálogo público, cierre de subastas activas y seguidores.
- Restricciones de dinero, puntuación de autenticidad y seguimiento.
- Trigger que impide que `current_price` o `ends_at` retrocedan.

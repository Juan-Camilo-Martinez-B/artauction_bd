# Changelog

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el versionado [Semantic Versioning](https://semver.org/lang/es/).

Cada tag de este repositorio es un esquema que el backend puede fijar. Un cambio incompatible de lectura o de escritura incrementa el minor hasta el primer `v1.0.0`; a partir de ahí, un cambio incompatible incrementa el major.

## [Unreleased]

## [0.17.0] - 2026-11-04

Varios idiomas (F18 de la plataforma): por ahora español e inglés.

### Added

- `0036_i18n.sql`:
  - `identity.users.locale` (`es` por omisión, o `en`): el idioma en que la cuenta ve la plataforma.
  - `catalog.lots.source_locale`: el idioma en que se escribió la ficha, detectado al traducirla.
  - `catalog.lot_translations`: la traducción automática de título, descripción, materiales y procedencia a otro idioma, con la huella (SHA-256) del original traducido y el modelo que la hizo. Se borra con la obra.
  - `catalog.translation_requests`: la cola de traducción, con el mismo patrón que la de auditoría y una sola solicitud pendiente por obra.
- Comprobaciones en `assert.sql`: un idioma no admitido, dos traducciones pendientes de la misma obra.

### Changed

- Seed `004_public_catalog.sql` y su generador: el título, el artista, la fecha, el material y la cultura que vienen del Met (en inglés) van entre comillas «» dentro de la descripción en español. Así el traductor los deja tal cual y detecta bien el idioma de la ficha. La etiqueta `Contexto:` pasa a `Cultura:`: con la primera, Opus-MT pierde lo citado. El seed sigue con `ON CONFLICT DO NOTHING`: una base ya sembrada conserva el texto anterior.

## [0.16.0] - 2026-11-04

Proveedor de IA neutral (F17 de la plataforma).

### Changed

- `0035_gallery_ai_source.sql`: el diseño de sala generado por IA pasa de `source = "gemini"` al valor neutro `"ai"` en `gallery.personal_galleries` (`suggested_config` y `applied_config`), porque la IA ahora la da Groq y el origen no debe depender del proveedor.

## [0.15.0] - 2026-11-04

Esculturas en 3D (F16 de la plataforma): una obra tridimensional se muestra solo con su modelo 3D real.

### Added

- `0033_lot_models.sql`: `catalog.lot_models`, el modelo 3D (GLB) de una obra tridimensional: clave del archivo bajo `lots/<obra>/model-*.glb`, bytes (hasta 30 MB), triángulos (de 1 000 a 300 000), vértices y la caja que lo envuelve. Se borra con la obra.
- Comprobaciones en `assert.sql`: un modelo con demasiados triángulos o con una clave ajena a la obra.
- `0034_wallet_refunds.sql`: asientos `REEMBOLSO` (devuelve al comprador lo que pagó) y `ANULACION` (descuenta al vendedor lo que cobró) para anular una venta sin borrar movimientos del bolsillo.
- `scripts/maintenance/delete-unmodeled-3d-lots.sh` (`npm run cleanup:unmodeled-3d`): retira las obras tridimensionales sin modelo 3D y lo que depende de ellas, anula sus ventas con reembolso y libera las retenciones de pujas vivas. Sin `--apply` es una vista previa que se revierte.
- `scripts/maintenance/reprice-sample-3d.sh` (`npm run reprice:sample-3d`): corrige el precio de las obras 3D de muestra que la auditoría local dejó con el rango genérico (400-800) y recalcula sus salas programadas sin pujas. Sin `--apply` es una vista previa.
- `scripts/maintenance/delete-e2e-lots.sh` (`npm run cleanup:e2e`): borra las obras de la prueba de punta a punta y lo que depende de ellas, en una transacción que se aborta si hay pujas o ventas. No corre con `NODE_ENV=production`.

### Changed

- La semilla del catálogo público ya no crea obras tridimensionales: una escultura exige su modelo 3D real y el museo no lo publica. Quedan las 30 obras planas; `build-public-catalog.mjs` descarta las tridimensionales y escribe las tablas con su esquema.

## [0.14.0] - 2026-11-03

Ficha guardada de las obras compradas (F15 de la plataforma).

### Added

- `0032_purchased_sheet.sql`: `gallery.items.sheet` (JSONB), la copia fija de la ficha de una obra ganada, con el precio pagado, la fecha y si fue por subasta o compra inmediata. Solo una obra `GANADA` puede tenerla.

## [0.13.0] - 2026-11-03

Compra inmediata en las subastas (F14 de la plataforma).

### Added

- `0030_buy_now.sql`: `auction.auctions.buy_now_price` (obligatorio y mayor que la salida; las salas existentes lo reciben con la salida por 3, redondeada hacia arriba a múltiplos de 50), `auction.auctions.closed_by` (`TIME` o `BUY_NOW`, solo en salas cerradas; las cerradas existentes quedan `TIME`) y `auction.bids.kind` (`BID` o `BUY_NOW`).
- `0031_buy_now_notices.sql`: el aviso `AUCTION_LOST` para los postores de una sala que cerró y el verbo `BUY_NOW` del feed.
- Comprobaciones en `assert.sql`: compra inmediata por debajo de la salida y sala cerrada sin motivo.

### Changed

- La semilla `003_auctions.sql` da a su subasta un precio de compra inmediata.

## [0.12.0] - 2026-11-03

Proyectos propios y propiedad de las obras (F13 de la plataforma).

### Added

- `0028_personal_works.sql`: estado `PERSONAL` en `catalog.lots`, para el proyecto propio que su autor sube solo a su galería. No pasa por auditoría ni se subasta, y el catálogo público no lo lista. Pasarlo al catálogo lo lleva a `PENDIENTE_AUDITORIA`.
- Semilla: un proyecto propio público de `leo` en lugar de la lámina de prueba.

### Changed

- `0029_gallery_ownership.sql`: `gallery.items` registra lo que es de cada persona (`PROYECTO`, `PROPIA` o `GANADA`), con una entrada por obra y dueña (`items_owner_lot_uidx`) y `lot_id` obligatorio. Las obras ya vendidas dejan de ser del autor, y la sala 3D descuelga lo que su dueña no tiene en la galería.

### Removed

- El origen `GRATUITA` y sus filas: colgaba cualquier obra pública ajena y era una función de prueba.

## [0.11.0] - 2026-11-03

Ciclo de revisión y auditoría local (F12 de la plataforma).

### Added

- `0026_review_cycle.sql`: tabla `catalog.lot_reviews` con el historial de decisiones del administrador (`APPROVE`, `RETURN_TO_DRAFT` o `REAUDIT`). Devolver a borrador exige un motivo de 10 a 500 caracteres, y aprobar puede fijar el rango de precio. `decided_by` de `audit.audit_summaries` y `audit.reports` admite `LOCAL`: la auditoría que hizo la evaluación local porque Gemini no respondió.
- `0027_lot_returned_notifications.sql`: el aviso `LOT_RETURNED`, que recibe el vendedor con el motivo de la devolución.

## [0.10.0] - 2026-11-02

Subastas rotativas del catálogo (F11 de la plataforma).

### Changed

- `0023_rotating_auction_durations.sql`: `auctions_duration_minutes_check` acepta de 1 a 180 minutos, porque las subastas rotativas del catálogo duran de 15 a 30 por defecto. El mínimo de 30 minutos de las salas por score sigue en auction-service.

### Added

- `0024_auction_origin.sql`: columna `auction.auctions.origin`, con los valores `SCHEDULED`, `MANUAL` o `ROTATION`. La rotación solo recicla sus propias salas: adelanta las que cerraron sin pujas y quedaron programadas lejos. Las filas existentes quedan `SCHEDULED`.
- `0025_reschedule_programmed_auctions.sql`: `auctions_reject_backward_update` deja adelantar `ends_at` en una sala que sigue `PROGRAMADA`, porque no tiene pujas activas. La rotación la usa para reciclar salas y el vendedor para abrir ya la sala programada de su obra. En una sala abierta, el cierre sigue sin poder retroceder.

## [0.9.0] - 2026-10-30

PostgreSQL pasa a ser el único motor. Pensado para desplegar en un solo plan gratuito en la nube: una base, un respaldo, una credencial por servicio.

### Added

- `0022_documents_to_postgres.sql`. Las colecciones de Mongo pasan a ser tablas en el esquema de su dueño:
  - `identity.refresh_sessions`. El índice TTL de Mongo se reemplaza por `refresh_sessions_expires_idx`, que usa el barrido de identity-service.
  - `audit.reports`: el informe completo, 1 a 1 con su resumen y con FK a `audit_summaries`. El expediente y la evaluación van en JSONB. Se escribe en la misma transacción que el resumen.
  - `gallery.items` y `gallery.activity`, con los ids deterministas de gallery-service.
  - El esquema `notification`, con `notifications`, `inbox` y el rol `notification_rw`.
- Login `notification_svc` en `create-logins.sh` (`NOTIFICATION_DB_PASSWORD`).
- Semilla `006_documents.sql`: informes con el formato actual de audit-service, galería social y feed. La cola de revisión muestra la evidencia de la obra anacrónica de la semilla.
- La aserción de aislamiento incluye `notification`, y la CI comprueba que su login no lee otros esquemas.

### Removed

- `audit_summaries.mongo_report_id`: el informe ahora usa como llave el id del resumen.
- MongoDB: `mongo/` (esquemas Mongoose e índices), `scripts/seed/mongo-samples.mjs`, `scripts/backup/mongo.sh`, los scripts `indexes:mongo` y `backup:mongo`, la dependencia `mongoose` y el job de Mongo en la CI.
- La colección `event_logs`, que ningún servicio usaba desde que se retiró el monolito. No tiene reemplazo.

### Changed

- La semilla `002_artworks.sql` registra quién decidió cada auditoría (`decided_by`).

## [0.8.0] - 2026-10-29

### Removed

- Las 16 vistas de compatibilidad de `public` (contract de 0016). Con el monolito retirado ningún servicio lee `public`; solo queda `schema_migrations`.
- Esquema `pgboss`, la cola de auditoría del monolito. audit-service usa `audit.audit_requests` desde 0.7.0.
- Esquema `audit_queue`, reservado para pg-boss en 0016 y nunca usado.

### Changed

- La imagen de Docker trae además los scripts de logins y de semilla, para que el docker compose del backend prepare una base vacía. Su comando por defecto sigue siendo aplicar las migraciones.
- `.gitattributes` fuerza LF en los `.sh`: con CRLF, al clonar en Windows, bash falla dentro de los contenedores.

### Fixed

- La semilla `003_auctions.sql` da a la subasta su `seller_id` y su `lot_title`, obligatorios desde 0.7.0; antes los completaba el trigger que 0020 eliminó.

## [0.7.0] - 2026-10-29

### Added

- `audit.audit_requests`: cola de auditorías de audit-service. Cada `LotSubmitted` crea una solicitud en la misma transacción que su inbox; el worker la toma con `FOR UPDATE SKIP LOCKED` y un lease, y reintenta con backoff. El índice único parcial `audit_requests_pending_lot_uidx` permite una sola auditoría pendiente por obra.
- `audit.ai_assessments`: caché de evaluaciones de la IA por huella SHA-256 del expediente de evidencias, el modelo y la versión del prompt. Reauditar una obra sin cambios no gasta tokens.
- `audit.audit_summaries.decided_by` (`RULES`, `AI` o `FALLBACK`) y `dossier_hash`.

### Changed

- `auction.auctions.seller_id` y `lot_title` pasan a `NOT NULL`. La migración falla si alguna subasta no tiene la copia.

### Removed

- Trigger transitorio `auctions_fill_lot_copy` y función `auction.fill_lot_copy()` (contract de 0018). audit-service envía el vendedor y el título en `AuditCompleted`; ya no queda ninguna lectura entre esquemas.

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

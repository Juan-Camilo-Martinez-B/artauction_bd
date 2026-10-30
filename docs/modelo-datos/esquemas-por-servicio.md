# Un esquema por microservicio

Desde `v0.4.0` el backend es un conjunto de microservicios. Cada uno es dueño exclusivo de un esquema de Postgres y nadie más lo lee ni lo escribe. La decisión está en el ADR 0003 del repositorio del backend.

## Reparto

| Esquema       | Servicio         | Tablas                                                                                                    |
| ------------- | ---------------- | --------------------------------------------------------------------------------------------------------- |
| `identity`    | identity-service | `users`, `refresh_sessions`                                                                               |
| `catalog`     | catalog-service  | `lots`, `lot_images`, `categories`, `lot_categories`, `outbox`, `inbox`                                   |
| `auction`     | auction-service  | `auctions`, `bids`, `transactions`, `outbox`, `inbox`                                                     |
| `wallet`      | wallet-service   | `wallets`, `payment_orders`, `wallet_entries`, `bid_holds`, `hold_reservations`, `platform_fees`, `inbox` |
| `audit`       | audit-service    | `audit_summaries`, `reports`, `audit_requests`, `ai_assessments`, `outbox`, `inbox`                       |
| `gallery`     | gallery-service  | `follows`, `personal_galleries`, `personal_gallery_artworks`, `items`, `activity`, `inbox`                |
| `notification` | notification-service | `notifications`, `inbox`                                                                              |
| `public`      | ninguno          | `schema_migrations` (registro de migraciones)                                   |

```mermaid
flowchart LR
  subgraph identity
    users
  end
  subgraph catalog
    lots --- lot_images
    lots --- lot_categories --- categories
  end
  subgraph auction
    auctions --- bids
    auctions --- transactions
  end
  subgraph wallet
    wallets
    payment_orders --- wallet_entries
    bid_holds
  end
  subgraph audit
    audit_summaries
  end
  subgraph gallery
    personal_galleries --- personal_gallery_artworks
    follows
  end
```

Las líneas son llaves foráneas y solo existen dentro de un esquema. Una referencia a otro contexto (`lots.seller_id`, `bids.bidder_id`, `wallet_entries.auction_id`, ...) es un UUID sin llave foránea. La integridad entre servicios la sostienen los casos de uso y los eventos del outbox; `scripts/migrate/assert.sql` falla si aparece una llave foránea entre esquemas.

Consecuencia: las llaves con `ON DELETE CASCADE` hacia `users` (seguimientos y galería personal) ya no borran en cascada. Hoy no existe el borrado de cuentas; cuando exista, identity publicará un evento y cada servicio borrará lo suyo.

### Copias de otro contexto

Un servicio que necesita un dato ajeno para decidir guarda una copia en su esquema, recibida por evento. `auction.auctions.seller_id` y `lot_title` (migración `0018`) son la copia de la obra con la que auction-service rechaza que un vendedor puje en su propia subasta y redacta la venta, sin leer `catalog`.

Hasta F7 la auditoría del monolito creaba subastas sin esa copia y un trigger transitorio (`auctions_fill_lot_copy`) la completaba desde `catalog.lots`. La migración `0020` lo eliminó y volvió obligatorias las dos columnas: audit-service envía el vendedor y el título en `AuditCompleted`, y ya no queda ninguna lectura entre esquemas.

## Roles

La migración `0016` crea un rol de grupo sin login por servicio (`identity_rw`, `catalog_rw`, ...) con `SELECT, INSERT, UPDATE, DELETE` sobre su esquema y privilegios por defecto para las tablas futuras. Ningún rol de servicio puede hacer DDL: el esquema solo cambia por migraciones de este repositorio.

Los usuarios con login los crea `npm run roles` (`scripts/roles/create-logins.sh`) con las contraseñas de `<SERVICIO>_DB_PASSWORD`. Cada login se llama `<servicio>_svc`, pertenece a su rol de grupo y tiene `search_path` en su esquema. Las contraseñas nunca entran en el historial.

```bash
export DATABASE_URL=postgresql://artauction:artauction@localhost:5433/artauction
export CATALOG_DB_PASSWORD="$(openssl rand -base64 24)"
npm run roles
```

## Outbox e inbox

| Tabla    | Columnas clave                                                                                   | Uso                                                                                                                                                    |
| -------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `outbox` | `id`, `seq`, `event_type`, `aggregate_id`, `payload`, `available_at`, `attempts`, `published_at` | El productor inserta el evento en la misma transacción que el cambio de estado. El relay lo entrega por gRPC en orden de `seq` y marca `published_at`. |
| `inbox`  | `event_id`, `event_type`, `processed_at`                                                         | El consumidor inserta el id del evento en la misma transacción en la que lo aplica. Un duplicado choca con la llave primaria y se descarta.            |

`payload` es el evento de dominio en JSON. La capa api del servicio lo traduce al mensaje protobuf al entregarlo, así la capa interna no conoce el transporte.

## Expand y contract

`0016` es la fase expand:

1. `ALTER TABLE ... SET SCHEMA` mueve las tablas sin copiar filas; índices, restricciones y triggers se mueven con ellas.
2. Se eliminan las llaves foráneas entre esquemas.
3. Se crean los roles, el outbox y el inbox.
4. Se crean vistas en `public` con el nombre de cada tabla. Son vistas simples que Postgres actualiza de forma automática: el monolito sigue funcionando sin cambios mientras dura la migración del backend, incluidos `INSERT ... ON CONFLICT` y `SELECT ... FOR UPDATE`.

La fase contract fue la migración `0021` (F9): con el monolito retirado, eliminó las 16 vistas y los esquemas sin uso `pgboss` (la cola del monolito) y `audit_queue` (reservado para pg-boss y nunca usado; audit-service usa `audit.audit_requests`).

## Sin Mongo (desde 0022)

Hasta `v0.8.0` cuatro servicios guardaban documentos en una base de Mongo propia: identity, audit, gallery y notification. La migración `0022` los trajo a su esquema de Postgres, y notification recibió su esquema, su rol `notification_rw` y su login `notification_svc`. Ahora hay un solo motor que desplegar, respaldar y vigilar. Lo que en Mongo era un documento se guarda en JSONB, y el índice TTL de las sesiones lo reemplaza un barrido de identity-service.

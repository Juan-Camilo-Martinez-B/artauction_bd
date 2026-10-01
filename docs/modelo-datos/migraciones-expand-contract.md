# Migraciones expand/contract

Cada cambio de este repositorio tiene que poder desplegarse mientras la versión anterior del backend sigue atendiendo tráfico. El tag del esquema (`v0.1.0`, `v0.2.0`, …) es el contrato que el backend fija. No se renombra ni se borra una columna en el mismo release en el que el código viejo todavía la lee.

## Expand

Se añade algo que el código viejo puede ignorar.

1. Columna nueva **nullable**, sin `NOT NULL` y sin un default que el código viejo no entienda.
2. Índice nuevo. En una tabla grande se crea con `CONCURRENTLY` y esa migración **no** puede ir dentro de la transacción de `scripts/migrate/apply.sh`: se aplica a mano y se registra en `schema_migrations`. Las tablas de este MVP se crean vacías, así que los índices de `0010` van en una transacción normal.
3. Ampliar un `CHECK`. Primero se elimina la restricción estrecha y se crea la amplia. El código viejo solo escribe valores que ambas aceptan.

Ejemplos que ya están en el historial:

- `0005_create_bids.sql` crea `idempotency_key` y `0006_unique_bid_idempotency_key.sql` añade la unicidad en el commit siguiente.
- `0011_add_business_check_constraints.sql` añade las reglas de dinero y de score después de que las tablas ya existían.

## Contract

Se retira lo viejo cuando ningún despliegue activo lo usa.

1. El backend del tag nuevo deja de leer y de escribir la columna.
2. Se espera a que ese tag sea el único en producción.
3. Una migración posterior elimina la columna, el índice o la restricción.

Un `DROP COLUMN` no convive con un backend que todavía hace `SELECT *` sobre esa tabla y mapea todas las columnas. Prisma con un cliente generado a partir del tag anterior fallaría o, peor, ignoraría datos.

## Ejemplo futuro: volver a subastar un lote cerrado

Hoy `auctions.lot_id` es único: un lote tiene una sola subasta. Para permitir otra subasta después de `CERRADA`:

1. **Expand.** Crear un índice único parcial `WHERE status IN ('PROGRAMADA', 'ACTIVA')` sin quitar todavía `auctions_lot_id_key`. El código nuevo escribe la segunda fila solo cuando la anterior está cerrada, pero el unique viejo se lo impide: por eso este paso todavía no inserta la segunda subasta.
2. Desplegar el backend que entiende varias subastas históricas y sigue creando una sola activa.
3. **Contract.** Eliminar `auctions_lot_id_key` en una migración posterior. A partir de ese tag el parcial es la única unicidad.

Quitar el unique y crear el parcial en la misma migración rompe el backend que asume una subasta por lote.

## Los dos motores

`audit_summaries.mongo_report_id` y `gallery_items.lotId` son UUID, no claves foráneas. El orden de escritura es:

1. Confirmar la fila en Postgres.
2. Escribir el documento en Mongo.
3. Si Mongo falla, la fila relacional sigue siendo válida y el trabajo se reintenta. No se compensa con un rollback distribuido.

Borrar en el sentido contrario (Mongo primero) dejaría un resumen que apunta a un informe que ya no está. La retención de `event_logs` (90 días) no toca Postgres.

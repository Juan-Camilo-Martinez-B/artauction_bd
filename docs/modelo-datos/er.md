# Modelo de datos

Postgres guarda lo que debe ser consistente bajo una transacción (cuentas, lotes, pujas, liquidación). Mongo guarda documentos de auditoría, la galería y el feed. La referencia cruzada es un UUID. No hay una transacción que abarque los dos motores: primero se confirma Postgres y después se escribe Mongo.

El visitante no tiene fila en `users`. Los roles persistidos son `USER`, `SELLER` y `ADMIN`.

## Relacional

```mermaid
erDiagram
  users ||--o{ lots : vende
  users ||--o{ bids : puja
  users ||--o{ auctions : gana
  users ||--o{ transactions : compra
  users ||--o{ transactions : cobra
  users ||--o{ follows : sigue
  users ||--o{ follows : es_seguido
  lots ||--o{ lot_images : ilustra
  lots ||--o| auctions : subasta
  lots ||--o{ audit_summaries : resume
  lots ||--o{ transactions : liquida
  auctions ||--o{ bids : recibe
  auctions ||--o| bids : puja_ganadora
  auctions ||--o| transactions : cierra
```

| Tabla | Papel |
|---|---|
| `users` | Cuenta, rol y visibilidad del perfil. El correo se guarda en minúsculas. |
| `lots` | Obra. Tras la auditoría aprobada queda `PUBLICADA`, pasa a `EN_SUBASTA` y termina en `VENDIDA` o vuelve a `PUBLICADA`. El detalle está en `subastas-artacoins.md`. |
| `lot_images` | Clave del objeto en Cloud Storage, orden y hash perceptual. El binario no está aquí. |
| `auctions` | Una subasta por lote. Si cierra sin venta, la misma fila se reprograma. `ends_at` es el cierre vigente. |
| `bids` | Puja con `idempotency_key` único. `winning_bid_id` en la subasta apunta a la puja ganadora. |
| `transactions` | Como máximo una liquidación por subasta. Comprador y vendedor son distintos. |
| `audit_summaries` | Score, rango de precio y veredicto. `mongo_report_id` apunta al informe completo. |
| `follows` | Arista dirigida. Una cuenta no puede seguirse a sí misma. |

Transiciones de lote que el servicio de catálogo debe respetar:

- `BORRADOR` → `PENDIENTE_AUDITORIA`
- `PENDIENTE_AUDITORIA` → `PUBLICADA` o `REVISION_MANUAL`
- `REVISION_MANUAL` → `PUBLICADA` o `BORRADOR`
- `PUBLICADA` → `EN_SUBASTA`
- `EN_SUBASTA` → `VENDIDA` o `PUBLICADA`

`APROBADO` y `CERRADO` siguen aceptados para filas anteriores. `current_price` no baja y `ends_at` no se adelanta, salvo el retiro de la puja ganadora y la reprogramación, que lo hacen dentro de la transacción. El contrato de artacoins, retenciones y calendario está en `subastas-artacoins.md`.

## Documentos

```mermaid
erDiagram
  audit_summaries ||--|| audit_reports : mongo_report_id
  lots ||--o{ gallery_items : lotId
  users ||--o{ gallery_items : ownerId
  users ||--o{ activity_feed : actorId
```

| Colección | Papel |
|---|---|
| `audit_reports` | Modelo, versión de prompt, entrada, hallazgos y fecha. `summaryId` es único y corresponde a `audit_summaries.id`. |
| `gallery_items` | Obra propia, ganada o gratuita. La visibilidad es `PUBLIC` o `PRIVATE` por pieza. |
| `activity_feed` | Verbos `PUBLISH`, `BID`, `WIN`, `FOLLOW`, `AUDIT`. El muro público filtra `visibility = PUBLIC`. |
| `event_logs` | Bitácora técnica con `correlationId`. Un índice TTL borra documentos a los 90 días. |

Una obra con `gallery_items.visibility = PRIVATE` o `lots.visibility = PRIVATE` no entra en los índices de lectura pública (`lots_public_catalog_idx`, `gallery_items_public_owner`).

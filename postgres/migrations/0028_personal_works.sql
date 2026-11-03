-- Proyectos propios: obras que su autor sube solo para su galeria personal.
-- No pasan por auditoria, no tienen score ni precio y nunca entran al catalogo
-- ni a una subasta. Pasarlas al catalogo las lleva a PENDIENTE_AUDITORIA.
-- La visibilidad (PUBLIC o PRIVATE) decide si se ven en la galeria publica del
-- autor; el catalogo publico filtra por estado, asi que nunca las lista.

ALTER TABLE catalog.lots DROP CONSTRAINT lots_status_check;
ALTER TABLE catalog.lots ADD CONSTRAINT lots_status_check CHECK (
  status IN (
    'BORRADOR',
    'PERSONAL',
    'PENDIENTE_AUDITORIA',
    'APROBADO',
    'PUBLICADA',
    'REVISION_MANUAL',
    'EN_SUBASTA',
    'CERRADO',
    'VENDIDA'
  )
);

-- Mis obras del autor: sus proyectos propios por fecha.
CREATE INDEX lots_seller_personal_idx ON catalog.lots (seller_id, created_at DESC) WHERE status = 'PERSONAL';

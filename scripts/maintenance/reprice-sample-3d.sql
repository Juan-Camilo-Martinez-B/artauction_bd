-- Corrige el precio de las obras 3D de muestra (npm run catalog:sample-3d en
-- artauction_backend) que la auditoria publico con el rango generico de su
-- evaluacion local (400-800): pasa cuando Gemini no responde y deja igual una
-- estatua de tamano natural que un elefante de 10 cm.
--
-- Pone a cada obra el rango del script de muestra y recalcula su sala con las
-- reglas de auction-service (domain/auction-rules.ts): salida = punto medio
-- del rango (minimo 50), incremento = 5 % de la salida (minimo 10) y compra
-- inmediata = salida x factor (BUY_NOW_FACTOR, 3 por omision) redondeada hacia
-- arriba a multiplos de 50. Si esas reglas cambian, este script debe seguirlas.
--
-- Solo toca obras que siguen con 400-800 y salas PROGRAMADA sin pujas: una sala
-- abierta o con pujas no cambia de precio. Repetirlo no hace nada.
-- Sin `-v apply=1` es una vista previa que se revierte.
\set ON_ERROR_STOP on
\if :{?buy_now_factor}
\else
\set buy_now_factor 3
\endif
BEGIN;

CREATE TEMP TABLE prices (title TEXT PRIMARY KEY, price_min INTEGER, price_max INTEGER) ON COMMIT DROP;
INSERT INTO prices VALUES
  ('Estatua gótica con corona y cadenas', 2400, 3600),
  ('Ballena de bronce', 1500, 2200),
  ('Busto de mármol de un hombre joven', 900, 1400),
  ('Cabeza de león', 700, 1100),
  ('Caballo encabritado de porcelana', 300, 500),
  ('Gato sentado', 250, 400),
  ('Elefante tallado en madera', 120, 200),
  ('Jarrón antiguo de cerámica', 600, 900),
  ('Jarrón alto de latón', 450, 700),
  ('Jarrón de cerámica', 200, 350),
  ('Reloj de chimenea', 800, 1200),
  ('Reloj de pie antiguo', 1800, 2600);

CREATE TEMP TABLE targets ON COMMIT DROP AS
SELECT l.id AS lot_id, l.title, p.price_min, p.price_max,
  greatest(50, round((p.price_min + p.price_max) / 2.0))::integer AS opening
FROM catalog.lots l
JOIN prices p ON p.title = l.title
WHERE l.provenance LIKE 'Modelo 3D CC0 de Poly Haven%'
  AND l.suggested_price_min = 400 AND l.suggested_price_max = 800;

CREATE TEMP TABLE auction_targets ON COMMIT DROP AS
SELECT a.id AS auction_id, t.title, t.opening,
  greatest(10, round(t.opening * 0.05))::integer AS increment,
  greatest(
    (ceil(t.opening * :buy_now_factor / 50.0) * 50)::integer,
    ((floor(t.opening / 50.0) + 1) * 50)::integer
  ) AS buy_now
FROM targets t
JOIN auction.auctions a ON a.lot_id = t.lot_id
WHERE a.status = 'PROGRAMADA'
  AND NOT EXISTS (SELECT 1 FROM auction.bids b WHERE b.auction_id = a.id);

\echo
\echo 'Precios nuevos:'
SELECT t.title AS obra, t.price_min AS minimo, t.price_max AS maximo,
  at.opening AS salida, at.increment AS incremento, at.buy_now AS compra_inmediata,
  CASE WHEN at.auction_id IS NULL THEN 'sala abierta o con pujas: sin cambio' ELSE 'sala recalculada' END AS sala
FROM targets t LEFT JOIN auction_targets at ON at.title = t.title
ORDER BY t.price_max DESC;

UPDATE catalog.lots l
SET suggested_price_min = t.price_min, suggested_price_max = t.price_max
FROM targets t WHERE l.id = t.lot_id;

-- Una sala programada sin pujas aun no tiene precio que proteger: se permite
-- bajarlo solo en esta transaccion (el mismo permiso que usa 0025).
SET LOCAL artauction.allow_auction_rewind = 'on';
UPDATE auction.auctions a
SET start_price = at.opening, current_price = at.opening, min_increment = at.increment, buy_now_price = at.buy_now
FROM auction_targets at WHERE a.id = at.auction_id;

SELECT (SELECT count(*) FROM targets) AS obras, (SELECT count(*) FROM auction_targets) AS salas;

\if :{?apply}
COMMIT;
\echo 'Precios aplicados.'
\else
ROLLBACK;
\echo 'Vista previa: no se cambio nada. Para aplicarlo, repetir con --apply.'
\endif

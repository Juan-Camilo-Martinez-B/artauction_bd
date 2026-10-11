# Subastas y artacoins

Contrato compartido por Postgres, la API y el cliente. La versión de las funciones puras es `artauction-auction-contract-1`.

## Qué decide la auditoría y qué decide el reloj

La auditoría sigue guardando el veredicto `APROBADO` o `REVISION_MANUAL`. Si el veredicto es `APROBADO`, la obra pasa a `PUBLICADA` y queda en el catálogo.

Sobre una obra aprobada, la IA solo fija tres condiciones:

- precio inicial en artacoins enteros: el punto medio de la banda de precio, con un mínimo de 50;
- duración de la sala: entre 30 y 180 minutos, según el score de autenticidad;
- texto de venta, a partir del título y del informe.

El incremento mínimo lo pone el sistema: el 5 % del precio inicial, y nunca menos de 10 artacoins.

La fecha y la hora de apertura las elige el servidor, no la IA ni el navegador. El inicio cae al azar entre 15 minutos y 48 horas después del `now` del servidor. El cierre es ese inicio más la duración. Una fecha calculada no puede quedar en el pasado. Si la sala termina sin venta, se anulan las pujas activas, se liberan las retenciones y se vuelve a sortear una ventana futura. La obra regresa a `PUBLICADA`.

## Estados de la obra

| Estado | Dónde se ve |
|---|---|
| `PUBLICADA` | Catálogo. Tiene una subasta `PROGRAMADA` o acaba de volver de una sala sin venta. |
| `EN_SUBASTA` | Catálogo y sala. La subasta está `ACTIVA`. |
| `VENDIDA` | Fuera del catálogo. La pieza queda en la galería de quien ganó, con origen `GANADA`. |

`BORRADOR`, `PENDIENTE_AUDITORIA` y `REVISION_MANUAL` siguen siendo privados. `APROBADO` se conserva para filas anteriores; el camino nuevo escribe `PUBLICADA`. `CERRADO` no vuelve al catálogo.

Transiciones nuevas:

- `PENDIENTE_AUDITORIA` → `PUBLICADA`
- `REVISION_MANUAL` → `PUBLICADA`
- `PUBLICADA` → `EN_SUBASTA`
- `EN_SUBASTA` → `VENDIDA` si hubo puja ganadora
- `EN_SUBASTA` → `PUBLICADA` si la sala cierra vacía

Hay una sola fila de subasta por obra. La reprogramación reutiliza esa fila: vuelve a `PROGRAMADA`, restaura el precio inicial y mueve `starts_at` y `ends_at` hacia el futuro.

## Orden de las pujas

Cada puja entra a una cola por subasta y, dentro de la transacción, bloquea la fila con `SELECT … FOR UPDATE`. La que llega primero se confirma primero. Si dos personas ofertan el mismo monto, la segunda recibe: `La oferta de 2000 ya fue publicada por otro usuario.` El monto se muestra como entero. Un índice único parcial sobre pujas activas impide que el empate se guarde aunque la aplicación falle.

La primera puja puede igualar el precio inicial. Las siguientes tienen que superar el precio actual más el incremento. Solo se aceptan artacoins enteros. El vendedor no puja por su obra. En los últimos 30 segundos, una puja válida alarga el cierre 30 segundos. Ese alargue no abre la ventana de retiro.

## Retención

El bolsillo guarda artacoins enteros. Ofertar saca del disponible solo el aumento respecto a la retención anterior de esa persona en esa sala.

- primera oferta 250: se retienen 250;
- siguiente oferta 320: se retienen 70 más;
- el total retenido queda en 320 hasta el cierre o el retiro.

Si el disponible no alcanza el aumento, la puja se rechaza y no se escribe.

## Retiro

Se puede abandonar la sala solo cuando faltan al menos 4 minutos para `ends_at`, medido con el reloj del servidor. Dentro de esos 4 minutos el retiro se niega y la sala sigue. Al retirarse se devuelven las artacoins retenidas y se anulan sus pujas activas. Si esa persona iba ganando, el precio vuelve a la puja activa más alta que quede, o al precio inicial si no queda ninguna.

El trigger que impide bajar `current_price` sigue activo. El retiro y la reprogramación lo cruzan solo con `set_config('artauction.allow_auction_rewind', 'on', true)` dentro de la misma transacción.

## Cierre

Con puja ganadora: la subasta queda `CERRADA`, la obra `VENDIDA` y privada, la retención del ganador se canjea por la obra y el resto de retenciones vuelve a cada bolsillo. La transacción queda `COMPLETADA`. Sin pujas activas: nadie paga, la obra vuelve a `PUBLICADA` y el servidor agenda otra apertura futura.

## Pasarela simulada

`POST /wallet/top-ups` recibe un monto de artacoins y una tarjeta inventada. No se guarda el número completo, la caducidad ni el código. Solo quedan los últimos cuatro dígitos, la marca y el resultado. Una tarjeta válida pasa Luhn, no está vencida y no es `4000000000000002`, que siempre se rechaza. Cada artacoin se cobra como 1.00 USD simulado. El abono entra al disponible del bolsillo.

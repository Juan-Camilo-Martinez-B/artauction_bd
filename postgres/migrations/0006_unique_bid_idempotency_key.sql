-- Una misma clave de idempotencia no puede aceptar dos pujas.

CREATE UNIQUE INDEX bids_idempotency_key_key ON bids (idempotency_key);

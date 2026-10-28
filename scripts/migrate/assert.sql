-- Comprueba el catálogo y las invariantes de puja. La transacción se revierte.
BEGIN;

INSERT INTO identity.users (id, email, password_hash, display_name, role)
VALUES
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1', 'assert-seller@artauction.local', 'hash-not-used-assert-only', 'Assert Seller', 'SELLER'),
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2', 'assert-bidder@artauction.local', 'hash-not-used-assert-only', 'Assert Bidder', 'USER');

INSERT INTO catalog.lots (id, seller_id, title, description, materials, status, visibility)
VALUES (
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb1',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
  'Obra assert',
  'Ficha de prueba del trigger.',
  'Óleo',
  'EN_SUBASTA',
  'PUBLIC'
);

INSERT INTO auction.auctions (
  id, lot_id, start_price, current_price, min_increment, starts_at, ends_at, initial_ends_at, status
) VALUES (
  'cccccccc-cccc-4ccc-8ccc-ccccccccccc1',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb1',
  100, 100, 10,
  now() - interval '1 hour',
  now() + interval '2 days',
  now() + interval '1 day',
  'ACTIVA'
);

UPDATE auction.auctions
SET current_price = 150
WHERE id = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';

DO $$
BEGIN
  UPDATE auction.auctions
  SET current_price = 120
  WHERE id = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';
  RAISE EXCEPTION 'price decrease was accepted';
EXCEPTION
  WHEN check_violation THEN
    NULL;
END $$;

DO $$
BEGIN
  UPDATE auction.auctions
  SET ends_at = now() + interval '1 day 1 hour'
  WHERE id = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';
  RAISE EXCEPTION 'ends_at decrease was accepted';
EXCEPTION
  WHEN check_violation THEN
    NULL;
END $$;

INSERT INTO auction.bids (id, auction_id, bidder_id, amount, idempotency_key)
VALUES (
  'dddddddd-dddd-4ddd-8ddd-ddddddddddd1',
  'cccccccc-cccc-4ccc-8ccc-ccccccccccc1',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2',
  160,
  'assert-idem-key-1'
);

DO $$
BEGIN
  INSERT INTO auction.bids (auction_id, bidder_id, amount, idempotency_key)
  VALUES (
    'cccccccc-cccc-4ccc-8ccc-ccccccccccc1',
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2',
    170,
    'assert-idem-key-1'
  );
  RAISE EXCEPTION 'duplicate idempotency was accepted';
EXCEPTION
  WHEN unique_violation THEN
    NULL;
END $$;

DO $$
BEGIN
  INSERT INTO gallery.follows (follower_id, followee_id)
  VALUES ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1');
  RAISE EXCEPTION 'self follow was accepted';
EXCEPTION
  WHEN check_violation THEN
    NULL;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'bids_idempotency_key_key'
  ) THEN
    RAISE EXCEPTION 'missing bids_idempotency_key_key';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'auctions_reject_backward_update'
  ) THEN
    RAISE EXCEPTION 'missing auctions_reject_backward_update';
  END IF;
END $$;

-- Recarga idempotente: la misma clave de un usuario no crea una segunda orden.
INSERT INTO wallet.payment_orders (user_id, coins, amount_cents, status, card_brand, card_last4, idempotency_key, request_hash)
VALUES (
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2', 100, 10000, 'APROBADO', 'visa', '4242',
  'assert-topup-key-1', repeat('a', 64)
);

DO $$
BEGIN
  INSERT INTO wallet.payment_orders (user_id, coins, amount_cents, status, card_brand, card_last4, idempotency_key, request_hash)
  VALUES (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2', 100, 10000, 'APROBADO', 'visa', '4242',
    'assert-topup-key-1', repeat('a', 64)
  );
  RAISE EXCEPTION 'duplicate top-up idempotency key was accepted';
EXCEPTION
  WHEN unique_violation THEN
    NULL;
END $$;

-- Una reserva TCC debe cuadrar: reservado = siguiente - anterior.
DO $$
BEGIN
  INSERT INTO wallet.hold_reservations (reservation_id, auction_id, bidder_id, previous_coins, next_coins, reserved_coins, expires_at)
  VALUES ('assert-reservation-1', 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2', 100, 150, 10, now());
  RAISE EXCEPTION 'unbalanced hold reservation was accepted';
EXCEPTION
  WHEN check_violation THEN
    NULL;
END $$;

-- Esquema por servicio: ninguna llave foránea cruza esquemas, cada servicio
-- tiene su rol de grupo y ningún rol de servicio ve el esquema de otro.
DO $$
DECLARE
  crossing INTEGER;
  service TEXT;
  other TEXT;
BEGIN
  SELECT count(*) INTO crossing
  FROM pg_constraint c
  JOIN pg_class t ON t.oid = c.conrelid
  JOIN pg_class r ON r.oid = c.confrelid
  WHERE c.contype = 'f' AND t.relnamespace <> r.relnamespace;
  IF crossing > 0 THEN
    RAISE EXCEPTION '% foreign keys cross schemas', crossing;
  END IF;

  FOREACH service IN ARRAY ARRAY['identity', 'catalog', 'auction', 'wallet', 'audit', 'gallery'] LOOP
    IF NOT has_schema_privilege(service || '_rw', service, 'USAGE') THEN
      RAISE EXCEPTION 'role %_rw cannot use schema %', service, service;
    END IF;
    FOREACH other IN ARRAY ARRAY['identity', 'catalog', 'auction', 'wallet', 'audit', 'gallery'] LOOP
      IF other <> service AND has_schema_privilege(service || '_rw', other, 'USAGE') THEN
        RAISE EXCEPTION 'role %_rw can use foreign schema %', service, other;
      END IF;
    END LOOP;
  END LOOP;

  IF to_regclass('auction.outbox') IS NULL OR to_regclass('wallet.inbox') IS NULL THEN
    RAISE EXCEPTION 'missing outbox or inbox tables';
  END IF;
END $$;

ROLLBACK;

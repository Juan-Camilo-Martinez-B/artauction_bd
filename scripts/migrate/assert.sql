-- Comprueba el catálogo y las invariantes de puja. La transacción se revierte.
BEGIN;

INSERT INTO users (id, email, password_hash, display_name, role)
VALUES
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1', 'assert-seller@artauction.local', 'hash-not-used-assert-only', 'Assert Seller', 'SELLER'),
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2', 'assert-bidder@artauction.local', 'hash-not-used-assert-only', 'Assert Bidder', 'USER');

INSERT INTO lots (id, seller_id, title, description, materials, status, visibility)
VALUES (
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb1',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
  'Obra assert',
  'Ficha de prueba del trigger.',
  'Óleo',
  'EN_SUBASTA',
  'PUBLIC'
);

INSERT INTO auctions (
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

UPDATE auctions
SET current_price = 150
WHERE id = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';

DO $$
BEGIN
  UPDATE auctions
  SET current_price = 120
  WHERE id = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';
  RAISE EXCEPTION 'price decrease was accepted';
EXCEPTION
  WHEN check_violation THEN
    NULL;
END $$;

DO $$
BEGIN
  UPDATE auctions
  SET ends_at = now() + interval '1 day 1 hour'
  WHERE id = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';
  RAISE EXCEPTION 'ends_at decrease was accepted';
EXCEPTION
  WHEN check_violation THEN
    NULL;
END $$;

INSERT INTO bids (id, auction_id, bidder_id, amount, idempotency_key)
VALUES (
  'dddddddd-dddd-4ddd-8ddd-ddddddddddd1',
  'cccccccc-cccc-4ccc-8ccc-ccccccccccc1',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2',
  160,
  'assert-idem-key-1'
);

DO $$
BEGIN
  INSERT INTO bids (auction_id, bidder_id, amount, idempotency_key)
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
  INSERT INTO follows (follower_id, followee_id)
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

ROLLBACK;

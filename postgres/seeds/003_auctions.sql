-- Una sala activa, con dos pujas que suben el precio, y una subasta programada.

INSERT INTO auctions (
  id, lot_id, start_price, current_price, min_increment, currency,
  starts_at, ends_at, initial_ends_at, status, extension_count
)
VALUES
  (
    'c0000000-0000-4000-8000-000000000001',
    'b0000000-0000-4000-8000-000000000002',
    100.00, 150.00, 10.00, 'USD',
    now() - interval '2 hours',
    now() + interval '3 days',
    now() + interval '3 days',
    'ACTIVA',
    0
  ),
  (
    'c0000000-0000-4000-8000-000000000002',
    'b0000000-0000-4000-8000-000000000001',
    800.00, 800.00, 50.00, 'USD',
    now() + interval '2 days',
    now() + interval '9 days',
    now() + interval '9 days',
    'PROGRAMADA',
    0
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO bids (id, auction_id, bidder_id, amount, idempotency_key)
VALUES
  (
    'd0000000-0000-4000-8000-000000000001',
    'c0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000003',
    120.00,
    'seed-bid-clock-leo'
  ),
  (
    'd0000000-0000-4000-8000-000000000002',
    'c0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000004',
    150.00,
    'seed-bid-clock-nora'
  )
ON CONFLICT (id) DO NOTHING;

UPDATE lots
SET status = 'EN_SUBASTA', updated_at = now()
WHERE id = 'b0000000-0000-4000-8000-000000000002'
  AND status = 'APROBADO';

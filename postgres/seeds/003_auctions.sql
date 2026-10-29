-- Una subasta programada sobre el retrato de la costa. Desde 0020 la subasta
-- lleva su propia copia del vendedor y del titulo de la obra.

INSERT INTO auction.auctions (
  id, lot_id, seller_id, lot_title, start_price, current_price, min_increment, currency,
  starts_at, ends_at, initial_ends_at, status, extension_count
)
VALUES
  (
    'c0000000-0000-4000-8000-000000000002',
    'b0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000002',
    'Retrato de la costa',
    800.00, 800.00, 50.00, 'USD',
    now() + interval '2 days',
    now() + interval '9 days',
    now() + interval '9 days',
    'PROGRAMADA',
    0
  )
ON CONFLICT (id) DO NOTHING;

-- Subastas rotativas del catalogo (F11): auction-service mantiene una cartelera
-- de salas cortas, de 15 a 30 minutos por defecto y configurables desde 1. El
-- minimo de 30 minutos de 0015 era la regla de las salas por score; esa regla
-- sigue en auction-service (MIN_DURATION_MINUTES), y la base solo exige una
-- duracion positiva con el mismo tope. La cartelera usa los indices parciales
-- que ya existen (auctions_due_to_open_idx y auctions_active_ends_at_idx).
ALTER TABLE auction.auctions
  DROP CONSTRAINT auctions_duration_minutes_check,
  ADD CONSTRAINT auctions_duration_minutes_check CHECK (duration_minutes BETWEEN 1 AND 180);

-- Avisos y actividad de la compra inmediata.
--
-- AUCTION_CLOSED sigue siendo el aviso del ganador y del vendedor; su payload
-- dice si cerro por compra inmediata. AUCTION_LOST es nuevo: lo reciben los
-- demas postores de una sala que cerro, con la devolucion de lo retenido.
ALTER TABLE notification.notifications DROP CONSTRAINT notifications_kind_check;
ALTER TABLE notification.notifications ADD CONSTRAINT notifications_kind_check
  CHECK (kind IN ('AUDIT', 'AUCTION_CLOSED', 'AUCTION_LOST', 'LOT_RETURNED'));

-- BUY_NOW: "Compro <obra> al instante" en el feed publico.
ALTER TABLE gallery.activity DROP CONSTRAINT activity_verb_check;
ALTER TABLE gallery.activity ADD CONSTRAINT activity_verb_check
  CHECK (verb IN ('PUBLISH', 'BID', 'WIN', 'BUY_NOW', 'FOLLOW', 'AUDIT'));

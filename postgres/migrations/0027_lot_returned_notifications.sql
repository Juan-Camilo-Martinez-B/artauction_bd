-- Aviso al vendedor cuando un administrador le devuelve una obra a borrador
-- (F12): el aviso trae el motivo para que pueda corregirla y reenviarla.
ALTER TABLE notification.notifications
  DROP CONSTRAINT notifications_kind_check,
  ADD CONSTRAINT notifications_kind_check CHECK (kind IN ('AUDIT', 'AUCTION_CLOSED', 'LOT_RETURNED'));

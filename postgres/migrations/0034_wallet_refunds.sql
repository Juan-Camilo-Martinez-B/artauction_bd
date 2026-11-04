-- Anulacion de una venta: el libro del bolsillo nunca borra movimientos, asi
-- que deshacer una venta deja dos asientos contrarios a los originales.
--
-- REEMBOLSO: vuelve al comprador lo que pago (el CANJE de su retencion).
-- ANULACION: se descuenta al vendedor lo que cobro (su VENTA, ya sin comision).
--
-- Los usa la limpieza de obras tridimensionales sin modelo 3D
-- (scripts/maintenance/delete-unmodeled-3d-lots.sql).
ALTER TABLE wallet.wallet_entries DROP CONSTRAINT wallet_entries_kind_check;
ALTER TABLE wallet.wallet_entries ADD CONSTRAINT wallet_entries_kind_check
  CHECK (kind IN ('RECARGA', 'RETENCION', 'LIBERACION', 'CANJE', 'VENTA', 'REEMBOLSO', 'ANULACION'));

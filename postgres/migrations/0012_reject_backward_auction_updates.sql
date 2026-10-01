-- El precio actual y el cierre solo pueden avanzar.
-- current_price >= start_price no basta: una puja de 150 no puede volver a 120.

CREATE OR REPLACE FUNCTION auctions_reject_backward_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.current_price < OLD.current_price THEN
    RAISE EXCEPTION 'current_price cannot decrease from % to %', OLD.current_price, NEW.current_price
      USING ERRCODE = 'check_violation';
  END IF;

  IF NEW.ends_at < OLD.ends_at THEN
    RAISE EXCEPTION 'ends_at cannot move backwards'
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER auctions_reject_backward_update
BEFORE UPDATE OF current_price, ends_at ON auctions
FOR EACH ROW
EXECUTE FUNCTION auctions_reject_backward_update();

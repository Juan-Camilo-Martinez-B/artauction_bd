-- El cierre de una sala no puede retroceder: protege a quien pujo contra un
-- cierre adelantado. Una sala PROGRAMADA no tiene pujas activas, asi que se
-- puede adelantar sin perjudicar a nadie. F11 lo necesita en dos casos: la
-- rotacion del catalogo adelanta una sala ROTATION que quedo programada lejos,
-- y el vendedor puede abrir ya la sala programada de su obra con sus terminos.
-- La regla del precio no cambia: bajar current_price sigue exigiendo
-- artauction.allow_auction_rewind en la transaccion.
CREATE OR REPLACE FUNCTION auction.auctions_reject_backward_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.current_price < OLD.current_price
     AND current_setting('artauction.allow_auction_rewind', true) IS DISTINCT FROM 'on' THEN
    RAISE EXCEPTION 'current_price cannot decrease from % to %', OLD.current_price, NEW.current_price
      USING ERRCODE = 'check_violation';
  END IF;

  IF NEW.ends_at < OLD.ends_at AND NOT (OLD.status = 'PROGRAMADA' AND NEW.status = 'PROGRAMADA') THEN
    RAISE EXCEPTION 'ends_at cannot move backwards'
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN NEW;
END;
$function$;

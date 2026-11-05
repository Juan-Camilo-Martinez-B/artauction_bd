-- Toda cuenta puede publicar: el registro ya no pregunta si la persona quiere
-- vender, y una cuenta nueva nace como SELLER. Las cuentas que ya eligieron no
-- vender pasan tambien a SELLER, para que nadie se quede sin esa opcion.
-- ADMIN no cambia. La sesion abierta conserva su rol hasta renovar el token.

UPDATE identity.users SET role = 'SELLER' WHERE role = 'USER';

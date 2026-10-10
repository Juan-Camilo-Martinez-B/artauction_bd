-- El retrato de la costa nació con una clave local que el catálogo no puede mostrar.
-- La imagen es la marina de dominio público Near Land's End, Cornwall (1879).

UPDATE lot_images
SET object_key = 'https://images.metmuseum.org/CRDImages/ad/web-large/ap50.9.jpg',
    width_px = NULL,
    height_px = NULL
WHERE lot_id = 'b0000000-0000-4000-8000-000000000001'
  AND position = 0;

-- Semilla local. La contraseña de las cuatro cuentas es DevPassword!234
-- y el hash es Argon2id. No usar estas credenciales fuera de desarrollo.

INSERT INTO users (id, email, password_hash, display_name, role, profile_visibility, bio)
VALUES
  (
    'a0000000-0000-4000-8000-000000000001',
    'admin@artauction.local',
    '$argon2id$v=19$m=19456,p=1,t=2$mxTU3PdFuf40kJYM6D8dRw$hznV7Iomd2muNGDNRtJ/UldOILr7eNGYbiifSHZCegg',
    'Ada Admin',
    'ADMIN',
    'PUBLIC',
    'Revisa los lotes que la auditoría marca para revisión manual.'
  ),
  (
    'a0000000-0000-4000-8000-000000000002',
    'seller@artauction.local',
    '$argon2id$v=19$m=19456,p=1,t=2$mxTU3PdFuf40kJYM6D8dRw$hznV7Iomd2muNGDNRtJ/UldOILr7eNGYbiifSHZCegg',
    'Marta Vendedora',
    'SELLER',
    'PUBLIC',
    'Publica obra moderna y antigüedades con ficha técnica.'
  ),
  (
    'a0000000-0000-4000-8000-000000000003',
    'leo@artauction.local',
    '$argon2id$v=19$m=19456,p=1,t=2$mxTU3PdFuf40kJYM6D8dRw$hznV7Iomd2muNGDNRtJ/UldOILr7eNGYbiifSHZCegg',
    'Leo Postor',
    'USER',
    'PUBLIC',
    'Sigue salas en vivo y guarda lo que gana.'
  ),
  (
    'a0000000-0000-4000-8000-000000000004',
    'nora@artauction.local',
    '$argon2id$v=19$m=19456,p=1,t=2$mxTU3PdFuf40kJYM6D8dRw$hznV7Iomd2muNGDNRtJ/UldOILr7eNGYbiifSHZCegg',
    'Nora Coleccionista',
    'USER',
    'PRIVATE',
    'Perfil privado: su galería no aparece en el catálogo público.'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO follows (follower_id, followee_id)
VALUES
  ('a0000000-0000-4000-8000-000000000003', 'a0000000-0000-4000-8000-000000000002'),
  ('a0000000-0000-4000-8000-000000000004', 'a0000000-0000-4000-8000-000000000002')
ON CONFLICT DO NOTHING;

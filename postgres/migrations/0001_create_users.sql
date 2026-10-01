-- Cuentas autenticadas. El visitante no tiene fila.

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  display_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'USER',
  profile_visibility TEXT NOT NULL DEFAULT 'PUBLIC',
  bio TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT users_email_key UNIQUE (email),
  CONSTRAINT users_role_check CHECK (role IN ('USER', 'SELLER', 'ADMIN')),
  CONSTRAINT users_profile_visibility_check CHECK (profile_visibility IN ('PUBLIC', 'PRIVATE')),
  CONSTRAINT users_email_lowercase_check CHECK (email = lower(email)),
  CONSTRAINT users_email_format_check CHECK (position('@' IN email) > 1),
  CONSTRAINT users_display_name_check CHECK (char_length(btrim(display_name)) >= 2)
);

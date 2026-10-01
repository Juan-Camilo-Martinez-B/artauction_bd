-- Grafo social. La prohibición de seguirse a uno mismo llega con las restricciones de negocio.

CREATE TABLE follows (
  follower_id UUID NOT NULL,
  followee_id UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT follows_pkey PRIMARY KEY (follower_id, followee_id),
  CONSTRAINT follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT follows_followee_id_fkey FOREIGN KEY (followee_id) REFERENCES users (id) ON DELETE CASCADE
);

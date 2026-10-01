/** UUID canónico, el mismo tipo que usa Postgres. */
export const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export const uuidField = {
  type: String,
  required: true,
  match: UUID_PATTERN,
};

export const optionalUuidField = {
  type: String,
  required: false,
  match: UUID_PATTERN,
};

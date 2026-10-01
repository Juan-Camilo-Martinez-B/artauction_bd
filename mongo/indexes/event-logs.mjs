const NINETY_DAYS_SECONDS = 90 * 24 * 60 * 60;

/**
 * event_logs conserva 90 días. Atlas M0 tiene cuota de almacenamiento y esta
 * colección es la que más crece.
 */
export const eventLogIndexSpecs = [
  {
    key: { correlationId: 1 },
    name: 'event_logs_correlation_id',
  },
  {
    key: { name: 1, occurredAt: -1 },
    name: 'event_logs_name_occurred_at',
  },
  {
    key: { occurredAt: 1 },
    name: 'event_logs_ttl',
    expireAfterSeconds: NINETY_DAYS_SECONDS,
  },
];

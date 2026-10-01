/** Índices del feed: actividad de un actor y muro de piezas públicas. */
export const activityFeedIndexSpecs = [
  {
    key: { actorId: 1, createdAt: -1 },
    name: 'activity_feed_actor_created',
  },
  {
    key: { visibility: 1, createdAt: -1 },
    name: 'activity_feed_visibility_created',
  },
];

/**
 * Índices de gallery_items.
 * La unicidad por dueño y lote no aplica a piezas gratuitas sin lotId.
 * El índice parcial público alimenta la galería ISR.
 */
export const galleryItemIndexSpecs = [
  {
    key: { ownerId: 1, acquiredAt: -1 },
    name: 'gallery_items_owner_acquired',
  },
  {
    key: { ownerId: 1, lotId: 1 },
    name: 'gallery_items_owner_lot',
    unique: true,
    partialFilterExpression: { lotId: { $type: 'string' } },
  },
  {
    key: { ownerId: 1, acquiredAt: -1 },
    name: 'gallery_items_public_owner',
    partialFilterExpression: { visibility: 'PUBLIC' },
  },
];

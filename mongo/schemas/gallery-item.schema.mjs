import mongoose from 'mongoose';
import { optionalUuidField, uuidField } from './patterns.mjs';

const GalleryItemSchema = new mongoose.Schema(
  {
    ownerId: uuidField,
    lotId: optionalUuidField,
    source: { type: String, required: true, enum: ['PROPIA', 'GANADA', 'GRATUITA'] },
    visibility: { type: String, required: true, enum: ['PUBLIC', 'PRIVATE'], default: 'PRIVATE' },
    title: { type: String, required: true, trim: true },
    artistName: { type: String, trim: true },
    imageKeys: { type: [String], default: [] },
    acquiredAt: { type: Date, required: true },
  },
  { collection: 'gallery_items', versionKey: false },
);

export const GalleryItem =
  mongoose.models.GalleryItem ?? mongoose.model('GalleryItem', GalleryItemSchema);

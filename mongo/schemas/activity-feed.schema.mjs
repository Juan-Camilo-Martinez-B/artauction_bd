import mongoose from 'mongoose';
import { uuidField } from './patterns.mjs';

const ActivitySchema = new mongoose.Schema(
  {
    actorId: uuidField,
    verb: { type: String, required: true, enum: ['PUBLISH', 'BID', 'WIN', 'FOLLOW', 'AUDIT'] },
    objectType: { type: String, required: true, enum: ['LOT', 'AUCTION', 'USER', 'AUDIT'] },
    objectId: uuidField,
    visibility: { type: String, required: true, enum: ['PUBLIC', 'PRIVATE'] },
    summary: { type: String, required: true, trim: true },
    createdAt: { type: Date, required: true, default: () => new Date() },
  },
  { collection: 'activity_feed', versionKey: false },
);

export const Activity =
  mongoose.models.Activity ?? mongoose.model('Activity', ActivitySchema);

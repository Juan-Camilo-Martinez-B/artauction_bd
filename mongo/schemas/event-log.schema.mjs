import mongoose from 'mongoose';

const EventLogSchema = new mongoose.Schema(
  {
    source: { type: String, required: true, enum: ['http', 'ws', 'worker', 'scheduler'] },
    name: { type: String, required: true, trim: true },
    correlationId: { type: String, required: true, trim: true },
    payload: { type: mongoose.Schema.Types.Mixed, default: {} },
    occurredAt: { type: Date, required: true },
  },
  { collection: 'event_logs', versionKey: false },
);

export const EventLog = mongoose.models.EventLog ?? mongoose.model('EventLog', EventLogSchema);

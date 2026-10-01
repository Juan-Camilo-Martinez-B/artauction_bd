import mongoose from 'mongoose';
import { uuidField } from './patterns.mjs';

const FindingSchema = new mongoose.Schema(
  {
    code: { type: String, required: true, trim: true },
    severity: { type: String, required: true, enum: ['INFO', 'WARNING', 'CRITICAL'] },
    message: { type: String, required: true, trim: true },
  },
  { _id: false },
);

const AuditInputSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    description: { type: String, required: true },
    materials: { type: String, required: true, trim: true },
    creationYear: { type: Number, min: 1, max: 2100 },
    imageHashes: { type: [String], default: [] },
  },
  { _id: false },
);

const AuditReportSchema = new mongoose.Schema(
  {
    lotId: uuidField,
    summaryId: uuidField,
    model: { type: String, required: true, trim: true },
    promptVersion: { type: String, required: true, trim: true },
    input: { type: AuditInputSchema, required: true },
    findings: { type: [FindingSchema], default: [] },
    authenticityScore: { type: Number, required: true, min: 0, max: 100 },
    suggestedPriceMin: { type: Number, required: true, min: 0 },
    suggestedPriceMax: { type: Number, required: true, min: 0 },
    createdAt: { type: Date, required: true, default: () => new Date() },
  },
  { collection: 'audit_reports', versionKey: false },
);

AuditReportSchema.pre('validate', function rejectInvertedPrice(next) {
  if (this.suggestedPriceMax < this.suggestedPriceMin) {
    next(new Error('suggestedPriceMax must be greater than or equal to suggestedPriceMin'));
    return;
  }
  next();
});

export const AuditReport =
  mongoose.models.AuditReport ?? mongoose.model('AuditReport', AuditReportSchema);

-- Resumen relacional de una auditoría. El informe completo vive en Mongo (audit_reports)
-- y se referencia por mongo_report_id. Un lote puede acumular varios resumenes.

CREATE TABLE audit_summaries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lot_id UUID NOT NULL,
  score SMALLINT NOT NULL,
  price_min NUMERIC(12, 2) NOT NULL,
  price_max NUMERIC(12, 2) NOT NULL,
  verdict TEXT NOT NULL,
  has_critical_inconsistency BOOLEAN NOT NULL DEFAULT false,
  mongo_report_id TEXT NOT NULL,
  model_name TEXT NOT NULL,
  prompt_version TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT audit_summaries_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES lots (id) ON DELETE RESTRICT,
  CONSTRAINT audit_summaries_verdict_check CHECK (verdict IN ('APROBADO', 'REVISION_MANUAL')),
  CONSTRAINT audit_summaries_mongo_report_id_check CHECK (char_length(btrim(mongo_report_id)) > 0),
  CONSTRAINT audit_summaries_model_name_check CHECK (char_length(btrim(model_name)) > 0),
  CONSTRAINT audit_summaries_prompt_version_check CHECK (char_length(btrim(prompt_version)) > 0)
);

-- Expand para audit-service.
--
-- 1. Cola de auditorias en una tabla propia. Cada LotSubmitted crea una
--    solicitud en la misma transaccion que su inbox, asi una auditoria nunca se
--    pierde ni se duplica. Un worker la toma con FOR UPDATE SKIP LOCKED y un
--    lease; si falla, reintenta con backoff hasta agotar los intentos.
-- 2. Cache de evaluaciones de la IA por huella del expediente de evidencias:
--    reauditar una obra sin cambios no vuelve a gastar tokens.
-- 3. El resumen registra quien decidio (reglas, IA o respaldo) y la huella.

CREATE TABLE audit.audit_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lot_id UUID NOT NULL,
  source_event_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDIENTE',
  attempts INTEGER NOT NULL DEFAULT 0,
  available_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  lease_until TIMESTAMPTZ,
  last_error TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  CONSTRAINT audit_requests_status_check CHECK (status IN ('PENDIENTE', 'COMPLETADA', 'FALLIDA')),
  CONSTRAINT audit_requests_attempts_check CHECK (attempts >= 0),
  CONSTRAINT audit_requests_source_event_id_key UNIQUE (source_event_id)
);

-- Una sola auditoria pendiente por obra.
CREATE UNIQUE INDEX audit_requests_pending_lot_uidx
  ON audit.audit_requests (lot_id)
  WHERE status = 'PENDIENTE';

-- El worker solo recorre las pendientes, por orden de disponibilidad.
CREATE INDEX audit_requests_due_idx
  ON audit.audit_requests (available_at)
  WHERE status = 'PENDIENTE';

CREATE TABLE audit.ai_assessments (
  dossier_hash TEXT NOT NULL,
  model_name TEXT NOT NULL,
  prompt_version TEXT NOT NULL,
  result JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (dossier_hash, model_name, prompt_version),
  CONSTRAINT ai_assessments_dossier_hash_check CHECK (dossier_hash ~ '^[0-9a-f]{64}$')
);

ALTER TABLE audit.audit_summaries
  ADD COLUMN decided_by TEXT,
  ADD COLUMN dossier_hash TEXT;

ALTER TABLE audit.audit_summaries
  ADD CONSTRAINT audit_summaries_decided_by_check
    CHECK (decided_by IS NULL OR decided_by IN ('RULES', 'AI', 'FALLBACK')),
  ADD CONSTRAINT audit_summaries_dossier_hash_check
    CHECK (dossier_hash IS NULL OR dossier_hash ~ '^[0-9a-f]{64}$');

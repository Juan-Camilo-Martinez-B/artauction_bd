-- Ciclo de revision manual (F12).
--
-- 1. Historial de decisiones del administrador sobre cada obra. Devolver a
--    borrador exige un motivo, que el vendedor ve para corregir la obra; aprobar
--    puede fijar el rango de precio cuando la auditoria no lo estimo; REAUDIT
--    vuelve a pedir la auditoria (por ejemplo, cuando Gemini vuelve a responder).
CREATE TABLE catalog.lot_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lot_id UUID NOT NULL REFERENCES catalog.lots (id) ON DELETE CASCADE,
  admin_id UUID NOT NULL,
  decision TEXT NOT NULL,
  reason TEXT,
  price_min NUMERIC(12, 2),
  price_max NUMERIC(12, 2),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT lot_reviews_decision_check CHECK (decision IN ('APPROVE', 'RETURN_TO_DRAFT', 'REAUDIT')),
  CONSTRAINT lot_reviews_reason_check CHECK (reason IS NULL OR char_length(btrim(reason)) BETWEEN 10 AND 500),
  CONSTRAINT lot_reviews_return_reason_check CHECK (decision <> 'RETURN_TO_DRAFT' OR reason IS NOT NULL),
  CONSTRAINT lot_reviews_price_check CHECK (
    (price_min IS NULL AND price_max IS NULL)
    OR (price_min > 0 AND price_max >= price_min)
  )
);

-- La ultima decision de una obra (motivo de la devolucion) y el historial por obra.
CREATE INDEX lot_reviews_lot_created_idx ON catalog.lot_reviews (lot_id, created_at DESC);

-- 2. Auditorias evaluadas en local: cuando Gemini no responde (cuota agotada o
--    servicio caido), ai-service usa la evaluacion local y la auditoria queda
--    marcada como LOCAL, distinta de una decision de la IA.
ALTER TABLE audit.audit_summaries
  DROP CONSTRAINT audit_summaries_decided_by_check,
  ADD CONSTRAINT audit_summaries_decided_by_check
    CHECK (decided_by IS NULL OR decided_by IN ('RULES', 'AI', 'LOCAL', 'FALLBACK'));

ALTER TABLE audit.reports
  DROP CONSTRAINT reports_decided_by_check,
  ADD CONSTRAINT reports_decided_by_check CHECK (decided_by IN ('RULES', 'AI', 'LOCAL', 'FALLBACK'));

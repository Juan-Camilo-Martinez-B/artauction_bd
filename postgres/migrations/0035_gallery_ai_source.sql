-- El diseno de una sala generado por IA se marcaba con source = "gemini", el
-- nombre del proveedor. Desde F17 la IA la da Groq y el origen pasa a ser el
-- valor neutro "ai", que no cambia si cambia el proveedor. Se actualizan las
-- configuraciones guardadas (propuesta y aplicada) para que gallery-service
-- solo conozca un nombre.
UPDATE gallery.personal_galleries
SET suggested_config = jsonb_set(suggested_config, '{source}', '"ai"')
WHERE suggested_config->>'source' = 'gemini';

UPDATE gallery.personal_galleries
SET applied_config = jsonb_set(applied_config, '{source}', '"ai"')
WHERE applied_config->>'source' = 'gemini';

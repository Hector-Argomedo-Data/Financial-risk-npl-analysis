-- ==============================================================================
-- MÓDULO: Ingesta y Consolidación Histórica (ELT)
-- DESCRIPCIÓN: Unificación de 24 tablas mensuales (Jun 2025 - May 2026)
--              en 2 entidades maestras mediante CTAS y UNION ALL.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. ENTIDAD: ACTIVOS HISTÓRICO
-- ------------------------------------------------------------------------------
CREATE OR REPLACE TABLE `proyecto01-486204.cmf_riesgo_2026.activos_historico` AS
SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_06`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_07`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_08`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_09`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_10`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_11`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2025_12`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2026_01`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2026_02`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2026_03`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2026_04`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Activos_2026_05`;

-- ------------------------------------------------------------------------------
-- 2. ENTIDAD: COLOCACIONES HISTÓRICO
-- ------------------------------------------------------------------------------
CREATE OR REPLACE TABLE `proyecto01-486204.cmf_riesgo_2026.colocaciones_historico` AS
SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_06`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_07`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_08`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_09`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_10`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_11`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2025_12`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2026_01`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2026_02`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2026_03`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2026_04`
UNION ALL SELECT * FROM `proyecto01-486204.cmf_riesgo_2026.Colocaciones_2026_05`;



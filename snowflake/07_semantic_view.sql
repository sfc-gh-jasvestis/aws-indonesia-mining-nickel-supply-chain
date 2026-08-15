-- ============================================================================
-- 07_SEMANTIC_VIEW.SQL — Semantic View for Nickel Supply Chain Visibility
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA APP;

CREATE OR REPLACE SEMANTIC VIEW APP.NICKEL_SUPPLY_CHAIN_ANALYTICS
  COMMENT = 'Nickel supply chain, processing, delivery compliance, and material flow analytics'
AS
  TABLES (
    CURATED.MATERIAL_BALANCE AS material_balance,CURATED.PLANT_PERFORMANCE AS plant_performance,CURATED.DELIVERY_COMPLIANCE AS delivery_compliance,CURATED.GRADE_ANALYTICS AS grade_analytics
  );

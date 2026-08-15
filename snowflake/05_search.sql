-- ============================================================================
-- 05_SEARCH.SQL — Cortex Search for Nickel Supply Chain Visibility
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA SEARCH;

CREATE OR REPLACE CORTEX SEARCH SERVICE SEARCH.SUPPLY_CHAIN_DOCS_SEARCH
  ON CONTENT
  ATTRIBUTES DOC_TYPE, BUYER, PLANT_ID
  WAREHOUSE = NICKEL_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT * FROM RAW.SUPPLY_CHAIN_DOCS
);

-- ============================================================================
-- 04_DYNAMIC_TABLES.SQL — Curated layer for Nickel Supply Chain Visibility
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA CURATED;

-- MATERIAL_BALANCE: Real-time mine-to-product material balance with yield and loss tracking
-- Source: MATERIAL_FLOW, PRODUCTION_LOGS, MINES
CREATE OR REPLACE DYNAMIC TABLE CURATED.MATERIAL_BALANCE
  TARGET_LAG = '5 minutes'
  WAREHOUSE = NICKEL_WH
AS
SELECT * FROM RAW.MATERIAL_FLOW;
-- TODO: Replace with actual join/aggregation logic per demo

-- PLANT_PERFORMANCE: Processing plant output vs capacity with bottleneck identification
-- Source: PROCESSING_PLANTS, PRODUCTION_LOGS
CREATE OR REPLACE DYNAMIC TABLE CURATED.PLANT_PERFORMANCE
  TARGET_LAG = '5 minutes'
  WAREHOUSE = NICKEL_WH
AS
SELECT * FROM RAW.PROCESSING_PLANTS;
-- TODO: Replace with actual join/aggregation logic per demo

-- DELIVERY_COMPLIANCE: Buyer contract delivery tracking with variance and risk flags
-- Source: BUYER_CONTRACTS, PRODUCTION_LOGS, MATERIAL_FLOW
CREATE OR REPLACE DYNAMIC TABLE CURATED.DELIVERY_COMPLIANCE
  TARGET_LAG = '5 minutes'
  WAREHOUSE = NICKEL_WH
AS
SELECT * FROM RAW.BUYER_CONTRACTS;
-- TODO: Replace with actual join/aggregation logic per demo

-- GRADE_ANALYTICS: Ore and product grade distribution and variance analysis
-- Source: MINES, MATERIAL_FLOW, PRODUCTION_LOGS
CREATE OR REPLACE DYNAMIC TABLE CURATED.GRADE_ANALYTICS
  TARGET_LAG = '5 minutes'
  WAREHOUSE = NICKEL_WH
AS
SELECT * FROM RAW.MINES;
-- TODO: Replace with actual join/aggregation logic per demo


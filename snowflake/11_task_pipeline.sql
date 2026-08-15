-- ============================================================================
-- 11_TASK_PIPELINE.SQL — Task DAG for Nickel Supply Chain Visibility
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA APP;

CREATE OR REPLACE TASK APP.TASK_INGEST_PRODUCTION
  WAREHOUSE = NICKEL_WH
  SCHEDULE = 'USING CRON 0 */4 * * * UTC'
  COMMENT = 'Ingest latest production logs from all processing plants'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_FORECAST_OUTPUT
  WAREHOUSE = NICKEL_WH
  AFTER APP.TASK_INGEST_PRODUCTION
  COMMENT = 'Run ML.FORECAST on plant production output'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_REFRESH_ICEBERG
  WAREHOUSE = NICKEL_WH
  AFTER APP.TASK_FORECAST_OUTPUT
  COMMENT = 'Refresh Iceberg tables for buyer Athena access'
AS
  SELECT 1; -- Replace with actual refresh logic

ALTER TASK APP.TASK_REFRESH_ICEBERG RESUME;
ALTER TASK APP.TASK_FORECAST_OUTPUT RESUME;
ALTER TASK APP.TASK_INGEST_PRODUCTION RESUME;

-- ============================================================================
-- Nickel Supply Chain Visibility
-- End-to-end nickel supply chain tracking from mine to battery-grade product for Indonesia's US$33B nickel industry — Dynamic Tables build material flow graphs, Iceberg enables buyer traceability via Athena.
-- ============================================================================
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS NICKEL_SUPPLY_CHAIN;
CREATE WAREHOUSE IF NOT EXISTS NICKEL_WH WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE;
USE DATABASE NICKEL_SUPPLY_CHAIN;
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CURATED;
CREATE SCHEMA IF NOT EXISTS ML;
CREATE SCHEMA IF NOT EXISTS AI;
CREATE SCHEMA IF NOT EXISTS SEARCH;
CREATE SCHEMA IF NOT EXISTS APP;

USE WAREHOUSE NICKEL_WH;

-- ============================================================================
-- 03_STAGING.SQL — Generate synthetic data for Nickel Supply Chain Visibility
-- Country: INDONESIA | Currency: IDR
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA RAW;

-- Data generation scripts are demo-specific.
-- See the handcrafted SQL in the aws-malaysia-semiconductor-yield demo for
-- the full pattern: GENERATOR + UNIFORM + LATERAL for distribution,
-- Cortex Complete for text generation, engineered key demo numbers.

-- Target row counts:
-- MINES: 40 rows — Active nickel mines across Sulawesi and Maluku with ore grade profiles
-- PROCESSING_PLANTS: 12 rows — RKEF, HPAL, and smelter plants with capacity and throughput data
-- MATERIAL_FLOW: 80,000 rows — Ore-to-product material movements with grade tracking
-- PRODUCTION_LOGS: 150,000 rows — Daily production output by plant, line, and product grade
-- BUYER_CONTRACTS: 200 rows — Long-term supply agreements with EV OEMs and stainless steel producers
-- SUPPLY_CHAIN_DOCS: 150 rows — Contracts, SMEL certificates, export permits, and ESG audit reports

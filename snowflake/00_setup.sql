-- Generated from generator/demo_specs/aws-indonesia-mining-nickel-supply-chain.json
-- Regenerate with: python3 generator/gen_repo_docs.py aws-indonesia-mining-nickel-supply-chain
-- This is the schema that is actually deployed for ID_MINING_NICKEL_SUPPLY_CHAIN.

-- ID_MINING_NICKEL_SUPPLY_CHAIN  (Nickel Supply Chain Visibility)
-- generated from generator/demo_specs/aws-indonesia-mining-nickel-supply-chain.json - do not hand-edit
CREATE DATABASE IF NOT EXISTS ID_MINING_NICKEL_SUPPLY_CHAIN;
CREATE SCHEMA IF NOT EXISTS ID_MINING_NICKEL_SUPPLY_CHAIN.RAW;
CREATE SCHEMA IF NOT EXISTS ID_MINING_NICKEL_SUPPLY_CHAIN.CURATED;
CREATE SCHEMA IF NOT EXISTS ID_MINING_NICKEL_SUPPLY_CHAIN.APP;
USE DATABASE ID_MINING_NICKEL_SUPPLY_CHAIN;

-- 5 real regions; entity names carry their region so the two always agree

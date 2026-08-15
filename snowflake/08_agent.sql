-- ============================================================================
-- 08_AGENT.SQL — Cortex Agent for Nickel Supply Chain Visibility
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA APP;

CREATE OR REPLACE CORTEX AGENT APP.NICKEL_SUPPLY_CHAIN_AGENT
  COMMENT = 'Nickel Supply Chain Visibility AI Assistant'
  MODEL = 'claude-opus-4-8'
  TOOLS = (
    SEMANTIC_VIEW_TOOL(SEMANTIC_VIEW => 'NICKEL_SUPPLY_CHAIN.APP.NICKEL_SUPPLY_CHAIN_ANALYTICS'),    CORTEX_SEARCH_TOOL(CORTEX_SEARCH_SERVICE => 'NICKEL_SUPPLY_CHAIN.SEARCH.SUPPLY_CHAIN_DOCS_SEARCH', TOOL_DESCRIPTION => 'Search documents for Mining & Nickel Processing information')
  )
  SYSTEM_PROMPT = 'You are the Nickel Supply Chain Agent for Indonesia''s integrated nickel processing operation, tracking material flow from 40 mines through 12 processing plants to battery-grade product delivery.';

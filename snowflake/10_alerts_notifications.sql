-- ============================================================================
-- 10_ALERTS_NOTIFICATIONS.SQL — Alerts for Nickel Supply Chain Visibility
-- ============================================================================
USE DATABASE NICKEL_SUPPLY_CHAIN;
USE SCHEMA APP;

-- Notification integration (email)
CREATE OR REPLACE NOTIFICATION INTEGRATION aws_indonesia_mining_nickel_supply_chain_EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('<YOUR_EMAIL>');

-- Alert: DELIVERY_RISK_ALERT
CREATE OR REPLACE ALERT APP.DELIVERY_RISK_ALERT
  WAREHOUSE = NICKEL_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Buyer delivery commitment at risk — production shortfall projected'
IF (EXISTS (
  SELECT 1 FROM CURATED.MATERIAL_BALANCE
  WHERE 1=1 -- Condition: Projected delivery shortfall > 5% vs buyer contract commitment
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_indonesia_mining_nickel_supply_chain_EMAIL_INT',
    '<YOUR_EMAIL>',
    '[ALERT] Nickel Supply Chain Visibility: Buyer delivery commitment at risk — production shortfall projected',
    'Buyer delivery commitment at risk — production shortfall projected'
  );

ALTER ALERT APP.DELIVERY_RISK_ALERT RESUME;

-- Alert: GRADE_DEVIATION_ALERT
CREATE OR REPLACE ALERT APP.GRADE_DEVIATION_ALERT
  WAREHOUSE = NICKEL_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Product grade deviation exceeds buyer specification tolerance'
IF (EXISTS (
  SELECT 1 FROM CURATED.MATERIAL_BALANCE
  WHERE 1=1 -- Condition: Product grade deviation > 2% from specification
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_indonesia_mining_nickel_supply_chain_EMAIL_INT',
    '<YOUR_EMAIL>',
    '[ALERT] Nickel Supply Chain Visibility: Product grade deviation exceeds buyer specification tolerance',
    'Product grade deviation exceeds buyer specification tolerance'
  );

ALTER ALERT APP.GRADE_DEVIATION_ALERT RESUME;


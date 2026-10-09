-- Synthetic site-day observations for a fictional Indonesian nickel supply chain. Nothing is
-- seeded as a prediction. Randomness is HASH-seeded, so every rebuild is
-- reproducible: per-site capacity, equipment age and disruption propensity, load from
-- weekly seasonality and a vessel loading campaign, wear between preventive-maintenance
-- (PM) visits, category-weighted disruption causes, and two regional events.
USE DATABASE IDENTIFIER($DEMO_DB);
USE SCHEMA RAW;
USE WAREHOUSE IDENTIFIER($DEMO_WH);

CREATE TABLE RAW.SITES AS
WITH sites AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS SITE_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 30))
), draws AS (
  SELECT SITE_INDEX,
         MOD(ABS(HASH(SITE_INDEX, 'age')), 1000000) / 1e6 AS U_AGE,
         MOD(ABS(HASH(SITE_INDEX, 'rate')), 1000000) / 1e6 AS U_RATE,
         MOD(ABS(HASH(SITE_INDEX, 'pm')), 1000000) / 1e6 AS U_PM,
         MOD(ABS(HASH(SITE_INDEX, 'discipline')), 1000000) / 1e6 AS U_DISCIPLINE,
         MOD(ABS(HASH(SITE_INDEX, 'capacity')), 1000000) / 1e6 AS U_CAPACITY
  FROM sites
)
SELECT 'NS-' || LPAD(SITE_INDEX::VARCHAR, 4, '0') AS ID,
       'Synthetic site ' || LPAD(SITE_INDEX::VARCHAR, 4, '0') AS NAME,
       -- Deterministic spread (7 and 5 are coprime): every region and site type is
       -- present, with Morowali the largest region.
       CASE MOD(SITE_INDEX, 7) WHEN 0 THEN 'Morowali' WHEN 1 THEN 'Morowali' WHEN 2 THEN 'Konawe'
            WHEN 3 THEN 'Kolaka' WHEN 4 THEN 'Halmahera' WHEN 5 THEN 'Obi'
            ELSE 'Luwu Timur' END AS REGION,
       CASE MOD(SITE_INDEX, 5) WHEN 0 THEN 'Mine Pit' WHEN 1 THEN 'ROM Stockpile'
            WHEN 2 THEN 'Barge Jetty' WHEN 3 THEN 'Haul Road' ELSE 'Smelter Feed Yard' END AS CATEGORY,
       SITE_INDEX,
       ROUND(1 + U_AGE * 9, 1) AS AGE_YEARS,
       -- Base daily disruption probability 0.5%-3.5%; ~15% of sites are chronic (x3).
       (0.005 + U_RATE * 0.03) * IFF(U_RATE > 0.85, 3, 1) AS BASE_DISRUPTION_RATE,
       7 * (1 + FLOOR(U_PM * 3)) AS PM_INTERVAL_DAYS,
       0.55 + U_DISCIPLINE * 0.45 AS PM_COMPLETION_PROB,
       ROUND(CASE MOD(SITE_INDEX, 5) WHEN 0 THEN 12000 WHEN 1 THEN 9000 WHEN 2 THEN 10000
                  WHEN 3 THEN 8000 ELSE 6000 END * (0.8 + U_CAPACITY * 0.4)) AS DAILY_CAPACITY,
       'Active' AS STATUS
FROM draws;

CREATE TABLE RAW.SITE_DAILY AS
WITH days AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS DAY_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 90))
), regional_events AS (
  -- Two region-wide events in the window.
  SELECT * FROM VALUES (27, 'Morowali', 'Heavy rain haul road closure', 6.0),
                       (64, 'Halmahera', 'Barge suspension (weather)', 9.0)
    AS o(DAY_INDEX, REGION, EVENT_CAUSE, HOURS)
), base AS (
  SELECT h.ID AS ENTITY_ID, h.SITE_INDEX, h.CATEGORY, h.REGION, h.AGE_YEARS,
         h.BASE_DISRUPTION_RATE, h.PM_INTERVAL_DAYS, h.PM_COMPLETION_PROB, h.DAILY_CAPACITY,
         d.DAY_INDEX,
         DATEADD('day', d.DAY_INDEX - 89, CURRENT_DATE()) AS EVENT_DATE,
         24.0 AS PLANNED_HOURS,
         MOD(d.DAY_INDEX + h.SITE_INDEX * 5, h.PM_INTERVAL_DAYS) AS DAYS_SINCE_PM,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'dis')), 1000000) / 1e6 AS U_DIS,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'down')), 1000000) / 1e6 + 1e-6 AS U_DOWN,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'cause')), 1000000) / 1e6 AS U_CAUSE,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'pmdone')), 1000000) / 1e6 AS U_PMDONE,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'volume')), 1000000) / 1e6 AS U_VOLUME,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'noise')), 1000000) / 1e6 AS U_NOISE,
         MOD(ABS(HASH(h.ID, d.DAY_INDEX, 'hit')), 1000000) / 1e6 AS U_HIT,
         e.EVENT_CAUSE, e.HOURS AS EVENT_HOURS
  FROM RAW.SITES h CROSS JOIN days d
  LEFT JOIN regional_events e ON e.DAY_INDEX = d.DAY_INDEX AND e.REGION = h.REGION
), loaded AS (
  SELECT *,
         IFF(DAYS_SINCE_PM = 0, 1, 0) AS PM_DUE,
         IFF(DAYS_SINCE_PM = 0 AND U_PMDONE < PM_COMPLETION_PROB, 1, 0) AS PM_COMPLETED,
         -- Equipment and fleet wear rise between PM visits; weak PM discipline carries wear over.
         DAYS_SINCE_PM / PM_INTERVAL_DAYS + (1 - PM_COMPLETION_PROB) AS WEAR,
         -- Backlog stress episode: 9 of every 28 days per site (staggered), e.g. a wet-season spell.
         IFF(MOD(DAY_INDEX + SITE_INDEX * 11, 28) < 9, 1, 0) AS STRESS,
         -- Volume: weekly low day and a vessel loading campaign on day 45 (+60%) easing over 3 days.
         ROUND(DAILY_CAPACITY * (0.70 + 0.25 * U_VOLUME)
               * IFF(MOD(DAY_INDEX, 7) = 6, 0.75, 1.0)
               * CASE DAY_INDEX - 45 WHEN 0 THEN 1.6 WHEN 1 THEN 1.4 WHEN 2 THEN 1.2 ELSE 1.0 END) AS ORE_TONNES
  FROM base
), disruptions AS (
  SELECT *, ORE_TONNES / DAILY_CAPACITY AS LOAD_RATIO,
         LEAST(0.5, BASE_DISRUPTION_RATE * (0.4 + 1.6 * WEAR) * (0.3 + ORE_TONNES / DAILY_CAPACITY)
                    * (1 + AGE_YEARS / 20) * (1 + 2.5 * STRESS)) AS P_DIS
  FROM loaded
), counted AS (
  SELECT *,
         CASE WHEN EVENT_HOURS IS NOT NULL THEN 1
              WHEN U_DIS < P_DIS / 4 THEN 2
              WHEN U_DIS < P_DIS THEN 1
              ELSE 0 END AS DISRUPTION_COUNT
  FROM disruptions
), timed AS (
  SELECT *,
         -- Equipment or loading downtime: exponential, mean depends on site type.
         CASE WHEN DISRUPTION_COUNT = 0 THEN 0.0
              WHEN EVENT_HOURS IS NOT NULL THEN EVENT_HOURS
              ELSE LEAST(20.0, ROUND(DISRUPTION_COUNT * (0.5 - LN(U_DOWN) *
                   CASE CATEGORY WHEN 'Mine Pit' THEN 3.0 WHEN 'ROM Stockpile' THEN 2.0
                                 WHEN 'Barge Jetty' THEN 4.0 WHEN 'Haul Road' THEN 2.5 ELSE 3.5 END), 1))
         END AS DOWNTIME_HOURS,
         -- On-spec rate (ore within the Ni grade and moisture target): base by site type, minus wear and overload, minus the disruption hit.
         LEAST(0.995, GREATEST(0.50,
           CASE CATEGORY WHEN 'Mine Pit' THEN 0.955 WHEN 'ROM Stockpile' THEN 0.940
                         WHEN 'Barge Jetty' THEN 0.925 WHEN 'Haul Road' THEN 0.960 ELSE 0.950 END
           - 0.025 * WEAR - 0.04 * GREATEST(0, LOAD_RATIO - 0.9) - 0.006 * U_NOISE
           - DISRUPTION_COUNT * (0.08 + 0.12 * U_HIT))) AS ON_SPEC_RATE
  FROM counted
)
SELECT ENTITY_ID || '-' || TO_CHAR(EVENT_DATE, 'YYYYMMDD') AS EVENT_ID,
       ENTITY_ID, EVENT_DATE, PLANNED_HOURS, DOWNTIME_HOURS,
       PLANNED_HOURS - DOWNTIME_HOURS AS OPERATING_HOURS,
       DISRUPTION_COUNT,
       CASE WHEN DISRUPTION_COUNT = 0 THEN 'None'
            WHEN EVENT_CAUSE IS NOT NULL THEN EVENT_CAUSE
            WHEN CATEGORY = 'Mine Pit' THEN IFF(U_CAUSE < 0.5, 'Excavator breakdown', IFF(U_CAUSE < 0.8, 'Pit flooding (rain)', 'Blending off target'))
            WHEN CATEGORY = 'ROM Stockpile' THEN IFF(U_CAUSE < 0.45, 'Ore moisture high', IFF(U_CAUSE < 0.75, 'Stacker fault', 'Grade mix-up'))
            WHEN CATEGORY = 'Barge Jetty' THEN IFF(U_CAUSE < 0.6, 'Barge delay', 'Tide window missed')
            WHEN CATEGORY = 'Haul Road' THEN IFF(U_CAUSE < 0.55, 'Haul truck breakdown', 'Road washout')
            ELSE IFF(U_CAUSE < 0.6, 'Feed grade off spec', 'Weighbridge outage') END AS ROOT_CAUSE,
       PM_DUE, PM_COMPLETED,
       ORE_TONNES,
       FLOOR(ORE_TONNES * ON_SPEC_RATE) AS ON_SPEC_TONNES,
       ROUND(ORE_TONNES / (25 + U_VOLUME * 10)) AS HAUL_TRIPS,
       ROUND(ORE_TONNES / (25 + U_VOLUME * 10) * (0.010 + 0.008 * WEAR + 0.025 * DISRUPTION_COUNT + 0.004 * U_NOISE)) AS REJECTED_LOADS,
       ROUND(3.0 + 2.5 * WEAR + 3.0 * GREATEST(0, LOAD_RATIO - 0.8) + 1.8 * STRESS + 3.5 * DISRUPTION_COUNT + U_NOISE * 0.8, 2) AS DWELL_HOURS,
       ROUND(LEAST(100, 100 * LOAD_RATIO * (0.85 + 0.1 * U_NOISE) + 7 * STRESS + 4 * DISRUPTION_COUNT), 1) AS EQUIPMENT_LOAD_PCT,
       ROUND(1.35 + 0.55 * ON_SPEC_RATE + 0.06 * U_NOISE, 2) AS NI_GRADE_PCT,
       CURRENT_TIMESTAMP() AS LOADED_AT
FROM timed;

-- Fleet readiness per site (snapshot): excavators, loaders, trucks or barges required versus available.
CREATE TABLE RAW.FLEET_READINESS AS
SELECT ID AS ENTITY_ID,
       CASE CATEGORY WHEN 'Mine Pit' THEN 'Excavator' WHEN 'ROM Stockpile' THEN 'Front loader'
                     WHEN 'Barge Jetty' THEN 'Barge' WHEN 'Haul Road' THEN 'Haul truck'
                     ELSE 'Dump truck' END AS FLEET_TYPE,
       10 + MOD(ABS(HASH(ID, 'req')), 31) AS REQUIRED_QTY,
       FLOOR((10 + MOD(ABS(HASH(ID, 'req')), 31)) * (0.70 + MOD(ABS(HASH(ID, 'avail')), 1000) / 1000 * 0.35)) AS ON_HAND_QTY,
       MOD(ABS(HASH(ID, 'order')), 4) AS ON_ORDER_QTY,
       CURRENT_DATE() AS SNAPSHOT_DATE
FROM RAW.SITES;

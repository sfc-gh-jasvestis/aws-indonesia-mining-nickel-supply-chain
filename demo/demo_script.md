# Indonesia Nickel Supply Chain

**Indonesia - Nickel Mine to Port to Smelter**
Use case: Ore flow, grade traceability and disruption risk

> Supply-chain monitoring for a fictional network of 30 nickel sites across 6 Indonesian regions (mine pits, ROM stockpiles, haul roads, barge jetties and smelter feed yards): dynamic tables, a holdout-evaluated disruption-risk classifier, an ore-tonnage forecast and grounded AI answers.

## Why Snowflake

- **Dynamic tables** reconcile on-spec ore, rejected loads and equipment uptime from RAW site data, with checks in `run_core.py`
- **Disruption-risk classification** gives a holdout-evaluated next-7-day disruption probability per site
- **Ore-tonnage forecast** projects 14 days of network-wide ore tonnage with prediction intervals
- **Grounded AI**: the Cortex Agent (Analyst over a semantic view, plus Search over SOPs) shows its SQL and SOP citations
- **Live telemetry**: a native simulator (Snowflake only) or IoT Core, S3 and Snowpipe (AWS build), then an alert and email

## What is built

| | |
|---|---|
| Dimension table | `RAW.SITES` (30 rows) |
| Fact table | `RAW.SITE_DAILY` (2,700 site-days, 90 days) |
| Curated layer | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `DISRUPTION_CAUSES`, `TREND_ANALYSIS` |
| ML | `ML.DISRUPTION_RISK_SCORES`, `ML.DISRUPTION_RISK_HOLDOUT_METRICS`, `ML.VOLUME_FORECAST`, `ML.DWELL_ANOMALIES` |

Regions: Morowali, Konawe, Kolaka, Halmahera, Obi, Luwu Timur.
Site types: Mine Pit, ROM Stockpile, Haul Road, Barge Jetty, Smelter Feed Yard.

## KPI cards (live from `CURATED.KPI_SUMMARY`; no fallback values)

| Card | Value from the seeded data |
|---|---|
| On-Spec Ore | 90.8% |
| Supply Disruptions | 339 |
| Rejected Loads per 1k Trips | 20.34 |
| Ore Tonnes Moved | 20,010,668 |
| Equipment Uptime | 98.2% |
| Sites Monitored | 30 |
| Fleet Readiness | 85.7% |

Values are synthetic. A rebuild reproduces them because the data is HASH-seeded; dates are relative to the build day.

## Demo flow

1. Executive Cockpit: KPIs, daily on-spec ore, off-spec tonnes by disruption cause, site table
2. Predictive: holdout metrics, risk bands, 14-day ore-tonnage forecast, ore dwell-time anomalies
3. Site Health: equipment uptime, fleet readiness, PM compliance against on-spec ore, then generate the action memo
4. Live IoT: run `CALL APP.SIMULATE_TELEMETRY(20)` (Snowflake only) or `python aws/publish_telemetry.py --count 20` (AWS build). Then run `EXECUTE ALERT APP.LIVE_ALARM_ALERT` and show the alert log and email.
5. Ask AI: the Cortex Agent answers metric questions through the semantic view and cites SOPs from Cortex Search. The SQL is shown.
6. QuickSight (AWS build): the same Snowflake tables through DIRECT_QUERY
7. Architecture: both builds side by side

## Talking points

- Per-site on-spec ore ranges from 86.7% to 93.7%. Luwu Timur is the lowest region, at 90.1%.
- Excavator breakdowns push the most ore off spec of the 14 disruption causes.
- The risk model is evaluated on a time-based holdout: precision 0.55 and recall 0.43 at 0.5, against a 0.45 base rate. Present it as triage, not a guarantee.
- The Morowali heavy-rain haul road closure and the Halmahera barge suspension are excluded from disruption labels, because they are regional events, not site-driven.
- Grade traceability: SOPs require tagging affected ore lots with their grade-control batch ID, and each site-day records on-spec tonnes and average Ni grade.

## Business impact

Use only the sourced references in `README.md` (Business Impact).

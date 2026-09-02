# Nickel Supply Chain Visibility

**Indonesia - Mining & Nickel Processing**
Use case: Supply Chain Visibility

> End-to-end nickel supply chain tracking from mine to battery-grade product for Indonesia's US$33B nickel industry — Dynamic Tables build material flow graphs, Iceberg enables buyer traceability via Athena.

## Why Snowflake

Snowflake tracks nickel from mine face to battery cathode — Dynamic Tables maintain real-time material flow, ML.FORECAST projects processing output, and Iceberg shares certified supply chain data with EV OEMs

- **Mine-to-battery material flow tracking** - Only demo tracking nickel from mine face through RKEF/HPAL to battery-grade product
- **ML.FORECAST for processing plant output** - Only demo forecasting nickel processing output for delivery compliance
- **Grade anomaly detection** - ML.ANOMALY_DETECTION flags ore grade variance before it impacts product specifications
- **Iceberg for EV OEM buyer traceability** - Only demo enabling battery manufacturer supply chain verification via Athena
- **Indonesian nickel processing context** - 22% global reserves, RKEF/HPAL processing, export ban policy, EV battery supply chain

## What is deployed

| | |
|---|---|
| Database | `ID_MINING_NICKEL_SUPPLY_CHAIN` |
| Service | `ID_MINING_NICKEL_SUPPLY_CHAIN_APP` |
| Compute pool | `SEA_DEMOS_INDONESIA_POOL` |
| Dimension table | `RAW.PROCESSING_PLANTS` (20 rows) |
| Fact table | `RAW.PRODUCTION_LOGS` (250,000 rows, 90 days) |
| Curated layer | `CURATED.PERFORMANCE_SUMMARY`, `CURATED.TREND_ANALYSIS`, `CURATED.KPI_SUMMARY` |
| Currency | IDR (Rp) |

Regions in play: Jakarta, North Sumatra, Riau, East Kalimantan, Sulawesi
Segments: Mine to Port, Port to Smelter, Smelter to Export, Domestic

Dynamic tables are created suspended and refreshed on demand:

```bash
./refresh_demo_data.sh ID_MINING_NICKEL_SUPPLY_CHAIN
```

## KPI cards

Every card below is served live from `CURATED.KPI_SUMMARY`. The app keeps the
original literal as a fallback, so it still renders if Snowflake is unreachable.

| Card | Value | Backed by |
|---|---|---|
| Shipments (MTD) | `84 vessels` | total across Processing Plants |
| Port Queue | `7 days` | average per event |
| Ore Stockpile | `2.4M WMT` | total across Processing Plants |
| Active Haulers | `1,247` | total across Processing Plants |
| Hauling Cost/WMT | `Rp 124K` | average per event |
| Port Utilization | `87%` | average per event |
| Vessel Turnaround | `4.2 days` | average per event |


## Demo flow

1. Supply Chain Overview
2. Material Flow
3. Predictive Analytics
4. Ask AI
5. Architecture & Data

## Talking points

- **40 mines** - active nickel mines across Sulawesi and Maluku
- **12 plants** - RKEF and HPAL processing plants
- **80,000 movements** - material flow records tracked
- **96.3% compliance** - buyer delivery commitment rate
- **150 documents** - contracts and certificates searchable
- **92% of plan** - current monthly production output

## Business impact

- Indonesia produced 1.8 million tonnes of nickel in 2023 — 49% of global mine production (USGS)
- Indonesia's nickel downstream industry attracted US$33B in investment since export ban (2020-2023) (BKPM)
- EV battery manufacturers require full mine-to-cathode traceability for ESG compliance (IEA)
- Processing yield optimization in nickel HPAL plants can improve output by 3-5% (Wood Mackenzie)

---
Generated from `generator/demo_specs/aws-indonesia-mining-nickel-supply-chain.json`. Do not hand-edit: run
`python3 generator/gen_repo_docs.py aws-indonesia-mining-nickel-supply-chain` instead.

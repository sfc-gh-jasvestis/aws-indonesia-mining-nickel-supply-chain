# Demo Script: Nickel Supply Chain Visibility
## ~4-Minute Recorded Walkthrough
**Format**: Screen recording with voiceover
**Target**: Customer meeting / booth loop / social share
**Narrative**: "Snowflake tracks nickel from mine face to battery cathode — Dynamic Tables maintain real-time material flow, ML.FORECAST projects processing output, and Iceberg shares certified supply chain data with EV OEMs"
**Demo Mode**: Open app with `?demo=true` for presenter notes

---

## Two Personas

| Persona | Role | Tool | What they care about |
|---|---|---|---|
| **Bambang Hartono** | VP Supply Chain & Logistics | React App (SPCS) | Material flow visibility, processing bottlenecks, buyer delivery commitments, export ban compliance |
| **Rina Wulandari** | Operations Analyst | Amazon QuickSight | Processing yield, ore grade variance, logistics costs, stockpile management |

---

## What's Built

| Layer | Component | Detail |
|---|---|---|
| **RAW** | 6 tables | MINES (40), PROCESSING_PLANTS (12), MATERIAL_FLOW (80000), PRODUCTION_LOGS (150000), BUYER_CONTRACTS (200), SUPPLY_CHAIN_DOCS (150) |
| **CURATED** | 4 Dynamic Tables | MATERIAL_BALANCE, PLANT_PERFORMANCE, DELIVERY_COMPLIANCE, GRADE_ANALYTICS |
| **ML** | ML.FORECAST + ML.ANOMALY_DETECTION | Forecasting + anomaly detection |
| **AI** | COMPLETE, AI_EXTRACT, SUMMARIZE | Classification + extraction |
| **Search** | Cortex Search | 150 documents indexed |
| **Agent** | NICKEL_SUPPLY_CHAIN_AGENT | Semantic View + Search tools |


---

## The Story

Indonesia controls 22% of global nickel reserves and has banned raw ore exports to force domestic processing into battery-grade products. With 40 mines feeding 12 RKEF and HPAL plants, the VP Supply Chain needs real-time material flow visibility — but grade variance, processing bottlenecks, and long-term buyer contract commitments require predictive intelligence, not monthly reports.

---

## Script

### [0:00–0:45] SUPPLY CHAIN OVERVIEW

**Show**: Supply Chain Overview tab

> "Forty mines feeding 12 processing plants producing battery-grade nickel for global EV OEMs."

**Action**: Point at 92% output vs plan KPI

### [0:45–1:30] MATERIAL FLOW

**Show**: Material Flow tab

> "80,000 material movements tracked from mine face to battery-grade product."

**Action**: Show Sankey diagram of material flow

### [1:30–2:15] PREDICTIVE ANALYTICS

**Show**: Predictive Analytics tab

> "ML.FORECAST projects production output per plant 30 days forward."

**Action**: Show production forecast chart by plant

### [2:15–3:00] ASK AI

**Show**: Ask AI tab

> "Bambang asks: 'What's our delivery compliance rate for EV OEM contracts?'"

**Action**: Type delivery question

### [3:00–3:45] ARCHITECTURE & DATA

**Show**: Architecture & Data tab

> "Six Snowflake capabilities, six AWS services in the dual-build architecture."

**Action**: Walk through architecture diagram


---

## Key Demo Differentiators

1. **Mine-to-battery material flow tracking** — Only demo tracking nickel from mine face through RKEF/HPAL to battery-grade product
2. **ML.FORECAST for processing plant output** — Only demo forecasting nickel processing output for delivery compliance
3. **Grade anomaly detection** — ML.ANOMALY_DETECTION flags ore grade variance before it impacts product specifications
4. **Iceberg for EV OEM buyer traceability** — Only demo enabling battery manufacturer supply chain verification via Athena
5. **Indonesian nickel processing context** — 22% global reserves, RKEF/HPAL processing, export ban policy, EV battery supply chain


---

## Demo Prep Checklist

### Data Verification
- [ ] `SELECT COUNT(*) FROM NICKEL_SUPPLY_CHAIN.RAW.MINES` → 40
- [ ] `SELECT COUNT(*) FROM NICKEL_SUPPLY_CHAIN.RAW.MATERIAL_FLOW` → 80000
- [ ] `SELECT COUNT(*) FROM NICKEL_SUPPLY_CHAIN.RAW.PRODUCTION_LOGS` → 150000

### ML Model Verification
- [ ] `SELECT COUNT(*) FROM NICKEL_SUPPLY_CHAIN.ML.PRODUCTION_OUTPUT_FORECAST_RESULTS` → >0
- [ ] `SELECT COUNT(*) FROM NICKEL_SUPPLY_CHAIN.ML.GRADE_VARIANCE_RESULTS WHERE IS_ANOMALY = TRUE` → >=3

### AI/Agent Verification
- [ ] `SELECT COUNT(*) FROM NICKEL_SUPPLY_CHAIN.AI.DOC_EXTRACT_RESULTS` → 150


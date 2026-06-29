# Marketing A/B Test Analysis

An end-to-end data analytics pipeline analyzing the performance of a marketing ad campaign against a PSA control group - built with PostgreSQL, Excel Power Query, and Power BI.

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL / pgAdmin | Data exploration, integrity checks, baseline conversion calculations |
| Microsoft Excel / Power Query | Data ingestion, transformation, frequency segmentation, executive reporting |
| Microsoft Power BI Desktop | Interactive dashboard, DAX measures, trend visualization |

---

## Project Structure
marketing-ab-test-project/

├── ab_test_analysis.sql                    # PostgreSQL aggregation and audit script

├── Marketing_AB_Test_Analysis.pbix         # Interactive Power BI dashboard

├── Marketing_AB_Test_Data_Summary.xlsx     # Corporate reporting sheet with delta formulas

## Dataset

**588,101 unique user profiles** tracked during the active experimental window.

| Column | Type | Description |
|---|---|---|
| `user_id` | Integer | Unique participant identifier |
| `test_group` | Categorical | `ad` (treatment) or `psa` (control) |
| `converted` | Boolean | Whether the user completed a purchase |
| `total_ads` | Integer | Total ad impressions received by the user |
| `most_ads_day` | String | Day of week with peak ad exposure |
| `most_ads_hour` | Integer | Hour (0–23) with peak ad exposure |

---

## Key Insights

- **Campaign Impact:** The ad group achieved a **2.55% conversion rate** vs. the control group's **1.79%** — a **42.46% relative lift**.
- **Optimal Timing:** Conversion spikes are highest on **Mondays and Tuesdays**, making these the highest-priority budget allocation days.
- **Ad Frequency:** No early ad fatigue observed. Conversion rates climb to **~9.15%** for users who received **31+ ad impressions**, supporting a high-frequency ad strategy.

---

## Technical Notes

- A custom Power Query column maps day names (Monday–Sunday) to sort values (1–7) to fix default alphabetical axis ordering.
- Ad impressions are segmented into four frequency buckets: `1–5`, `6–15`, `16–30`, and `31+` for cohort-level analysis.

---

## Power BI Dashboard

An executive-ready dashboard (`Marketing_AB_Test_Analysis.pbix`) translates the processed data pipeline into actionable business visuals:

- A synchronized multi-line chart comparing daily performance tracking metrics across the treatment and control groups       simultaneously.
- High-level modern KPI indicator cards providing an instantaneous look at experiment volume scales.
- Structured coordinate charts displaying overall treatment-vs-control lift summaries.

### Dashboard Preview

![Dashboard Preview](images/dashboard_preview.png)


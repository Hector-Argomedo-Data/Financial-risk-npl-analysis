# 📓 Data Journal - CMF Risk Project

## [Phase 1: Preparation & Structuring in Google Sheets]

### 1. Handling of Inconsistencies, Headers, and CMF Symbolism
- **[P] Problem:** Original CMF spreadsheets contained '---' symbols for empty cells, thousand separators as commas, and multi-line headers (up to 3 rows) with accents and special characters, which prevented automated reading in BigQuery.
- **[D] Decision:** Design a base template (mold) in Google Sheets, flatten headers into a single row using strict `snake_case` (without accents or special symbols), replace nulls, and add the `date` column.
- **[A] Action:** Massive replacement of '---' with `0`, structural header flattening, and temporal metadata injection across all 24 reports.
- **[R] Result:** 24 isolated and structured files featuring native `snake_case` headers for SQL, fully prepared for `FLOAT64`/`INT64` data typing.

---

## [Phase 2: Automation Pipeline & Numerical Precision Handling with Python]

### 1. Mass Ingestion, CSV Conversion & Precision Rounding (Python & Pandas)
- **[P] Problem:** Manual conversion of 24 files to `.csv` formats was excessively time-consuming. Additionally, spreadsheet transformations introduced extensive floating-point decimals that could not be globally corrected via visual formatting.
- **[D] Decision:** Build an automated Python script (Google Colab) using `pandas` and `glob` (for recursive folder traversal) to convert files to `.csv` and enforce integer rounding on numerical values.
- **[A] Action:** Execution of recursive directory reading, application of `.round(0)` on floating-point columns, and export in `UTF-8` encoding:

```python
import glob
import os
import pandas as pd

# Recursive traversal and conversion with precision rounding
for file_path in glob.glob(
    os.path.join(source_folder, "**/*.csv"), recursive=True
):
  df = pd.read_csv(file_path)

  for col in df.select_dtypes(include=["float64", "float32"]).columns:
    df[col] = df[col].round(0)

  df.to_csv(output_path, index=False, encoding="utf-8")

---

## [Phase: 03 — Historical Consolidation & Ingestion in BigQuery (SQL)]

- **[P] Problem:** Data fragmentation across 24 independent files (12 loan portfolios and 12 assets), preventing cross-sectional analytical queries and overloading local processing.
- **[D] Decision:** Centralize storage in Google BigQuery to leverage a scalable Data Warehouse environment and utilize SQL (`UNION ALL` and DDL statements) to unify monthly reports into two large historical master tables (`historical_loans` and `historical_assets`).
- **[A] Action:** Creation of the BigQuery dataset, uploading preprocessed CSV files, executing SQL scripts for table union, and proper schema definition through explicit data casting (`CAST` to `FLOAT64` and `INT64`) and date parsing.
- **[R] Result:** Two consolidated, cloud-optimized historical tables providing complete traceability across the 12 analyzed months, ready to be consumed directly by Power BI while reducing query response times to milliseconds.

---

## [Phase: 04 — Dashboard Design & Executive UI in Power BI]

- **[P] Problem:** Risk of falling into "Scale Blindness" when comparing institutions with drastically disparate asset volumes, combined with the inability to simultaneously filter two independent fact tables (`historical_loans` and `historical_assets`).
- **[D] Decision:** Adopt a Star Schema data model architecture using a bridge dimension table (`Dim_Bank`) and design a grid layout interface combining absolute volume metrics with relative ratios.
- **[A] Action:** Construction of the `Dim_Bank` dimensional table via DAX with 1:* relationships to both fact tables, development of dynamic conditional titles (`Executive_Sheet_Title`), and layout structuring of KPI cards and charts following the "F"-pattern visual flow.
- **[R] Result:** An interactive executive dashboard allowing fluid switching between the global system summary and individual bank sheets, synchronizing real-time filters and revealing actual capital at risk alongside delinquency and provision coverage percentages.

**Key Learning:** A low delinquency percentage in a massive bank represents a significantly higher absolute volume of money at risk than a high percentage in a small institution. Absolute monetary volume must always accompany the relative percentage ratio.



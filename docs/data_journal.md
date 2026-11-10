# 📓 Data Journal - CMF Risk Project

## [Phase 1: Preparation & Structuring in Google Sheets]

### 1. Handling Inconsistencies, Headers, and CMF Formatting Conventions
- **[P] Problem:** The original CMF spreadsheets contained '---' symbols representing empty cells, commas as thousand separators, and multi-row headers (up to 3 rows) with accented characters and special symbols, preventing automated data ingestion into BigQuery.
- **[D] Decision:** Design a standardized base template in Google Sheets, flatten headers into a single row using strict `snake_case` naming conventions (without accents or special characters), replace null values, and add a `date` column.
- **[A] Action:** Perform bulk replacement of '---' with `0`, flatten multi-row headers, and inject temporal metadata across all 24 reports.
- **[R] Result:** 24 individually structured files with native `snake_case` headers, fully prepared for SQL processing and `FLOAT64`/`INT64` data typing.

---

## [Phase 2: Automation Pipeline & Numerical Precision Handling with Python]

### 1. Bulk Ingestion, CSV Conversion & Numerical Rounding (Python & Pandas)
- **[P] Problem:** Manually converting 24 files into `.csv` format was excessively time-consuming. Additionally, spreadsheet transformations introduced extensive floating-point decimal values that could not be consistently corrected through visual formatting alone.
- **[D] Decision:** Develop an automated Python script in Google Colab using `pandas` and `glob` (for recursive directory traversal) to convert files into `.csv` format and enforce integer rounding on numerical values.
- **[A] Action:** Execute recursive directory scanning, apply `.round(0)` to floating-point columns, and export the resulting files using `UTF-8` encoding:


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

  df.to_csv(output_path, index=False, encoding="utf-8")```

## [Phase 3 — Historical Consolidation & Ingestion in BigQuery (SQL)]

- **[P] Problem:** Data fragmentation across 24 independent files (12 loan portfolios and 12 asset reports) prevented cross-sectional analytical queries and increased the local processing workload.
- **[D] Decision:** Centralize data storage in Google BigQuery to leverage a scalable Data Warehouse environment and use SQL (`UNION ALL` and DDL statements) to consolidate monthly reports into two comprehensive historical master tables (`historical_loans` and `historical_assets`).
- **[A] Action:** Create the BigQuery dataset, upload preprocessed CSV files, execute SQL scripts to merge tables, and properly define schemas through explicit data type casting (`CAST` to `FLOAT64` and `INT64`) and date parsing.
- **[R] Result:** Two consolidated, cloud-optimized historical tables providing complete traceability across the 12 analyzed months, ready for direct integration into Power BI, with query response times reduced to milliseconds.

---

## [Phase 4 — Dashboard Design & Executive UI in Power BI]

- **[P] Problem:** The risk of "Scale Blindness" when comparing financial institutions with significantly different asset volumes, combined with the inability to simultaneously filter two independent fact tables (`historical_loans` and `historical_assets`).
- **[D] Decision:** Implement a Star Schema data model using a bridge dimension table (`Dim_Bank`) and design a grid-based dashboard layout combining absolute volume metrics with relative ratios.
- **[A] Action:** Build the `Dim_Bank` dimension table using DAX, establish 1:* relationships with both fact tables, develop dynamic conditional titles (`Executive_Sheet_Title`), and structure KPI cards and charts following the "F-pattern" visual hierarchy.
- **[R] Result:** An interactive executive dashboard enabling seamless navigation between the overall system summary and individual bank reports, synchronizing filters in real time and revealing actual capital at risk alongside delinquency and provision coverage ratios.

**Key Learning:** A low delinquency rate at a large bank can represent a significantly higher absolute monetary amount at risk than a high delinquency rate at a smaller institution. Absolute monetary exposure must always be presented alongside relative percentage ratios.



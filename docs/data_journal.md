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

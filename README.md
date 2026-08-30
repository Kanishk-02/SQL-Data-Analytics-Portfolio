# World Layoffs Data Cleaning (SQL)

## Overview
Cleaned and transformed a raw global tech layoffs dataset using MySQL Workbench to prepare it for downstream exploratory data analysis and reporting.

## Key Data Cleaning Steps
- **Staging Architecture:** Created staging tables (`layoff_staging`, `layoff_staging2`) to preserve raw source data integrity.
- **Deduplication:** Utilized `ROW_NUMBER()` with `PARTITION BY` window functions to remove duplicate rows.
- **Standardization:** Cleaned whitespace (`TRIM()`), unified industry categories (e.g., Crypto), and converted string dates to MySQL `DATE` data types using `STR_TO_DATE()`.
- **Null Imputation:** Executed self-joins on matching `company` and `location` records to populate missing `industry` values.
- **Data Quality Filtering:** Dropped uninformative rows lacking critical metrics (`total_laid_off` and `percentage_laid_off`).

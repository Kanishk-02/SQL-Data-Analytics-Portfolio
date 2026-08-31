# World Layoffs Data Cleaning & EDA (SQL)

## Overview
Cleaned and transformed a raw global tech layoffs dataset using MySQL Workbench, followed by exploratory data analysis (EDA) to surface business trends, rolling totals, and industry rankings.

## Key Data Cleaning Steps
* **Staging Architecture:** Created staging tables (`layoff_staging`, `layoff_staging2`) to preserve raw source data integrity.
* **Deduplication:** Utilized `ROW_NUMBER()` with `PARTITION BY` window functions to remove duplicate rows.
* **Standardization:** Cleaned whitespace (`TRIM()`), unified industry categories (e.g., Crypto), and converted string dates to MySQL `DATE` data types using `STR_TO_DATE()`.
* **Null Imputation:** Executed self-joins on matching `company` and `location` records to populate missing `industry` values.
* **Data Quality Filtering:** Dropped uninformative rows lacking critical metrics (`total_laid_off` and `percentage_laid_off`).

## Key EDA Insights
* **Peak Layoff Period:** 2023 recorded the largest total concentration of job losses across the dataset.
* **Top Impacted Industries:** Consumer, Retail, and Transportation sectors experienced the highest cumulative layoffs.
* **High-Capital Failures:** Multiple companies with over $500M in funding suffered complete 100% workforce shutdowns.

## Files Included
* `01_layoffs_data_cleaning.sql`: Full data cleaning script.
* `02_layoffs_exploratory_analysis.sql`: EDA script identifying key business patterns, rolling sums, and company rankings.
* `layoffs.csv`: Raw dataset.

## SQL Techniques Demonstrated
* Window Functions (`ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER`)
* CTEs & Chained Logic for multi-level rankings
* Date & String Formatting (`DATE_FORMAT()`, `STR_TO_DATE()`, `TRIM()`)
* Data Definition & Transformation (`CREATE TABLE`, `UPDATE`, `DELETE`, Self-Joins)

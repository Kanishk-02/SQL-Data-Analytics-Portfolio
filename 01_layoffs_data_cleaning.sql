-- SQL Data Cleaning Project: Layoffs Dataset
-- Author: Kanishk Anand
-- Database: MySQL

-- Reset environment for clean re-execution
DROP TABLE IF EXISTS layoff_staging;
DROP TABLE IF EXISTS layoff_staging2;


-- Create Staging Table
-- Preserve original raw data by creating a working staging table
 
CREATE TABLE layoff_staging
LIKE layoffs;

INSERT INTO layoff_staging
SELECT *
FROM layoffs;


-- Remove Duplicates
-- Create a second staging table containing row numbers to safely filter duplicates


CREATE TABLE `layoff_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off,percentage_laid_off, `date` , stage,country,funds_raised_millions
) AS row_num
FROM layoff_staging;

-- Delete identical duplicate rows
DELETE 
FROM layoff_staging2
WHERE row_num > 1;


-- Standardize Data
-- Clean whitespace, standardize categories, and format date data types

-- Remove extra spaces from company names
UPDATE layoff_staging2
SET company = TRIM(company);

-- Standardize industry terminology
UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize country strings by removing trailing punctuation
UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert string dates into MySQL DATE format and modify column definition
UPDATE layoff_staging2
SET date = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;



-- Populate NULL & Blank Values
-- Impute missing values using reference rows from the same company and location

-- Convert empty strings to NULLs for consistent handling
UPDATE layoff_staging2
SET industry = NULL
WHERE industry = '';

-- Self-join to populate missing industry data from matching company records
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry =t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


-- Remove Unusable Records & Clean Up Staging Columns

-- Drop rows lacking both critical layoff metrics
DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Remove row_num column used during deduplication
ALTER TABLE layoff_staging2
DROP COLUMN row_num;



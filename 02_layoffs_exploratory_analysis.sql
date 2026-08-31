
-- EXPLORATORY DATA ANALYSIS (EDA) - GLOBAL LAYOFFS
-- Dataset: layoff_staging2
-- Tool: MySQL Workbench


-- BASELINE STATS & EXTREME VALUES

-- Preview full cleaned table
SELECT *
FROM layoff_staging2;

-- Identify absolute maximum single-day layoffs and percentage
SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoff_staging2;

-- Identify companies that shut down completely (100% laid off) ordered by capital raised
SELECT *
FROM layoff_staging2
where percentage_laid_off=1
ORDER BY funds_raised_millions DESC;


-- CATEGORICAL BREAKDOWNS

-- Total layoffs per company
SELECT company , SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Identify the date range of the dataset
SELECT MIN(`date`),MAX(`date`)
FROM layoff_staging2;

-- Total layoffs by industry
SELECT industry , SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs by country
SELECT country , SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs by year
SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total layoffs by company funding stage
SELECT stage,SUM(total_laid_off)
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Average layoff percentage per company
SELECT company,AVG(percentage_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;


-- TIME SERIES & ROLLING TOTALS

-- Monthly total layoffs (YYYY-MM format)
SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off)
FROM layoff_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Cumulative rolling total of layoffs over time
WITH Rolling_Total AS
(
	SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) AS total_off
	FROM layoff_staging2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `MONTH`
)
SELECT `MONTH`,total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


-- ADVANCED RANKING & BUSINESS INSIGHTS

-- Top 5 companies with highest layoffs for each year (Window Function)
WITH Company_Year (company,years,total_laid_off) AS
(
	SELECT company,YEAR(`date`) , SUM(total_laid_off)
	FROM layoff_staging2
	GROUP BY company,YEAR(`date`)
),
Company_Year_Rank AS
(
	SELECT * , DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
	FROM Company_Year
	WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking<=5;

-- Top 3 most impacted industries per year
WITH Industry_Year (industry, years, total_laid_off) AS 
(
    SELECT industry, YEAR(`date`), SUM(total_laid_off)
    FROM layoff_staging2
    WHERE industry IS NOT NULL AND `date` IS NOT NULL
    GROUP BY industry, YEAR(`date`)
),
Industry_Rank AS 
(
    SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM Industry_Year
)
SELECT * 
FROM Industry_Rank 
WHERE ranking <= 3;

-- Top 10 highest-funded companies that went completely out of business
SELECT company, industry, country, funds_raised_millions, total_laid_off
FROM layoff_staging2
WHERE percentage_laid_off = 1 
  AND funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC
LIMIT 10;
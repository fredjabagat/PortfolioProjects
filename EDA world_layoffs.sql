--  Exploratory Data Analysis

SELECT *
FROM layoffs_2;

-- Identfy Min and Max total_laid_off as well as top 10 companies 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_2;

--  Looking through companies which went bankcrupt
SELECT *
FROM layoffs_2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC ;


-- aggregating companies by total sum of laid off
SELECT company, SUM(total_laid_off) as sum_laid_off
FROM layoffs_2
GROUP BY company
order by sum_laid_off DESC;


-- sorting out dates to better narrow our analysis (2020-03-11 TO 2023-03-06) Total of 3 years of data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_2;

-- aggregating Industry by total sum of laid off
SELECT industry, SUM(total_laid_off) as sum_laid_off
FROM layoffs_2
GROUP BY industry
order by sum_laid_off DESC;

--  aggregating Country by total sum of laid off
SELECT country, SUM(total_laid_off) as sum_laid_off
FROM layoffs_2
GROUP BY country
order by sum_laid_off DESC;

-- total sum group by YEAR ( 2023 HAVE ONLY 3 MONTHS OF DATA YET IT HAS 125K TOTAL LAID OFF)

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- sum total lay off by stages 
SELECT stage,  SUM(total_laid_off)
FROM layoffs_2
GROUP BY stage
ORDER BY 2  DESC;


-- Progression of Laid offs using rolling sum
SELECT *
FROM layoffs_2;

-- QUERY for year and months total sum
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;


-- using CTE to calculate rolling total of total laid off per month

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS  total_LO
FROM layoffs_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1

)
SELECT `Month`, total_LO,
 SUM(total_LO) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_total;

-- 

SELECT company, YEAR(`Date`), SUM(total_laid_off)
FROM layoffs_2
GROUP BY company,  YEAR(`Date`)
ORDER BY 3 desc;


-- using CTE

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`Date`), SUM(total_laid_off)
FROM layoffs_2
GROUP BY company,  YEAR(`Date`)

), company_year_rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as d_rank
FROM company_year
WHERE years IS NOT NULL)

-- using nested CTE to limit ranking to 5

SELECT *
FROM company_year_rank
WHERE d_rank <=5;



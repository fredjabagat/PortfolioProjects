/** Project 1 Data Cleaning 
1. Remove duplicates
2. Standardized data
3. Filling in/ Handling missing values (NULL values or blank values)
4. Remove unecessary columns

**/

-- Take a quick look at the entire data and scheme through different columns

SELECT *
FROM layoffs;


-- Creating a duplicate table  to save RAW data as back update
-- 1. Removing Duplicates

CREATE TABLE layoffs_backup_file
LIKE layoffs;

-- inserting values into the empty to table by copying/duplicating the same table

INSERT layoffs_backup_file
SELECT * 
FROM layoffs;

-- check/update

SELECT *
FROM layoffs_backup_file;


SELECT *
FROM layoffs;

-- Identfying duplicates by creating another column using row_number

SELECT *,
		ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs;


-- using CTE to identfy exact duplicates for all the columns

WITH duplicate_cte AS
(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
	FROM layoffs
)

SELECT *
FROM duplicate_cte
WHERE row_num >1;

-- Since I cannot delete/update within CTE on mySQL, I will create another duplicate table with row_num included


CREATE TABLE `layoffs_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Inserting values of the duplicate with row_num values

INSERT INTO layoffs_2
SELECT *,
		ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
						percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
	FROM layoffs;
    
    
-- check values and duplicates
SELECT *
FROM layoffs_2
WHERE row_num >1;


-- delete duplicates
DELETE
FROM layoffs_2
WHERE row_num >1;
-- 1. Removed Duplicates(DONE!)



-- 2. Standardizing Data by removing white spaces 


-- Identifying and Removing white spaces
SELECT DISTINCT(company), TRIM(company)
FROM layoffs_2;

-- removing white spaces
UPDATE layoffs_2
SET company = TRIM(company);

--
SELECT Distinct industry
FROM layoffs_2
order by 1;
--  There are 3 distinct different Crypto Industry
SELECT *
FROM layoffs_2
WHERE industry LIKE 'Crypto%';

-- standardizing and grouping into one category

UPDATE layoffs_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; 

-- CHECK VALUES 
SELECT *
FROM layoffs_2
where industry = 'crypto';


SELECT DISTINCT country
FROM layoffs_2
WHERE country LIKE 'United States%';


SELECT DISTINCT *
FROM layoffs_2
WHERE country LIKE 'United States%'
AND company Like 'Twilio';

 -- removing '.' standardizing United States
UPDATE layoffs_2
SET country = 'United States'
where country LIKE 'United States.%';

-- Standardizing Data type from text to Date

SELECT `date`,
		STR_TO_DATE(`date`,'%m/%d/%Y') as Date_of_Layoffs
FROM layoffs_2;

 -- update date format
UPDATE layoffs_2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

-- modify data type from text to date

ALTER TABLE layoffs_2
MODIFY COLUMN `date` DATE;

-- check
SELECT * 
FROM layoffs_2;


-- 3. Handling nulls/missing values

SELECT * 
FROM layoffs_2
WHERE total_laid_off is null
AND percentage_laid_off is null ;


 -- identfiying blank values and populating it
SELECT *
FROM layoffs_2
WHERE industry is NULL
or industry = '';

SELECT *
FROM layoffs_2
WHERE company = 'airbnb';

-- populating '' values into NULL values
UPDATE layoffs_2
SET industry = NULL
where industry = '';  

-- doing a self-join to populate the industry column with null values

SELECT *
FROM layoffs_2 t1
JOIN layoffs_2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


-- UPDATING using a selfjoin to match null values and fill in the industry values that are null
UPDATE layoffs_2 t1
JOIN layoffs_2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is NOT NULL;


-- check 


SELECT *
FROM layoffs_2
WHERE industry is NULL
or industry = '';



SELECT *
FROM layoffs_2;

-- DELETING NULL VALUES/columns that won't apply into our EDA process later on


SELECT * 
FROM layoffs_2
WHERE total_laid_off is null
AND percentage_laid_off is null;

DELETE
FROM layoffs_2
WHERE total_laid_off is null
AND percentage_laid_off is null;



SELECT *
FROM layoffs_2;

-- removing row_num column
ALTER TABLE layoffs_2
DROP COLUMN row_num;



SELECT *
FROM layoffs_2;
#World Life Expectancy Data Cleaning

SELECT *
FROM world_life_expectancy;


-- check for any duplicates using country and year
SELECT country, year, CONCAT(country, year) as countryYEAR, COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year, countryYEAR
HAVING COUNT(CONCAT(country, year)) > 1 ;

-- using sub query and window fucntion to identify the duplicates by country and year
SELECT *
FROM(
SELECT Row_ID,
		CONCAT(Country, Year),
		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
FROM world_life_expectancy)  as duplicate_table
WHERE row_num > 1;

-- DELETE duplicates using a sub-query

DELETE FROM world_life_expectancy
WHERE Row_ID IN(
				SELECT Row_ID
				FROM(
						SELECT Row_ID,
								CONCAT(Country, Year),
								ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
						FROM world_life_expectancy)  as duplicate_table
				WHERE row_num > 1);
                
                
-- filter out white spaces in Status column
SELECT *
FROM world_life_expectancy
WHERE status = '';
-- Status values are only either DEVELOPING or DEVELOPED
SELECT DISTINCT(country), status
FROM world_life_expectancy;

-- Using self join to populate status with '' and matching it the countries that have values as Developing in "Status" column
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status =  ''
AND t2.status <> ''
AND t2.status = 'Developing';


-- using self join to also populate "" status in  the developed country
SELECT *
FROM world_life_expectancy
WHERE country = 'United States of America';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status =  ''
AND t2.status <> ''
AND t2.status = 'Developed';

-- Populating Life Expectancy column where ''

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';


-- USING values before and after the '', we will populate it with the average
-- using self join to find the average and using + and - on the year to match the values
-- adding t2 + t3 to populate t1 '' as teh average of the year 2019 and 2017


SELECT 
t1.country, t1.year, t1.`Life expectancy`, 
t2.country, t2.year, t2.`Life expectancy`,
t3.country, t3.year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1 
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1 
WHERE t1.`Life expectancy` = '';

SELECT *
FROM world_life_expectancy;


-- Populating '' using update clause by calculating the average adding the years before and after and divide by 2

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1 
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1 
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = '';

    
    
    
    
    
    
    
    
    
    




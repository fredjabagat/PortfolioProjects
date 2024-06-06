# World Life Expectancy Project Exploratory Data Analysis


SELECT * 
FROM world_life_expectancy;


-- Aggregating  the Life Expectancy by country and finding the minimum and maximum values
-- filtering out zero values to remove outliers
SELECT Country, MIN(`Life expectancy`) AS min_LE, MAX(`Life expectancy`) as max_LE
FROM world_life_expectancy
GROUP BY COUNTRY
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY COUNTRY DESC;


-- using the previous query, we  will calculate the of Life expectancy increase by substracting its min to max

-- Aggregating  the Life Expectancy by country and finding the minimum and maximum values
-- filtering out zero values to remove outliers
SELECT Country, 
		MIN(`Life expectancy`) AS min_LE, 
		MAX(`Life expectancy`) as max_LE,
		 ROUND((MAX(`Life expectancy`) - MIN(`Life expectancy`)),1) as Life_increase
FROM world_life_expectancy
GROUP BY COUNTRY
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY 4 DESC;


-- aggregating the Life expectancy by years
-- We have increased our life expectancy of 6 years from 2007 to 2022, as our entire world
-- filtering out zero values to remove outliers 
SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
GROUP BY Year
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Year;


--  Is there a correlation between GDP and Life expectancy ?
-- YES, the higher the GDP, the higher life expectancy of each countries have
-- aggregating the avg of Life expectancy and GDP and grouping it by country 
-- filtering out outliers that have 0 values
SELECT country, ROUND(AVG(`Life expectancy`),2) AS Life_Expectancy, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
AND GDP > 0
ORDER BY 3 DESC;


--  total count of GDP in half
SELECT (count(GDP)/2) as total
FROM world_life_expectancy
WHERE GDP >0 ;

-- using CASE statment, we find that there is a 10% difference of Life Expectancy with higher GDP compared to lower GDP
SELECT 
	SUM(CASE WHEN GDP >= 1245 THEN 1 ELSE 0 END) high_GDP_Count,
    AVG(CASE WHEN GDP >= 1245 THEN `Life expectancy` ELSE NULL END) high_GDP_Life_Exp,
	SUM(CASE WHEN GDP <= 1245 THEN 1 ELSE 0 END) low_GDP_Count,
    AVG(CASE WHEN GDP <= 1245 THEN `Life expectancy` ELSE NULL END) low_GDP_Life_Exp
FROM world_life_expectancy
;

--
SELECT status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY status;

-- Developing countries have  approx. 67% Avg Life expectancy within 161 countries
-- Developed countries have 79% avg life expectancy within 32 countries
SELECT status, COUNT(DISTINCT country) as countries, ROUND(AVG(`Life expectancy`),1) as avg_life_exp
FROM world_life_expectancy
GROUP BY status;


-- low correlation between BMI and Life expectancy
SELECT country, ROUND(AVG(`Life expectancy`),1) as life_exp, ROUND(AVG(BMI),1) as BMI
FROM world_life_expectancy
GROUP BY country
HAVING life_exp >0
AND BMI > 0
ORDER BY BMI DESC;

-- Using Rolling total to calculate rolling total of deaths
SELECT country, 
year,
`Life expectancy`, 
`Adult Mortality`,
SUM(`Adult Mortality` ) OVER(PARTITION BY country ORDER BY year) AS rolling_total
FROM world_life_expectancy
WHERE country LIKE '%united states%';

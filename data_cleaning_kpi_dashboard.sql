# DATE CLEANING FOR ALL 4 TABLES april_items, feb_items, current_sales and prev_sales


-- most important, create staging/back up file of the raw data
CREATE TABLE april_items_copy LIKE april_items;

INSERT INTO april_items_copy
SELECT * 
FROM april_items;

CREATE TABLE current_sales_copy LIKE current_sales;

INSERT INTO current_sales_copy
SELECT * 
FROM current_sales;

CREATE TABLE feb_items_copy LIKE feb_items;

INSERT INTO feb_items_copy
SELECT * 
FROM feb_items;



CREATE TABLE prev_sales_copy LIKE prev_sales;

INSERT INTO prev_sales_copy
SELECT * 
FROM prev_sales;



SELECT *
FROM april_items;

DESCRIBE april_items;



-- standardizing date column
ALTER TABLE april_items
RENAME COLUMN `ï»¿date` TO `date`;
-- updating data types to its appropriate type
ALTER TABLE april_items
MODIFY COLUMN `date` DATE;

ALTER TABLE april_items
MODIFY COLUMN `time_of_transaction` TIME;



-- I missed some white spaces on the item_name so, I'll remove them using trim
UPDATE april_items
SET item_name = TRIM(item_name);

 -- april_items table cleaned
DESCRIBE april_items;
SELECT *
FROM april_items;


-- Data cleaning for feb_items table
SELECT *
FROM feb_items;
DESCRIBE feb_items;

-- standardizing date column
ALTER TABLE feb_items
RENAME COLUMN `ï»¿date` TO `date`;
-- updating data types to its appropriate type
ALTER TABLE feb_items
MODIFY COLUMN `date` DATE;

ALTER TABLE feb_items
MODIFY COLUMN `time_of_transaction` TIME;

ALTER TABLE feb_items
MODIFY COLUMN `store_hours` DOUBLE;


-- DATA CLEANING FOR current sales and previous sales table

SELECT * FROM current_sales;
SELECT * FROM prev_sales;
DESCRIBE current_sales;
DESCRIBE prev_sales;

-- DROPPING UNECESARY COLUMN
ALTER TABLE current_sales
DROP COLUMN `ï»¿row_id`;

-- standardizing date column name
ALTER TABLE prev_sales
RENAME COLUMN `ï»¿date` TO `date`;


-- modifying date type to its appropriate data
ALTER TABLE current_sales
MODIFY COLUMN `date` DATE;
ALTER TABLE prev_sales
MODIFY COLUMN `date` DATE;

-- DELETING ROWS in prev_sales to remove outliers for when we start analyzing our data
-- keeping only 30 days exact from 01-28-02-28

DELETE
FROM prev_sales
WHERE date IN ('2024-02-29','2024-03-01','2024-03-02');

-- adding table "days" in table current_sales
SELECT * 
FROM current_sales;

ALTER TABLE current_sales
ADD column `days` text;

--  using case statement to populate days column
UPDATE current_sales
SET days = CASE
	WHEN Days_of_week = 1 THEN 'Sunday'
	WHEN Days_of_week = 2 THEN 'Monday'
	WHEN Days_of_week = 3 THEN 'Tuesday'
	WHEN Days_of_week = 4 THEN 'Wednesday'
	WHEN Days_of_week = 5 THEN 'Thursday'
	WHEN Days_of_week = 6 THEN 'Friday'
    WHEN Days_of_week = 7 THEN 'Saturday'
END;
-- check table
SELECT * 
FROM current_sales;

-- fixed the column order for consistency
ALTER TABLE current_sales 
MODIFY COLUMN days TEXT AFTER days_of_week;


-- END of data cleaning process 



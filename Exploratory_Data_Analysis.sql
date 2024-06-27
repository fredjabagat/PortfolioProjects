# EXLPORATORY DATA ANAYLSIS Happy Hour Sales(comparing prev sales to current sales)

SELECT * 
FROM prev_sales;

SELECT * 
FROM current_sales;


--  aggergating gross and net sales by days of weeek LEVEL
-- 1-7 Sunday-Saturday

SELECT 'previous_month' as month_identifier,Days_of_week, days,
	ROUND(SUM(gross_sales),2) as sum_gross, 
    ROUND(SUM(Net_Sales),2) as sum_net,
    ROUND(SUM(discounts),2) as sum_discounts
FROM prev_sales
GROUP BY Days_of_week, days
ORDER BY month_identifier, sum_net DESC;


SELECT 'current_month' as month_identifier,days_of_week, days,
	ROUND(SUM(gross_sales),2) as sum_gross, 
    ROUND(SUM(Net_Sales),2) as sum_net,
    ROUND(SUM(discounts),2) as sum_discounts
FROM current_sales
GROUP BY days_of_week, days

ORDER BY month_identifier, sum_net DESC;


/*
CTE: Simplify the query by creating named result sets 
(prev_sales_agg and current_sales_agg) for the aggregated data

LEFT JOIN: Ensures all records from the previous month are included, 
			even if there are no matches in the current month
            
RIGHT JOIN: Achieved by performing a LEFT JOIN on 
			the reverse order of tables and ensuring to 
			include only rows where the previous month data is null
            
UNION ALL: Combines the results of the LEFT JOIN and simulated RIGHT JOIN operations

Handling Nulls: Use COALESCE to replace null values with zeros in the final result set
*/

WITH prev_sales_agg AS (
    SELECT days_of_week, days,
           SUM(gross_sales) AS sum_gross, 
           SUM(Net_Sales) AS sum_net,
           SUM(discounts) AS sum_discounts
    FROM prev_sales
    GROUP BY days_of_week, days
),
current_sales_agg AS (
    SELECT days_of_week, days,
           SUM(gross_sales) AS sum_gross, 
           SUM(Net_Sales) AS sum_net,
           SUM(discounts) AS sum_discounts
    FROM current_sales
    GROUP BY days_of_week, days
)
SELECT 
    p.days_of_week, 
    p.days, 
    ROUND(p.sum_gross, 2) AS prev_sum_gross,
    ROUND(p.sum_net, 2) AS prev_sum_net,
    ROUND(p.sum_discounts, 2) AS prev_sum_discounts,
    ROUND(COALESCE(c.sum_gross, 0), 2) AS curr_sum_gross,
    ROUND(COALESCE(c.sum_net, 0), 2) AS curr_sum_net,
    ROUND(COALESCE(c.sum_discounts, 0), 2) AS curr_sum_discounts
FROM prev_sales_agg p
LEFT JOIN current_sales_agg c
ON p.days_of_week = c.days_of_week AND p.days = c.days

UNION ALL

SELECT 
    c.days_of_week, 
    c.days, 
    ROUND(COALESCE(p.sum_gross, 0), 2) AS prev_sum_gross,
    ROUND(COALESCE(p.sum_net, 0), 2) AS prev_sum_net,
    ROUND(COALESCE(p.sum_discounts, 0), 2) AS prev_sum_discounts,
    ROUND(c.sum_gross, 2) AS curr_sum_gross,
    ROUND(c.sum_net, 2) AS curr_sum_net,
    ROUND(c.sum_discounts, 2) AS curr_sum_discounts
FROM current_sales_agg c
LEFT JOIN prev_sales_agg p
ON c.days_of_week = p.days_of_week AND c.days = p.days
WHERE p.days_of_week IS NULL

ORDER BY  curr_sum_gross DESC;



-- IDENTFIY THE MONTLY GROSS AND NET FROM BOTH TABLE

SELECT ROUND(SUM(gross_sales),2),
		ROUND(SUM(net_sales),2),
		ROUND(SUM(discounts),2)
FROM prev_sales;

SELECT ROUND(SUM(gross_sales),2),
		ROUND(SUM(net_sales),2),
		ROUND(SUM(discounts),2)
FROM current_sales;

-- COMBINED TWO TABLES IN ONE RESULT SETS USING CTE, left and right join with union all to obtain the final output

WITH pre_sales_agg AS
(SELECT 
	SUM(gross_sales) AS sum_gross,
	SUM(net_sales) AS sum_net,
	SUM(discounts) AS sum_discounts
FROM prev_sales),

current_sales_agg AS 
(SELECT
	SUM(gross_sales) AS sum_gross,
	SUM(net_sales) AS sum_net,
	SUM(discounts) AS sum_discounts
FROM current_sales)

SELECT 
		'Previous' as period, 
		ROUND(COALESCE(sum_gross,0),2) AS total_gross,
		ROUND(COALESCE(sum_net,0),2) AS total_net,
		ROUND(COALESCE(sum_discounts,0),2) AS total_discounts
FROM pre_sales_agg 

UNION ALL 

SELECT 
		'Current' AS Period,
		ROUND(COALESCE(sum_gross,0),2),
		ROUND(COALESCE(sum_net,0),2),
		ROUND(COALESCE(sum_discounts,0),2)
FROM current_sales_agg;


-- current month profit
SELECT ROUND(SUM(Gross_Sales) - (SUM(Discounts) + SUM(Refunds) + SUM(`Taxes_&_Fees`) + SUM(tips)),2) AS profit
FROM current_sales;
-- previous month profit
SELECT ROUND(SUM(Gross_Sales) - (SUM(Discounts) + SUM(Refunds) + SUM(`Taxes_&_Fees`) + SUM(tips)),2) AS profit
FROM prev_sales;

/* INSIGHTS: 
Insights shows that Mondays, Teusdays, and Wednesdays are the lowest sales out of all the days, which means we should continue the happy hour promotion on weekends.

# period, total_gross, VS PROFIT
'Jan-Feb', $66,852.46, $56,818.31
'Mar-Apr', '65,343.38' $53,595.5 


With happy hour promotion, the bussiness was able to match Jan-Feb sales by 98% 
(These months consists of multiple holidays: Chinese New Year, Valentines Day, MLK bday,Washington Day).

I reccomend to continue the happy hour promotion
Another recommendation is to adjust the happy hour promotion on its slowest time of the day to maximize profit.

*/



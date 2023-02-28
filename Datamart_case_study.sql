use datamart;

SELECT * FROM WEEKLY_SALES LIMIT 10;
/*
	DATA CLEANING CHALLENGE
    
    1. In a single query, perform the following operations and generate 
		a new table in the data_mart schema named clean_weekly_sales:
	2. Add a week_number as the second column for each week_date value,
		for example any value from the 1st of January to 7th of January 
        will be 1, 8th to 14th will be 2, etc.
	3. Add a month_number with the calendar month for each week_date 
		value as the 3rd column
	4. Add a calendar_year column as the 4th column containing either 
		2018, 2019 or 2020 values
	5. Add a new column called age_band after the original segment 
		column using the following mapping on the number inside the
        segment value
		
        segment | age_band
        1		| Young Adults
        2		| Middle Aged
        3 or 4	| Retirees

	6. Add a new demographic column using the following mapping for 
		the first letter in the segment values:
		segment | demographic 
		C | Couples |
		F | Families |
	7. Ensure all null string values with an "unknown" string value
		in the origina segment column as well as the new age_band 
        and demographic columns
	8. Generate a new avg_transaction column as the sales value 
		divided by transactions rounded to 2 decimal places for each record
*/ 
CREATE TABLE CLEAN_WEEKLY_SALES
SELECT 
	week_date,
    WEEK(week_date) as week_number,
    MONTH(week_date) as month_number,
    YEAR(week_date) as calender_year,
    region,
    platform,
    CASE
		WHEN segment = 'null' THEN 'Unknown'
        ELSE segment
	END AS segment,
    CASE 
		WHEN RIGHT(segment, 1) = '1' THEN 'Young_Adults'
        WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
        WHEN RIGHT(segment, 1) in ('3', '4') THEN 'Retirees'
        ELSE 'Unknown'
	END as age_band,
    CASE 
		WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
        WHEN LEFT(segment, 1) = 'F' THEN 'Families'
        ELSE 'Unknown'
	END as demographic,
    customer_type,
    transactions,
    sales,
    ROUND(sales/transactions,2) as avg_transactions
FROM WEEKLY_SALES;
    
-- Checking if table is crated accurate or not
SELECT * FROM CLEAN_WEEKLY_SALES LIMIT 5;

/*
	=====================	Data Explorations	=====================
*/


/*	1. Which week numbers are missing from the dataset?	
	
    Solution:
    There are total 53 week in a year so I need to create a table with 
    values from 1 to 53 to check which week number is not present in
    week number.
    
	I will use auto_increment value in single attribute table
    
*/

CREATE TABLE WEEK_NUMBER(ID INT PRIMARY KEY AUTO_INCREMENT);
INSERT INTO WEEK_NUMBER VALUES (), (), (), (), (), (), (), (), (), ();
INSERT INTO WEEK_NUMBER VALUES (), (), (), (), (), (), (), (), (), ();
INSERT INTO WEEK_NUMBER VALUES (), (), (), (), (), (), (), (), (), ();
INSERT INTO WEEK_NUMBER VALUES (), (), (), (), (), (), (), (), (), ();
INSERT INTO WEEK_NUMBER VALUES (), (), (), (), (), (), (), (), (), ();
INSERT INTO WEEK_NUMBER VALUES (), (), ();

SELECT * FROM WEEK_NUMBER;

/* 
	Now I have list of 53 week number
	So performing the query
*/
SELECT ID as week_number from WEEK_NUMBER WHERE ID NOT IN (SELECT DISTINCT week_number FROM CLEAN_WEEKLY_SALES);


/*	2. How many total transactions were there for each year in the dataset?
	
    Solution:
    For each year find the sum of all transaction.
    I will use groupby keyword on calender_year

*/
SELECT
	calender_year,
    sum(transactions) as total_transactions
FROM CLEAN_WEEKLY_SALES
GROUP BY calender_year;


/*	3. What are the total sales for each region for each month?
	
    Solution:
    Here first I will have to group each month then sales for 
    each month.
    So I will apply groupby on both month and sales
*/
SELECT 
	month_number, 
    region,
    sum(sales) as total_sales
FROM CLEAN_WEEKLY_SALES
GROUP BY month_number, region;


/*	4. What is the total count of transactions for each platform
	solution:
    Here I will group by plateform and perform sum on transactions
*/

SELECT
	platform,
    sum(transactions) as total_transactions
FROM CLEAN_WEEKLY_SALES
GROUP BY platform;


/*	5. What is the percentage of sales for Retail vs Shopify for each month?
	Solution:
    Here each month means each month of every year not only jan of all year
    I will need to create another table of month, year, platform and monthly sales.
    Then I will perform case on each plateform ie. Retail and Shopify
*/
CREATE TABLE MONTHLY_SALES
SELECT 
	month_number, calender_year,
    platform,
    sum(sales)  AS monthly_sales
FROM CLEAN_WEEKLY_SALES
GROUP BY month_number, calender_year, platform;

-- Now performing the operation on platform
SELECT 
	month_number, 
    calender_year,
    ROUND(
			100 * MAX(	
			CASE 
				WHEN platform = 'Retail' THEN monthly_sales
				ELSE NULL
            END
			)/sum(monthly_sales)
		,2) as retail_sales,
	ROUND(
		100 * MAX(
			CASE
				WHEN platform = 'Shopify' THEN monthly_sales
                ELSE NULL
			END
        )/sum(monthly_sales)
    ,2) as shopify_sales
FROM MONTHLY_SALES
GROUP BY month_number, calender_year;


/*	6. What is the percentage of sales by demographic for each year in the dataset?
	Solution
    Here I will group by month and year to get all months.
    Then apply partition for each demographic
*/

SELECT
	calender_year,
    sum(sales) as yearly_sales,
    ROUND(
		100*sum(sales)/sum(sum(SALES)) OVER (PARTITION BY demographic)
	,2)
    as sales_percent
FROM CLEAN_WEEKLY_SALES
GROUP BY calender_year, demographic;


/* 	7. Which age_band and demographic values contribute the most to Retail sales?
	Solution:
    Here I will group by with age_band and demographic where platform will be Retail

*/

SELECT 
	age_band,
    demographic,
    sum(sales) as total_sales
FROM CLEAN_WEEKLY_SALES
WHERE platform = 'Retail'
GROUP BY age_band, demographic;

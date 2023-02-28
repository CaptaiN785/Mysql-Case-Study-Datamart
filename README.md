# MySQL Case study on Datamart
<h1 align='center'>Introduction</h1>
<p>
Data Dart is my latest venture and I want your help to analyze the sales and performance of my venture. In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.
I need your help to quantify the impact of this change on the sales performance for Data Mart and its separate business areas.
  <span align='center'>
    
  ![image](https://user-images.githubusercontent.com/83746932/221884406-ec3cee24-180c-434e-9449-ab9a65224d91.png)
  </span>
</p>

<h2 align="left">Challenges</h2>
<h3 align='center'>Challenge - 1</h3>
<p style="font-size:1.1rem;">
<pre>
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
</pre></p>

<h3 align="center"> Challenge - 2 </h3>
<p>
<pre>
    Data Exploration
    
    1. Which week numbers are missing from the dataset?
    2. How many total transactions were there for each year in the dataset?
    3. What are the total sales for each region for each month?
    4. What is the total count of transactions for each platform
    5. What is the percentage of sales for Retail vs Shopify for each month?
    6. What is the percentage of sales by demographic for each year in the dataset?
    7. Which age_band and demographic values contribute the most to Retail sales? 
</pre>
</p>



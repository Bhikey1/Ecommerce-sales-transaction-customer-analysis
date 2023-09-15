-- Ecommerce sales transaction
/* TASKS 
1. Most purchased products and time by customers' age group
2. Most purchased products and time by customers' location 
3. Recommend personalize campaigns and services
*/

-- The dataset has been cleaned 

-- Creating a table for the dataset
CREATE TABLE sales (
date date,
day integer,
month integer,
year integer,
customer_age float,
Country text,
state text,
product_category text,
sub_category text,
product text,
order_quantity integer,
unit_cost integer,
unit_price integer,
profit integer,
cost integer,
revenue integer
)
;

-- Inserting values into the created sales table
LOAD DATA INFILE 'sales_Transaction Ecommerce.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Checking for duplication
SELECT records, count(*)
FROM
(
	SELECT date, day, month, year, customer_age, country, state, product_category, 
    sub_category, product, unit_cost, unit_price, profit, cost, revenue,
    count(*) as records
	FROM sales
	GROUP BY 1,2,3,4,5,6,7,8,9,10
)a
WHERE records > 1
GROUP BY 1
;

-- Checking for missing values 
SELECT *
FROM sales
WHERE date is null
  OR day is null
  OR month is null
  OR year is null
  OR customer_age is null
  OR country is null
  OR state is null
  OR product_category is null
  OR sub_category is null
  OR product is null
  OR quantity_ordered is null
  OR unit_cost is null
  OR unit_price is null
  OR profit is null
  OR cost is null
  OR revenue is null;
-- Checking all columns in sales
SELECT *
FROM sales 
WHERE country = 'United States' and year != 2016
;

-- Customer preferences based on on age group and products
SELECT CASE when customer_age < 25 then 'Youth'             
			when customer_age < 34 then 'Young Adults'              
			when customer_age < 64 then 'Adults'             
			else 'Seniors' end as Age_group,  
sub_category, count(order_quantity) as order_count 
FROM sales 
WHERE Country = 'United States' and year != 2016 
GROUP BY 1, 2 
ORDER BY 3 DESC 
;

-- Customer preferences based on age group and month they buy products
SELECT CASE when customer_age < 25 then 'Youth'            
			when customer_age < 34 then 'Young Adults'   
            when customer_age < 64 then 'Adults'           
            else 'Seniors' end as Age_group,  monthname(date) as month, 
count(order_quantity) as order_count 
FROM sales 
WHERE country = 'United States' and year != 2016 
GROUP BY 1, 2 
ORDER BY 3 DESC 
;

-- Customer preferences based on location and products
SELECT country, state, sub_category, 
count(order_quantity) as order_count
FROM sales
WHERE country = 'United States' and year != 2016
GROUP BY 1,2,3
ORDER BY 4
;

-- Customer purchase by purchase time 
SELECT state, monthname(date) as month, 
count(order_quantity) as order_Count
FROM sales
WHERE country = 'United States' and year != 2016
GROUP BY 1, 2 
ORDER BY 3 DESC
;

-- Most sold product sub-category by order count
SELECT sub_category, count(order_quantity) as order_Count
FROM sales
WHERE country = 'United States' and year != 2016
GROUP BY 1
ORDER BY 2 DESC
;

-- Most sold sub-category by revenue
SELECT sub_category, 
sum(revenue) as revenue
FROM sales
WHERE country = 'United States' and year != 2016
GROUP BY 1
ORDER BY 2 DESC
;

-- Most profitable sub-category
SELECT sub_category, sum(profit) as profit
FROM sales
WHERE country = 'United States' and year != 2016
GROUP BY 1
ORDER BY 2 DESC
;

/* RECOMMENDATIONS 
Personalized campaigns should be made to age groups: adults and young adults 
in States such as California, Washington, and Oregon. It should be made in 
July to December. 
*/

-- Datasource: www.kaggle.com

-- Data visualization/report: 
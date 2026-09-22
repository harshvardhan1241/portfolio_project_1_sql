--creating tabel
CREATE TABLE retail_sale(
transactions_id INT primary key,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(25),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

--comand to run the full tabel
SELECT*
FROM
retail_sale



--count of total row
SELECT
count(*)
FROM
retail_sale

--
SELECT*
FROM
retail_sale as rs
WHERE
rs.transactions_id is NULL

-- finding the null record
SELECT*
FROM
retail_sale as rs
WHERE
rs.transactions_id is NULL
OR
rs.sale_date is NULL
OR
rs.sale_time is NULL
OR
rs.customer_id is NULL
OR
rs.gender is NULL
OR
rs.age is NULL
OR
rs.category is NULL
OR
rs.quantiy is NULL
OR
rs.price_per_unit is NULL
OR
rs.cogs is NULL
OR
rs.total_sale is NULL


-- remove the data where is value is not given mean null
--data cleaning
DELETE FROM
retail_sale as rs
WHERE
rs.transactions_id is NULL
OR
rs.sale_date is NULL
OR
rs.sale_time is NULL
OR
rs.customer_id is NULL
OR
rs.gender is NULL
OR
rs.age is NULL
OR
rs.category is NULL
OR
rs.quantiy is NULL
OR
rs.price_per_unit is NULL
OR
rs.cogs is NULL
OR
rs.total_sale is NULL

-- data exploration 

--total no of record we have
SELECT
count(*)
FROM
retail_sale

-- how many unique customer we have ?
SELECT
count(DISTINCT customer_id)
FROM
retail_sale

-- how may unique category we have?
SELECT
count(DISTINCT category)
FROM
retail_sale

    --name of that three catogory 
    SELECT
    DISTINCT category
    FROM
    retail_sale

-- Data analyst role & business key problem and solutions

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT*
FROM
retail_sale as rs
WHERE
rs.sale_date='2022-11-05' 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT*
FROM
retail_sale as rs
WHERE
rs.category='Clothing'
AND
rs.quantiy>3
AND
EXTRACT(MONTH FROM rs.sale_date) = 11 
  AND EXTRACT(YEAR FROM rs.sale_date) = 2022;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
rs.category,
sum(total_sale) as net_sale,
count(total_sale) as total_order
FROM
retail_sale as rs
GROUP BY rs.category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
round(avg(age),2) as avg_age
FROM
retail_sale as rs
WHERE
rs.category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
*
FROM
retail_sale as rs
WHERE
rs.total_sale>=1000
ORDER BY
rs.sale_date

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
sum(rs.transactions_id) as total_transaction,
rs.category,
rs.gender
FROM
retail_sale as rs
GROUP BY
rs.category,
rs.gender
ORDER BY
rs.category,
rs.gender


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with rank_month as
(
SELECT
 Extract(year from rs.sale_date) as year,
 Extract(month from rs.sale_date)as month,
round(avg(total_sale),2) as avg_sale,
--for getting order of the month and year
rank()over(PARTITION by extract(year from rs.sale_date)
ORDER BY avg(total_sale ) DESC) as rank
FROM
retail_sale as rs
GROUP BY 
year,month)

SELECT
year,
month,
avg_sale
FROM
rank_month 
WHERE
rank='1'
--order BY year,avg_sale DESC

--same qustion can solve with conditon

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
 rs.customer_id,
sum(rs.total_sale) as total_sales
FROM
retail_sale as rs
GROUP BY
rs.customer_id
ORDER BY
total_sales DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
count(DISTINCT rs.customer_id) as count_of_unique_class,
rs.category
FROM
retail_sale as rs
GROUP BY rs.category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_salary as (
SELECT*,
CASE
WHEN extract(HOUR from sale_time )< 12 then 'Morning'
WHEN extract(HOUR from sale_time ) BETWEEN 12 and 17 then 'Afternoon'
ELSE 'Evening'
END as shift
FROM
retail_sale
)

SELECT
count(transactions_id) as total_orders,
shift
FROM
hourly_salary
GROUP BY
shift
ORDER BY
total_orders DESC









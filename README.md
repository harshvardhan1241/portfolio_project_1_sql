# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `SQL-Retail sales Analysis_utf.csv`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales table, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is suitable for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create a retail sales table to store transaction and customer information.
2. **Data Cleaning**: Identify and remove records with missing or NULL values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Table Creation**: The SQL script creates a table named `retail_sale` to store the sales data. The table includes transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
- **Database Note**: The provided SQL script contains the table creation statement but does not include a `CREATE DATABASE` statement.

```sql
CREATE TABLE retail_sale(
    transactions_id INT PRIMARY KEY,
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify the number and names of unique product categories.
- **Null Value Check**: Check for NULL values in the dataset and delete records with missing data in the specified columns.
- **Table Inspection**: Retrieve table records to inspect the data.

```sql
-- View all records
SELECT *
FROM retail_sale;

-- Count total rows
SELECT COUNT(*)
FROM retail_sale;

-- Check for NULL transaction IDs
SELECT *
FROM retail_sale AS rs
WHERE rs.transactions_id IS NULL;

-- Find records containing NULL values
SELECT *
FROM retail_sale AS rs
WHERE rs.transactions_id IS NULL
   OR rs.sale_date IS NULL
   OR rs.sale_time IS NULL
   OR rs.customer_id IS NULL
   OR rs.gender IS NULL
   OR rs.age IS NULL
   OR rs.category IS NULL
   OR rs.quantiy IS NULL
   OR rs.price_per_unit IS NULL
   OR rs.cogs IS NULL
   OR rs.total_sale IS NULL;

-- Delete records containing NULL values
DELETE FROM retail_sale AS rs
WHERE rs.transactions_id IS NULL
   OR rs.sale_date IS NULL
   OR rs.sale_time IS NULL
   OR rs.customer_id IS NULL
   OR rs.gender IS NULL
   OR rs.age IS NULL
   OR rs.category IS NULL
   OR rs.quantiy IS NULL
   OR rs.price_per_unit IS NULL
   OR rs.cogs IS NULL
   OR rs.total_sale IS NULL;

-- Count records after cleaning
SELECT COUNT(*)
FROM retail_sale;

-- Count unique customers
SELECT COUNT(DISTINCT customer_id)
FROM retail_sale;

-- Count unique product categories
SELECT COUNT(DISTINCT category)
FROM retail_sale;

-- List the unique product categories
SELECT DISTINCT category
FROM retail_sale;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions.

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'.**

```sql
SELECT *
FROM retail_sale AS rs
WHERE rs.sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in November 2022.**

```sql
SELECT *
FROM retail_sale AS rs
WHERE rs.category = 'Clothing'
  AND rs.quantiy > 3
  AND EXTRACT(MONTH FROM rs.sale_date) = 11
  AND EXTRACT(YEAR FROM rs.sale_date) = 2022;
```

3. **Write a SQL query to calculate the total sales (`total_sale`) for each category.**

```sql
SELECT
    rs.category,
    SUM(total_sale) AS net_sale,
    COUNT(total_sale) AS total_order
FROM retail_sale AS rs
GROUP BY rs.category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**

```sql
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sale AS rs
WHERE rs.category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total sale is greater than or equal to 1000.**

```sql
SELECT *
FROM retail_sale AS rs
WHERE rs.total_sale >= 1000
ORDER BY rs.sale_date;
```

6. **Write a SQL query to find the total number of transactions made by each gender in each category.**

```sql
SELECT
    SUM(rs.transactions_id) AS total_transaction,
    rs.category,
    rs.gender
FROM retail_sale AS rs
GROUP BY
    rs.category,
    rs.gender
ORDER BY
    rs.category,
    rs.gender;
```

7. **Write a SQL query to calculate the average sale for each month and find the best-selling month in each year.**

```sql
WITH rank_month AS (
    SELECT
        EXTRACT(YEAR FROM rs.sale_date) AS year,
        EXTRACT(MONTH FROM rs.sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM rs.sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sale AS rs
    GROUP BY year, month
)
SELECT
    year,
    month,
    avg_sale
FROM rank_month
WHERE rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales.**

```sql
SELECT
    rs.customer_id,
    SUM(rs.total_sale) AS total_sales
FROM retail_sale AS rs
GROUP BY rs.customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**

```sql
SELECT
    COUNT(DISTINCT rs.customer_id) AS count_of_unique_class,
    rs.category
FROM retail_sale AS rs
GROUP BY rs.category;
```

10. **Write a SQL query to create each shift and find the number of orders (Morning before 12, Afternoon from 12 to 17, Evening after 17).**

```sql
WITH hourly_salary AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sale
)
SELECT
    COUNT(transactions_id) AS total_orders,
    shift
FROM hourly_salary
GROUP BY shift
ORDER BY total_orders DESC;
```

## Findings

The SQL queries are designed to explore the following areas:

- **Customer Demographics**: Examine customer ages and purchasing activity across product categories, including Beauty and Clothing.
- **High-Value Transactions**: Identify transactions with a total sale amount of at least 1000.
- **Sales Trends**: Compare average sales by month and identify the highest-average-sale month or months in each year.
- **Customer Insights**: Identify the top 5 customers by total sales and count unique customers in each category.
- **Order Timing**: Examine the number of orders placed during Morning, Afternoon, and Evening shifts.

*Specific numerical findings should be added after running the queries against the dataset.*

## Reports

- **Sales Summary**: A summary of category-level sales and order counts.
- **Trend Analysis**: Analysis of average monthly sales and order distribution across shifts.
- **Customer Insights**: Information about customer demographics, top-spending customers, and unique customers by category.
- **Transaction Analysis**: Details of sales on a specified date and high-value transactions.

## Conclusion

This project serves as an introduction to SQL for data analysts, covering table creation, data cleaning, exploratory data analysis, and business-driven SQL queries. The queries provide a way to examine sales patterns, customer behavior, product category performance, and order timing using retail transaction data.

## How to Use

1. **Clone the Repository**: Clone or download this project repository from GitHub.
2. **Set Up the Database**: Create the `p1_retail_db` database in your SQL environment if it does not already exist. Run the table-creation statement in `sql_p1.sql`.
3. **Load the Data**: Import or insert the retail sales dataset into the `retail_sale` table. The provided SQL script does not contain data-loading commands.
4. **Run the Queries**: Execute the queries in `sql_p1.sql` to perform data exploration, cleaning, and analysis.
5. **Explore and Modify**: Modify the queries to explore other aspects of the dataset or answer additional business questions.

## Author - Harshvardhan Dond

This project is part of my portfolio, showcasing SQL skills used for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for visiting my project!

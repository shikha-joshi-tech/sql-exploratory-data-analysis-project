/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
SELECT 
MONTH(order_date) AS order_mnth,
sum(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

SELECT 
YEAR(order_date)AS order_year,
SUM(sales_amount)AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

SELECT 
YEAR(order_date)AS order_year,
MONTH(order_date)AS order_mnth,
SUM(sales_amount)AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

SELECT 
DATEFROMPARTS(YEAR(order_date), MONTH(order_date),1)AS order_mnth,
--DATETRUNC(month,order_date)AS order_mnth,
SUM(sales_amount)AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date),1)
ORDER BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date),1)

SELECT 
FORMAT(order_date,'yyyy-MMM') AS order_date,
sum(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM') 
ORDER BY FORMAT(order_date,'yyyy-MMM') 
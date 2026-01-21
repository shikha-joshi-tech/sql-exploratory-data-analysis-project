/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/
--3.Date Exploration
--first and last order date
SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_years,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS order_range_months
FROM gold.fact_sales  

--youngest and oldest customers
SELECT 
MAX(birthdate) AS youngest_customer_birthdate,
DATEDIFF(year,MAX(birthdate),GETDATE()) AS youngest_customer,
MIN(birthdate) AS eldest_customer_birthdate,
DATEDIFF(year,MIN(birthdate),GETDATE()) AS eldest_customer
FROM gold.dim_customers
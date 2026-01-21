/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
--**************************************************************************
--1. Gathers essential fields such as names, ages, and transaction details
--**************************************************************************
IF OBJECT_ID ('gold.report_customers','V')IS NOT NULL
	DROP VIEW gold.report_customers
GO

CREATE VIEW gold.report_customers AS 

WITH base_query AS(
SELECT
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name)AS customer_name,
DATEDIFF(year,c.birthdate,GETDATE()) AS customer_age,
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key=s.customer_key
WHERE order_date IS NOT NULL)
--****************************************************************************
--3. Aggregates customer-level metrics:
--**************************************************************************** 
,customer_aggregation AS (
SELECT
customer_number,
customer_key,
customer_name,
customer_age,
COUNT(DISTINCT order_number)AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity)AS total_quantity,
COUNT(DISTINCT product_key)AS total_products,
MAX(order_date)AS last_order_date,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan_in_mnths
FROM base_query
GROUP BY customer_key,
customer_name,
customer_number,
customer_age)

SELECT
customer_key,
customer_name,
customer_number,
--**************************************************************************
--2. Segments customers into categories (VIP, Regular, New) and age groups.
--**************************************************************************
customer_age,
CASE
	WHEN customer_age < 20 THEN 'Under 20'
	WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
	WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
	WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
	ELSE '50 and above'
END AS age_group,
CASE 
	WHEN lifespan_in_mnths>=12 AND total_sales>5000 THEN 'VIP'
	WHEN lifespan_in_mnths>=12 AND total_sales<=5000 THEN 'Regular'
	ELSE 'New'
END AS customer_segment,
last_order_date,
--***********************************************
/*4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend */
--***********************************************
DATEDIFF(month,last_order_date,GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products,
CASE WHEN total_orders=0 THEN 0
	ELSE total_sales/total_orders 
END AS average_order_value_AOV,
CASE WHEN lifespan_in_mnths=0 THEN total_sales
	else total_sales/lifespan_in_mnths
END AS avg_monthly_spend
FROM customer_aggregation


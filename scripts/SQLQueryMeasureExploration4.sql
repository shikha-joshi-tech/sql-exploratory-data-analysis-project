/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
--1.find the total sales
SELECT 
SUM(sales_amount)AS  total_sales
FROM gold.fact_sales

--2.how many items are sold
SELECT SUM(quantity) AS total_items_sold
FROM gold.fact_sales
SELECT SUM(DISTINCT quantity) AS total_actual_items_sold
FROM gold.fact_sales

--3.find avg selling price
SELECT AVG(price) FROM gold.fact_sales

--4.total no.of orders
SELECT COUNT(order_number) FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) FROM gold.fact_sales
SELECT order_number FROM gold.fact_sales

--5.total no.of products
SELECT COUNT(product_key)FROM gold.dim_products

--6.total no.of customers
SELECT COUNT(customer_key) FROM gold.dim_customers
SELECT COUNT(DISTINCT customer_key) FROM gold.dim_customers

--7.total no.of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) FROM gold.fact_sales

--------------generate reeport showing that shows all key matrices of the business
SELECT 'Total Sales'AS measure_name ,SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name ,SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
--diff->SELECT SUM(DISTINCT quantity) AS total_actual_items_sold FROM gold.fact_sales
SELECT 'Avg Sell Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total orders' AS measure_name,COUNT(order_number)AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total distinct orders'AS measure_name,COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Products' AS measure_name,COUNT(product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total customers' AS measure_name,COUNT(customer_key) AS measure_value FROM gold.dim_customers

ORDER BY measure_value DESC
--UNION ALL
--same ->SELECT 'Total distinct customers ' AS measure_name ,COUNT(DISTINCT customer_key)AS measure_value FROM gold.dim_customers
--UNION ALL
--same ->SELECT 'Total customers placing order'AS measure_value,COUNT(DISTINCT customer_key)AS measure_name FROM gold.fact_sales


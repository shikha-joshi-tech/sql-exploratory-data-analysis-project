/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

--1.top 5 products generating highest revenue
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS revenue_generated
FROM gold.dim_products P
LEFT JOIN gold.fact_sales s
ON p.product_key=s.product_key
GROUP BY p.product_name
ORDER BY revenue_generated DESC 

SELECT* FROM(
	SELECT
	p.product_name,
	SUM(s.sales_amount)AS revenue_gen,
	ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key=p.product_key
	GROUP BY p.product_name)t
WHERE rank_products<=5

--2.5-worst performing products in sales term
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS revenue_generated
FROM  gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key=s.product_key
GROUP BY p.product_name
ORDER BY revenue_generated

--3.top 10 customer generating highest revenue 
SELECT TOP 10
c.customer_key,
c.first_name + ' '+c.last_name customer_name,
SUM(s.sales_amount) AS revenue_gen
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key=s.customer_key
GROUP BY c.first_name,c.last_name,c.customer_key
ORDER BY revenue_gen DESC

--4. The 3 customers with the fewest orders placed
SELECT TOP 3
c.customer_key,
c.first_name + ' '+c.last_name customer_name,
COUNT(DISTINCT order_number) total_orders
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key=s.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
ORDER BY total_orders
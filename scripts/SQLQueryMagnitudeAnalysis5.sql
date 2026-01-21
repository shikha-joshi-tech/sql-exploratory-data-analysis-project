/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/
--1. Find total customers by countries
SELECT 
country,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country 
ORDER BY total_customers DESC

--2.find total customers by gender
SELECT
gender,
COUNT(customer_key)AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

--3.find total products by category
SELECT
category,
COUNT(product_key)AS total_products
FROM gold.dim_products 
GROUP BY category
ORDER BY total_products 

--4.find avg costs in each category
SELECT 
category,
AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost 

--5.find total revenue generated for each category
SELECT 
p.category,
SUM(s.sales_amount) AS revenue_total
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s 
ON p.product_key= s.product_key
GROUP BY p.category 

--6.find total revenue genrated by each customer
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount)AS total_revenue
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key=s.customer_key
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

--7.find distribution of items sold across countries
SELECT 
c.country,
COUNT(s.order_number) AS dist_of_items  --COUNT(s.quantity)
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key=s.customer_key
GROUP BY c.country
ORDER BY dist_of_items DESC

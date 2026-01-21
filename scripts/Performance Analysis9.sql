/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
--Analyze yearly performance of products by comparing each product's sales to its avg sales performance
WITH yearly_product_sales AS (
SELECT
p.product_name,
YEAR(s.order_date)AS order_year,
SUM(s.sales_amount)AS current_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key=s.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date),p.product_name
)
SELECT 
product_name,
ORDER_YEAR,
current_sales,
AVG(current_sales)OVER(PARTITION BY product_name )AS avg_sales,
current_sales-AVG(current_sales)OVER(PARTITION BY product_name )AS diff_avg,
CASE WHEN current_sales-AVG(current_sales)OVER(PARTITION BY product_name)>0 THEN'Above Avg'
	WHEN current_sales-AVG(current_sales)OVER(PARTITION BY product_name)<0 THEN 'Below Avg'
	ELSE 'Avg'
END avg_change,
--Year-over-year analysis
LAG(current_sales)OVER (PARTITION BY product_name ORDER BY order_year)py_sales,
current_sales-LAG(current_sales)OVER (PARTITION BY product_name ORDER BY order_year)AS diff_py,
CASE WHEN current_sales-LAG(current_sales)OVER (PARTITION BY product_name ORDER BY order_year)>0 THEN 'Above Avg'
	WHEN current_sales-LAG(current_sales)OVER (PARTITION BY product_name ORDER BY order_year)<0 THEN 'Below Avg'
	ELSE 'Avg'
END avg_change
FROM yearly_product_sales
ORDER BY product_name,ORDER_YEAR

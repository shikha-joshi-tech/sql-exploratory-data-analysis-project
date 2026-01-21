/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrices:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products 
---------------------------------------------------------------------------*/
--SELECT*FROM gold.fact_sales
IF OBJECT_ID ('gold.report_products','V') IS NOT NULL
	DROP VIEW gold.report_products;
GO
CREATE VIEW gold.report_products AS 
WITH base_query AS(
SELECT
s.order_number,
s.sales_amount,
s.quantity,
s.customer_key,
s.order_date,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.dim_products p  
LEFT JOIN gold.fact_sales s
ON p.product_key=s.product_key
WHERE order_date IS NOT NULL)

/* ----------------------------------------
3. Aggregates product-level metrics
------------------------------------------*/
,product_aggregations AS(
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
COUNT(DISTINCT order_number)AS total_orders,
COUNT(DISTINCT customer_key)AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
DATEDIFF(month,MIN(order_date),MAX(order_date))AS lifespan,
MAX(order_date)AS last_order_date
FROM base_query
GROUP BY product_key,
product_name,
category,
subcategory,
cost )

SELECT
product_key,
product_name,
category,
subcategory,
cost,
/*----------------------------------------------------------------------------------------------
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
 4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
------------------------------------------------------------------------------------------------
*/
DATEDIFF(month,last_order_date,GETDATE()) AS recency,
CASE
	WHEN total_sales >50000 THEN 'High-Performers'
	WHEN total_sales>=10000 THEN 'Mid-Range'
	ELSE 'Low-Performers'
END AS product_segment,
lifespan,
total_customers,
total_orders,
total_sales,
total_quantity,
CASE WHEN total_orders=0 THEN 0
	ELSE total_sales/total_orders
END AS avg_order_revenue_AOR,
CASE WHEN lifespan=0 THEN total_sales
	ELSE total_sales/lifespan
END AS avg_monthly_revenue
FROM product_aggregations

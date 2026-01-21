/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
--2.Dimensions Exploration
--Explore unique country of customers
SELECT DISTINCT country FROM gold.dim_customers
--Explore unique product categories'Major Divisions'
SELECT DISTINCT category,subcategory,product_name FROM gold.dim_products
ORDER BY 1,2,3
--SELECT DISTINCT category,subcategory,product_name FROM gold.dim_products
--ORDER BY 3,2,1


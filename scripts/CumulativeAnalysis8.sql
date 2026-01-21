/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
--cALCULATE TOTAL SALES PER MONTH + RUNNING TOTAL OF SALES OVER TIME(MONTHLY)+ MOVING AVG (MONTHLY)
SELECT
order_dt,
total_sales,
SUM(total_sales)OVER(ORDER BY DATEFROMPARTS(YEAR(order_dt),MONTH(order_dt),1))AS running_total,
AVG(avg_price)OVER(ORDER BY DATEFROMPARTS(YEAR(order_dt),MONTH(order_dt),1))as moving_avg 
FROM(SELECT 
DATEFROMPARTS(YEAR(order_date),MONTH(order_date),1) as order_dt,
SUM(sales_amount)AS total_sales,
AVG(price)AS avg_price
FROM gold.fact_sales
WHERE order_date is NOT NULL
GROUP  BY DATEFROMPARTS(YEAR(order_date),MONTH(order_date),1))t

--cALCULATE TOTAL SALES PER YEAR+ RUNNING TOTAL OF SALES OVER TIME(YEARLY)+ MOVING AVG (YEARLY)
SELECT
order_dt,
total_sales,
SUM(total_sales)OVER(ORDER BY DATEFROMPARTS(YEAR(order_dt),1,1))AS running_total,
AVG(avg_price)OVER(ORDER BY DATEFROMPARTS(YEAR(order_dt),1,1))as moving_avg 
FROM(SELECT 
DATEFROMPARTS(YEAR(order_date),1,1) as order_dt,
SUM(sales_amount)AS total_sales,
AVG(price)AS avg_price
FROM gold.fact_sales
WHERE order_date is NOT NULL
GROUP  BY DATEFROMPARTS(YEAR(order_date),1,1))t

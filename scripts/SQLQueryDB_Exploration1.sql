/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
--1.Database Exploration
--Explore all schemas in the database
SELECT* FROM INFORMATION_SCHEMA.SCHEMATA

--Explore all objects in the database 
SELECT* FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in the database
SELECT* FROM INFORMATION_SCHEMA.COLUMNS

SELECT
	COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='dim_customers'




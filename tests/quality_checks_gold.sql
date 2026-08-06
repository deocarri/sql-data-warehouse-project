/*
===================================================================
Quality Checks
===================================================================
Script Purpose: 
  This script performs quality checks to validate the integrity,
  consistency, and accuracy of the Gold layer. They ensure: 
  - Uniqueness of surrogate keys in dimension tables. 
  - Referential integrity between fact and dimension tables
  - Validation of relationships in the data model for analytical purposes. 

Usage Notes: 
  - Run these checks after data loading Silver layer. 
  - Investigate and resolve any discrepancies found during the checks. 
===================================================================
*/

-- ===============================================================
-- Checking for 'gold.dim_customers'
-- ===============================================================
-- Check for uniqueness of product key in gold.dim_products
-- Expectation: No Results
select 
	product_key, 
	count(*) as duplicate_count
from gold.dim_products
group by product_key
having count(*) > 1;


-- ===============================================================
-- Checking for 'gold.product_key'
-- ===============================================================
-- Check for uniqueness of Product Key in gold.dim_products
-- Ecpectation: No Results
select 
  product_key,
  count(*) as duplicate_count
  from gold.dim_products
  group by product_key
  having count(*) > 1;

-- ===============================================================
-- Checking for 'gold.fact_sales'
-- ===============================================================
-- Check data model connectivity between fact and dimensions in gold.fact_sales
select * 
from gold.fact_sales f
left join gold.dim_customers c 
on c.customer_key = f.customer_key
left join gold.dim_products p
on p.product_key = f.product_key
where p.product_key is null or c.customer_key is null

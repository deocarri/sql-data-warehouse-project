/*
===========================================================
Quality Checks
===========================================================
Script Purpose: 
  This script performs various quality checks for data consistency, accuracy,
  and standardization across the 'silver' schemas. This includes:
  - Null or duplicate primary keys. 
  - Unwanted spaces in string fields
  - Data standardization and consistency. 
  - Invalid date ranges and orders. 
  - Data consistency between related fields. 

Usage Notes: 
  - These can be used before and after loading the Silver Layer by 
    switching bronze to silver or vice versa. 
  - Investigate and resolve any discrepancies found during the checks.
=============================================================
*/

-- Check for duplicates on cust_info
select 
cst_id, 
count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- Check for unwanted spaces on cust_info
select cst_key 
from bronze.crm_cust_info
where cst_key != trim(cst_key);

-- Data Standardization & Consistency
select distinct cst_gndr
from bronze.crm_cust_info;

-- Check for unwanted spaces on prd_info
select prd_nm
from bronze.crm_prd_info
where prd_nm != trim(prd_nm);

-- Check for nulls or invalid prices on prd_info
select prd_cost
from bronze.crm_prd_info 
where prd_cost < 0 or prd_cost is null;

--Data Standardization & Consistency 
select distinct prd_line 
from bronze.crm_prd_info

-- Check for invalid date orders
select *
from bronze.crm_prd_info
where prd_end_dt < prd_start_dt

-- Touch up silver layer prd_info table
if object_id ('silver.crm_prd_info','U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id int, 
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);

-- Check for issues with dates in sales_details table
select 
nullif(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 
or len(sls_order_dt) != 8
or sls_order_dt > 20500101
or sls_order_dt < 19000101

-- Check for sales price consistency in silver_sales_details table
select distinct
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0

-- Touch up silver layer sales_details table
if object_id ('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;
create table silver.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date, 
	sls_sales int,
	sls_quantity int, 
	sls_price int,
	dwh_create_date datetime2 default getdate()
);

-- Identify out-of-range dates for silver layer cust_az12 table
select distinct 
bdate
from bronze.erp_cust_az12
where bdate < '1924-01-01' or bdate > getdate()

-- Data Standardization & consistency for silver.erp_cust_az12 table
select distinct gen
from bronze.erp_cust_az12

-- Data Standardization & Consistency for silver.erp_loc_a101 table
select distinct cntry
from bronze.erp_loc_a101
order by cntry

-- Check for unwanted spaces in silver layer erp_px_cat_g1v2 table
select * from bronze.erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)

-- Data Standardization & Consistency for silver.erp_px_cat_g1v2
select distinct 
maintenance
from bronze.erp_px_cat_g1v2

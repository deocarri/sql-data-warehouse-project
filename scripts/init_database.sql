/*
============================================================
Create Database and Schemas
============================================================
Script Purpose: 
  This script creates a new database called 'DataWarehouse' if it does not exist. 
  If it exists, it will drop the existing one and create a new, blank database. 
  The script also sets up three schemas: 'bronze', 'silver', and 'gold'. 

WARNING:
  Running this script will drop the entire 'Datawarehouse' database if it exists. 
  All data in the database will be permanently deleted. Proceed with caution 
  and ensure you have proper backups before running this script. 
*/

USE master; 
GO

-- Drop and recreate the 'DataWarehouse' database. 
if exists(select 1 from sys_databases where name = 'DataWarehouse')
begin
  alter DATABASE DataWarehouse set SINGLE_USER with rollback immediate;
  drop DATABASE DataWarehouse;
end;
GO

--Create the 'DataWarehouse' database
create DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
create schema bronze;
GO
create schema silver; 
GO 
create schema gold;
GO

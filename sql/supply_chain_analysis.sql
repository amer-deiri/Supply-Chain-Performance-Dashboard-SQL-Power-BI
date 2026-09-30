-- 1. Create DataBase
CREATE DATABASE SupplyChainDB;
GO
USE SupplyChainDB;
GO

-- 2. Explore Data 
select * from Suppliers
select * from details
SELECT * from OrderStatuses



EXEC sp_help details;
EXEC sp_help OrderStatuses;
EXEC sp_help Suppliers;

-- Number of records in each table
SELECT COUNT(*) AS total_records FROM details;
SELECT COUNT(*) AS total_records FROM OrderStatuses;
SELECT COUNT(*) AS total_records FROM Suppliers;

-- Unique values for order status
SELECT DISTINCT [Order_Status] FROM OrderStatuses;

--  Check NULL values
SELECT COUNT(*) AS null_count 
FROM details WHERE 
Units_Shipped IS NULL;


SELECT COUNT(*) AS null_count 
FROM OrderStatuses
WHERE [Freight_Cost] IS NULL;

--  Check for unrelated requests (missing keys)
SELECT o.[Order_Number]
FROM OrderStatuses o
LEFT JOIN details d ON o.[Order_Number] = d.[Order_Number]
WHERE d.[Order_Number] IS NULL;


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


--  3. (Data Cleaning)

-- Remove duplicate requests
DELETE FROM details
WHERE Order_Number IN (
    SELECT [Order_Number]
    FROM details
    GROUP BY [Order_Number]
    HAVING COUNT(*) > 1
);

-- Replace NULL with 0, for example, in damaged/returns
UPDATE details
SET [Damaged_Units] = 0
WHERE [Damaged_Units] IS NULL;

UPDATE details
SET [Returns] = 0
WHERE [Returns] IS NULL;

-- Perform comprehensive data cleaning (e.g., convert [Order Date] to DATE and [Freight Cost] to DECIMAL) to ensure accurate analysis.
UPDATE OrderStatuses
SET [Order_Date] = TRY_CONVERT(date, [Order_Date], 101)
WHERE TRY_CONVERT(date, [Order_Date], 101) IS NOT NULL;
ALTER TABLE OrderStatuses ALTER COLUMN [Order_Date] DATE;

--  4. Calculate the required KPIs

-- 4.1 Total Orders and Units
SELECT 
    COUNT(DISTINCT d.[Order_Number]) AS Total_Orders,
    SUM(d.[Units_Shipped]) AS Total_Units
FROM details d;

-- 4.2 Lead Time Indicators
SELECT 
    AVG([Raw_Material_Lead_Time_days]) AS Avg_RawMaterial_LeadTime,
    AVG([Manufacturing_Time_days]) AS Avg_Manufacturing_Time,
    AVG([Delivery_Time_days]) AS Avg_Delivery_Time
FROM details;

-- 4.3 Logistics Performance (Freight + On-time Delivery)

-- Average shipping cost
SELECT 
    AVG([Freight_Cost]) AS Avg_FreightCost
FROM OrderStatuses

-- On-time order percentage
SELECT 
    SUM(CASE WHEN [Order_Status] = 'On Time' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS OnTime_Delivery_Rate
FROM OrderStatuses

-- 4.4 Linking tables with suppliers

SELECT 
    s.[Supplier_name],
    COUNT(DISTINCT d.[Order_Number]) AS Orders_Per_Supplier,
    AVG(d.[Raw_Material_Lead_Time_days]) AS Avg_LeadTime,
    AVG(d.[Damaged_Units]) AS Avg_Damaged_Units
FROM details d
JOIN Suppliers s ON d.Supplier = s.[Supplier_id]
GROUP BY s.[Supplier_name]
ORDER BY Orders_Per_Supplier DESC;

-- 5. Execution Plan

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

--
SELECT * 
FROM details d
JOIN OrderStatuses o ON d.[Order_Number] = o.[Order_Number];


-- Overall KPI Summary Table from SQL Query

SELECT 
    (SELECT COUNT(DISTINCT [Order_Number]) FROM details) AS Total_Orders,
    (SELECT SUM([Units_Shipped]) FROM details) AS Total_Units,
    (SELECT AVG([Raw_Material_Lead_Time_days]) FROM details) AS Avg_RawMaterial_LeadTime,
    (SELECT AVG([Manufacturing_Time_days]) FROM details) AS Avg_Manufacturing_Time,
    (SELECT AVG([Delivery_Time_days]) FROM details) AS Avg_Delivery_Time,
    (SELECT AVG([Freight_Cost]) FROM OrderStatuses) AS Avg_FreightCost,
    (SELECT SUM(CASE WHEN [Order_Status] = 'On Time' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) FROM OrderStatuses) AS OnTime_Delivery_Rate;


--SSMS Results Grid

-- Lead Time Indicators (example for grid)
SELECT 
    AVG([Raw_Material_Lead_Time_days]) AS Avg_RawMaterial_LeadTime,
    AVG([Manufacturing_Time_days]) AS Avg_Manufacturing_Time,
    AVG([Delivery_Time_days]) AS Avg_Delivery_Time
FROM details;

-- Average shipping cost
SELECT 
    AVG([Freight_Cost]) AS Avg_FreightCost
FROM OrderStatuses;

-- On-time order percentage
SELECT 
    SUM(CASE WHEN [Order_Status] = 'On Time' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS OnTime_Delivery_Rate
FROM OrderStatuses;
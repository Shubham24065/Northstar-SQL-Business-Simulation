
/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-015
   Department: Database Support / Reporting
   Type: Query Performance & Index Optimization

   Objective:
   Compare a reporting query before and after adding a
   nonclustered index to support order-status and date filters.

   Investigation:
   - Establish baseline performance.
   - Review the actual execution plan.
   - Create a targeted nonclustered index.
   - Rerun the same reporting query.
   - Compare logical reads and execution time.

   Notes:
   - This script does not modify business data.
   - Creating an index changes the database schema.
   - Results depend on data distribution, cache,
     existing indexes and SQL Server configuration.
   ========================================================= */

USE NorthstarRetail;
GO

/* =========================================================
   STEP 1: REVIEW EXISTING INDEXES
   ========================================================= */

SELECT
    i.name AS index_name,
    i.type_desc AS index_type,
    i.is_primary_key,
    i.is_unique
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('dbo.Orders')
ORDER BY i.index_id;
GO

/* =========================================================
   STEP 2: ENABLE PERFORMANCE STATISTICS

   Run the baseline query below before creating the index.
   Enable Actual Execution Plan in SSMS (Ctrl + M).
   ========================================================= */

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

/* =========================================================
   STEP 3: BASELINE QUERY — BEFORE INDEX

   Record:
   - Logical reads for Orders
   - CPU time
   - Elapsed time
   - Execution plan operators
   ========================================================= */

SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.customer_id,
    o.sales_employee_id
FROM dbo.Orders AS o
WHERE o.order_status = 'Completed'
  AND o.order_date >= '2026-01-01'
  AND o.order_date < '2026-07-01'
ORDER BY o.order_date DESC, o.order_id DESC;
GO

/* =========================================================
   STEP 4: CREATE TARGETED NONCLUSTERED INDEX

   Run this step only AFTER capturing the baseline.

   The index key supports equality filtering on status,
   then date-range filtering and date ordering.

   The INCLUDE columns cover the additional output fields.
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.Orders')
      AND name = 'IX_Orders_Status_Date_OrderID'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_Status_Date_OrderID
    ON dbo.Orders
    (
        order_status,
        order_date DESC,
        order_id DESC
    )
    INCLUDE
    (
        customer_id,
        sales_employee_id
    );
END;
GO

/* =========================================================
   STEP 5: OPTIMIZED QUERY — AFTER INDEX

   Execute the SAME query again.
   Do not change its filters or selected columns.
   ========================================================= */

SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.customer_id,
    o.sales_employee_id
FROM dbo.Orders AS o
WHERE o.order_status = 'Completed'
  AND o.order_date >= '2026-01-01'
  AND o.order_date < '2026-07-01'
ORDER BY o.order_date DESC, o.order_id DESC;
GO

/* =========================================================
   STEP 6: CONFIRM INDEX DEFINITION
   ========================================================= */

SELECT
    i.name AS index_name,
    i.type_desc AS index_type,
    ic.key_ordinal,
    ic.is_included_column,
    c.name AS column_name
FROM sys.indexes AS i
JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id
   AND i.index_id = ic.index_id
JOIN sys.columns AS c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('dbo.Orders')
  AND i.name = 'IX_Orders_Status_Date_OrderID'
ORDER BY
    ic.is_included_column,
    ic.key_ordinal,
    ic.index_column_id;
GO

/* =========================================================
   STEP 7: DISABLE PERFORMANCE STATISTICS
   ========================================================= */

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

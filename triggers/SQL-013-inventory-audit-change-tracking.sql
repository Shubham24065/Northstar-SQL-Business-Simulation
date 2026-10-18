
/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-013
   Department: Inventory Operations / Database Support
   Type: Inventory Audit & Change Tracking

   Business Request:
   Automatically record changes to inventory quantities
   for traceability and operational investigations.

   Implementation:
   1. Create inventory audit table.
   2. Create an AFTER UPDATE trigger.
   3. Record old and new stock quantities.
   4. Capture the change amount, time and database login.
   5. Support multi-row UPDATE operations.

   Notes:
   - Only actual quantity changes are recorded.
   - The trigger is set-based.
   - Audit rows participate in the same transaction
     as the inventory update.
   ========================================================= */

USE NorthstarRetail;
GO

/* =========================================================
   STEP 1: CREATE INVENTORY AUDIT TABLE
   ========================================================= */

IF OBJECT_ID('dbo.InventoryAudit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.InventoryAudit
    (
        audit_id BIGINT IDENTITY(1,1) PRIMARY KEY,

        inventory_id INT NOT NULL,
        product_id INT NOT NULL,

        warehouse_location VARCHAR(50) NOT NULL,

        old_quantity INT NOT NULL,
        new_quantity INT NOT NULL,
        quantity_change INT NOT NULL,

        change_type VARCHAR(20) NOT NULL,

        changed_at DATETIME2 NOT NULL
            DEFAULT SYSDATETIME(),

        changed_by SYSNAME NOT NULL
            DEFAULT ORIGINAL_LOGIN()
    );
END;
GO

/* =========================================================
   STEP 2: CREATE INVENTORY UPDATE TRIGGER
   ========================================================= */

CREATE OR ALTER TRIGGER dbo.trg_InventoryAudit
ON dbo.Inventory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    /*
       SQL Server provides two logical tables:

       inserted = values after the UPDATE
       deleted  = values before the UPDATE

       Joining by inventory_id supports multi-row updates.
    */

    INSERT INTO dbo.InventoryAudit
    (
        inventory_id,
        product_id,
        warehouse_location,
        old_quantity,
        new_quantity,
        quantity_change,
        change_type,
        changed_at,
        changed_by
    )
    SELECT
        i.inventory_id,
        i.product_id,
        i.warehouse_location,

        d.quantity_in_stock,
        i.quantity_in_stock,

        i.quantity_in_stock - d.quantity_in_stock,

        CASE
            WHEN i.quantity_in_stock > d.quantity_in_stock
                THEN 'Stock Increase'
            ELSE 'Stock Decrease'
        END,

        SYSDATETIME(),
        ORIGINAL_LOGIN()

    FROM inserted AS i

    JOIN deleted AS d
        ON i.inventory_id = d.inventory_id

    WHERE i.quantity_in_stock <> d.quantity_in_stock;

END;
GO

/* =========================================================
   STEP 3: REVIEW RECENT INVENTORY CHANGES
   ========================================================= */

SELECT TOP (100)
    a.audit_id,
    a.inventory_id,
    a.product_id,
    p.product_name,
    a.warehouse_location,
    a.old_quantity,
    a.new_quantity,
    a.quantity_change,
    a.change_type,
    a.changed_at,
    a.changed_by

FROM dbo.InventoryAudit AS a

JOIN dbo.Products AS p
    ON a.product_id = p.product_id

ORDER BY
    a.changed_at DESC,
    a.audit_id DESC;
GO

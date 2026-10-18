
/*
    NORTHSTAR RETAIL
    SQL BUSINESS OPERATIONS SIMULATION

    Ticket: SQL-011
    Department: Operations
    Type: Inventory Restocking Stored Procedure

    Objective:
    Provide a reusable, parameterized inventory report
    identifying warehouse stock at or below reorder levels.

    Parameters:
    @Warehouse - Optional warehouse location
    @CategoryID - Optional product category ID

    Both parameters default to NULL (all locations/categories).

    This procedure is read-only and does not update inventory.
*/

USE NorthstarRetail;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetInventoryRestockingReport
    @Warehouse VARCHAR(50) = NULL,
    @CategoryID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    /* Normalize optional warehouse input */
    SET @Warehouse = NULLIF(LTRIM(RTRIM(@Warehouse)), '');

    /* Validate warehouse */
    IF @Warehouse IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM Inventory
           WHERE warehouse_location = @Warehouse
       )
    BEGIN
        THROW 50001, 'Invalid warehouse location.', 1;
    END;

    /* Validate category */
    IF @CategoryID IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM Categories
           WHERE category_id = @CategoryID
       )
    BEGIN
        THROW 50002, 'Invalid category ID.', 1;
    END;

    /* Inventory restocking report */
    SELECT
        p.product_id,
        p.product_name,
        c.category_name,
        i.warehouse_location AS warehouse,
        i.quantity_in_stock AS current_stock,
        i.reorder_level,

        CASE
            WHEN i.quantity_in_stock < i.reorder_level
            THEN i.reorder_level - i.quantity_in_stock
            ELSE 0
        END AS quantity_shortage,

        CASE
            WHEN i.quantity_in_stock = 0
                THEN 'Out of Stock'
            WHEN i.quantity_in_stock < i.reorder_level
                THEN 'Below Reorder Level'
            ELSE 'At Reorder Level'
        END AS inventory_status

    FROM Inventory AS i

    JOIN Products AS p
        ON i.product_id = p.product_id

    JOIN Categories AS c
        ON p.category_id = c.category_id

    WHERE i.quantity_in_stock <= i.reorder_level
      AND (
          @Warehouse IS NULL
          OR i.warehouse_location = @Warehouse
      )
      AND (
          @CategoryID IS NULL
          OR p.category_id = @CategoryID
      )

    ORDER BY
        quantity_shortage DESC,
        i.warehouse_location,
        p.product_id;
END;
GO


/*
    NORTHSTAR RETAIL
    SQL BUSINESS OPERATIONS SIMULATION

    Ticket: SQL-012
    Department: Sales Operations / Database Support
    Requested By: Operations Manager
    Priority: High
    Type: Transaction Management

    Business Request:
    Process an existing order safely by validating inventory,
    deducting stock, and updating the order status.

    Rules:
    - Only orders with status 'Processing' are eligible.
    - Every ordered product must have sufficient inventory.
    - Inventory is deducted from one specified warehouse.
    - All changes must succeed or fail together.
    - Completed or cancelled orders cannot be reprocessed.

    SQL Concepts:
    Stored Procedures, Transactions, TRY/CATCH,
    THROW, XACT_STATE(), Locking, Conditional Updates
*/

USE NorthstarRetail;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ProcessOrderSafely
    @OrderID INT,
    @Warehouse VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @Warehouse = NULLIF(LTRIM(RTRIM(@Warehouse)), '');

    IF @Warehouse IS NULL
        THROW 50001, 'A warehouse must be specified.', 1;

    BEGIN TRY

        BEGIN TRANSACTION;

        /* Step 1: Validate and lock the order */

        IF NOT EXISTS
        (
            SELECT 1
            FROM Orders WITH (UPDLOCK, HOLDLOCK)
            WHERE order_id = @OrderID
              AND order_status = 'Processing'
        )
        BEGIN
            THROW 50002,
                'Order does not exist or is not eligible for processing.',
                1;
        END;

        /* Step 2: Confirm the order has items */

        IF NOT EXISTS
        (
            SELECT 1
            FROM OrderItems
            WHERE order_id = @OrderID
        )
        BEGIN
            THROW 50003,
                'Order contains no items.',
                1;
        END;

        /*
            Step 3: Aggregate required quantities per product.

            This handles orders containing multiple line items
            for the same product.
        */

        CREATE TABLE #RequiredStock
        (
            product_id INT NOT NULL PRIMARY KEY,
            required_quantity INT NOT NULL
        );

        INSERT INTO #RequiredStock
        (
            product_id,
            required_quantity
        )
        SELECT
            product_id,
            SUM(quantity)
        FROM OrderItems
        WHERE order_id = @OrderID
        GROUP BY product_id;

        /* Step 4: Validate available warehouse inventory */

        IF EXISTS
        (
            SELECT 1
            FROM #RequiredStock AS r

            LEFT JOIN Inventory AS i WITH (UPDLOCK, HOLDLOCK)
                ON r.product_id = i.product_id
               AND i.warehouse_location = @Warehouse

            GROUP BY
                r.product_id,
                r.required_quantity

            HAVING
                COALESCE(SUM(i.quantity_in_stock), 0)
                < r.required_quantity
        )
        BEGIN
            THROW 50004,
                'Insufficient inventory for one or more products.',
                1;
        END;

        /*
            Step 5: Deduct stock.

            Assumption: One inventory record per product
            per warehouse. Confirm this against the schema.
        */

        UPDATE i
        SET
            i.quantity_in_stock =
                i.quantity_in_stock - r.required_quantity,

            i.last_updated = SYSDATETIME()

        FROM Inventory AS i

        JOIN #RequiredStock AS r
            ON i.product_id = r.product_id

        WHERE i.warehouse_location = @Warehouse
          AND i.quantity_in_stock >= r.required_quantity;

        /* Every required product must have been updated */

        IF @@ROWCOUNT <>
        (
            SELECT COUNT(*)
            FROM #RequiredStock
        )
        BEGIN
            THROW 50005,
                'Inventory update did not affect all required products.',
                1;
        END;

        /* Step 6: Mark order as completed */

        UPDATE Orders
        SET order_status = 'Completed'
        WHERE order_id = @OrderID
          AND order_status = 'Processing';

        IF @@ROWCOUNT <> 1
        BEGIN
            THROW 50006,
                'Order status update failed.',
                1;
        END;

        COMMIT TRANSACTION;

        SELECT
            @OrderID AS order_id,
            @Warehouse AS warehouse,
            'Completed' AS order_status,
            'Order processed successfully.' AS result_message;

    END TRY

    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END;
GO

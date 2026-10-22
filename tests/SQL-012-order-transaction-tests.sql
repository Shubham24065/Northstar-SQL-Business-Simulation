USE NorthstarRetail;
GO

WITH RequiredStock AS
(
    SELECT
        o.order_id,
        oi.product_id,
        SUM(oi.quantity) AS required_quantity
    FROM dbo.Orders o
    JOIN dbo.OrderItems oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Processing'
    GROUP BY o.order_id, oi.product_id
),
StockCheck AS
(
    SELECT
        r.order_id,
        r.product_id,
        r.required_quantity,
        COALESCE(SUM(i.quantity_in_stock), 0) AS available_quantity
    FROM RequiredStock r
    LEFT JOIN dbo.Inventory i
        ON r.product_id = i.product_id
       AND i.warehouse_location = 'Toronto'
    GROUP BY
        r.order_id, r.product_id, r.required_quantity
)
SELECT TOP (10)
    order_id
FROM StockCheck
GROUP BY order_id
HAVING SUM(
    CASE
        WHEN available_quantity < required_quantity THEN 1
        ELSE 0
    END
) = 0
ORDER BY order_id;


/* TEST - 2 */

USE NorthstarRetail;
GO

DECLARE @OrderID INT = 153;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Run the stored procedure
    EXEC dbo.usp_ProcessOrderSafely
        @OrderID = @OrderID,
        @Warehouse = 'Toronto';

    -- Verify order status during the transaction
    SELECT
        order_id,
        order_status AS status_during_transaction
    FROM dbo.Orders
    WHERE order_id = @OrderID;

    -- Undo the test
    ROLLBACK TRANSACTION;

    -- Verify original status restored
    SELECT
        order_id,
        order_status AS status_after_rollback
    FROM dbo.Orders
    WHERE order_id = @OrderID;

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT ERROR_MESSAGE() AS error_message;
END CATCH;
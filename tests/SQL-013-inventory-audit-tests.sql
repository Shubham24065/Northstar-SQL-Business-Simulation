USE NorthstarRetail;
GO

DECLARE @InventoryID INT;

SELECT TOP (1)
    @InventoryID = inventory_id
FROM dbo.Inventory
WHERE quantity_in_stock >= 10
ORDER BY inventory_id;

IF @InventoryID IS NULL
    THROW 50010, 'No suitable inventory row found.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Update inventory to activate the trigger
    UPDATE dbo.Inventory
    SET
        quantity_in_stock = quantity_in_stock - 10,
        last_updated = SYSDATETIME()
    WHERE inventory_id = @InventoryID;

    -- Check the automatically generated audit record
    SELECT TOP (5)
        audit_id,
        inventory_id,
        old_quantity,
        new_quantity,
        quantity_change,
        change_type,
        changed_at,
        changed_by
    FROM dbo.InventoryAudit
    WHERE inventory_id = @InventoryID
    ORDER BY audit_id DESC;

    -- Restore original data
    ROLLBACK TRANSACTION;

    PRINT 'Test completed; inventory and audit changes rolled back.';

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
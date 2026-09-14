USE NorthstarRetail;
GO

/* =========================================================
   NORTHSTAR RETAIL
   DATABASE VERIFICATION

   Purpose:
   Verify that the simulation database was created
   and populated successfully.
   ========================================================= */


/* =========================
   TABLE ROW COUNTS
   ========================= */

SELECT 'Categories' AS table_name, COUNT(*) AS row_count
FROM Categories

UNION ALL

SELECT 'Suppliers', COUNT(*)
FROM Suppliers

UNION ALL

SELECT 'Employees', COUNT(*)
FROM Employees

UNION ALL

SELECT 'Products', COUNT(*)
FROM Products

UNION ALL

SELECT 'Customers', COUNT(*)
FROM Customers

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders

UNION ALL

SELECT 'OrderItems', COUNT(*)
FROM OrderItems

UNION ALL

SELECT 'Payments', COUNT(*)
FROM Payments

UNION ALL

SELECT 'Shipments', COUNT(*)
FROM Shipments

UNION ALL

SELECT 'Inventory', COUNT(*)
FROM Inventory;

GO


/* =========================
   ORDER STATUS CHECK
   ========================= */

SELECT
    order_status,
    COUNT(*) AS order_count
FROM Orders
GROUP BY order_status
ORDER BY order_count DESC;

GO


/* =========================
   PAYMENT STATUS CHECK
   ========================= */

SELECT
    payment_status,
    COUNT(*) AS payment_count
FROM Payments
GROUP BY payment_status
ORDER BY payment_count DESC;

GO


/* =========================
   SHIPMENT STATUS CHECK
   ========================= */

SELECT
    shipment_status,
    COUNT(*) AS shipment_count
FROM Shipments
GROUP BY shipment_status
ORDER BY shipment_count DESC;

GO


/* =========================
   INVENTORY HEALTH CHECK
   ========================= */

SELECT
    warehouse_location,
    COUNT(*) AS products_stored,
    SUM(quantity_in_stock) AS total_units,
    SUM(
        CASE
            WHEN quantity_in_stock <= reorder_level
            THEN 1
            ELSE 0
        END
    ) AS products_at_or_below_reorder_level
FROM Inventory
GROUP BY warehouse_location;

GO
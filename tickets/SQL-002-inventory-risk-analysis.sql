/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-002
   Department: Operations
   Requested By: Operations Manager
   Priority: High
   Type: Inventory Risk Analysis

   Business Request:
   Identify active products that are currently at risk of
   running out of stock and may require attention during the
   next supplier purchase cycle.

   Required Output:
   - Product ID
   - Product name
   - Category name
   - Supplier name
   - Total stock across all warehouses
   - Combined reorder threshold
   - Number of warehouses at or below reorder level
   - Stock risk classification

   Business Rules:
   - Include active products only.
   - Evaluate inventory across all warehouses.
   - Return only products where combined stock is at or below
     the combined reorder threshold.
   - Risk classifications:
       CRITICAL = Total stock is 0
       HIGH     = Total stock is greater than 0 and at or below
                  50% of the combined reorder threshold
       MEDIUM   = Total stock is above 50% and at or below
                  the combined reorder threshold
   - Display the most critical inventory risks first.

   ========================================================= */

USE NorthstarRetail;
GO

/* =========================================================
   SOLUTION
   ========================================================= */

Select p.product_id, 
	   p.product_name, 
	   c.category_name, 
	   s.supplier_name, 
	   SUM(i.quantity_in_stock) AS total_stock,
	   SUM(i.reorder_level) AS combined_reorder_threshold,

	   SUM(CASE
	   WHEN i.quantity_in_stock <=i.reorder_level THEN 1
	   WHEN i.quantity_in_stock > i.reorder_level THEN 0
	   END) AS warehouses_at_risk,

	   CASE
	   WHEN SUM(i.quantity_in_stock) = 0 THEN 'Critical'
	   WHEN SUM(i.quantity_in_stock) > 0 AND SUM(i.quantity_in_stock) <= 0.5*SUM(i.reorder_level) THEN 'HIGH'
	   WHEN SUM(i.quantity_in_stock) > 0.5*SUM(i.reorder_level) AND SUM(i.quantity_in_stock) <=SUM(i.reorder_level) THEN 'Medium'
	   END AS stock_risk


FROM Products AS p
JOIN Categories AS c ON p.category_id = c.category_id
JOIN Suppliers AS s ON p.supplier_id = s.supplier_id
JOIN Inventory AS i ON p.product_id = i.product_id

WHERE p.product_status = 'ACTIVE'

GROUP BY p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name

HAVING SUM(i.quantity_in_stock) <= SUM(i.reorder_level)

ORDER BY
CASE ( CASE
	   WHEN SUM(i.quantity_in_stock) = 0 THEN 'Critical'
	   WHEN SUM(i.quantity_in_stock) > 0 AND SUM(i.quantity_in_stock) <= 0.5*SUM(i.reorder_level) THEN 'HIGH'
	   WHEN SUM(i.quantity_in_stock) > 0.5*SUM(i.reorder_level) AND SUM(i.quantity_in_stock) <=SUM(i.reorder_level) THEN 'Medium'
	   END)
        WHEN 'Critical' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'Medium' THEN 3
    END;
USE NorthstarRetail;
GO

SELECT TOP (20) *
FROM dbo.vw_ManagementOrderSummary
ORDER BY order_date DESC;

/* TEST 2 */

SELECT
    (SELECT COUNT(*) FROM dbo.Orders) AS total_orders,
    (SELECT COUNT(*) FROM dbo.vw_ManagementOrderSummary) AS view_rows,
    (SELECT COUNT(DISTINCT order_id)
     FROM dbo.vw_ManagementOrderSummary) AS unique_orders;


/* TEST 3 */
SELECT
    province,
    COUNT(*) AS completed_orders,
    CAST(SUM(order_total) AS DECIMAL(18,2)) AS total_revenue
FROM dbo.vw_ManagementOrderSummary
WHERE order_status = 'Completed'
GROUP BY province
ORDER BY total_revenue DESC;

/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-014
   Department: Management / Sales Operations
   Requested By: Management Reporting Team
   Priority: Normal
   Type: Management Order Summary View

   Business Request:
   Create a reusable view that summarizes customer orders,
   order values, item quantities and payment information.

   Business Rules:
   - Include all orders regardless of status.
   - Return exactly one row per order.
   - Calculate order totals after discounts.
   - Preserve orders without payment records.
   - Prevent duplicate totals from multiple joins.
   - Support filtering and reporting through the view.

   SQL Concepts:
   CREATE OR ALTER VIEW, CTEs, JOINs, GROUP BY,
   Aggregates, CASE, COALESCE, NULL handling
   ========================================================= */

USE NorthstarRetail;
GO

CREATE OR ALTER VIEW dbo.vw_ManagementOrderSummary
AS

WITH OrderItemSummary AS
(
    SELECT
        oi.order_id,

        SUM(oi.quantity) AS total_items,

        CAST(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100.0)
            ) AS DECIMAL(18,2)
        ) AS order_total

    FROM dbo.OrderItems AS oi

    GROUP BY oi.order_id
),

PaymentSummary AS
(
    SELECT
        p.order_id,

        CASE
            WHEN MIN(p.payment_status) = MAX(p.payment_status)
                THEN MIN(p.payment_status)
            ELSE 'Mixed'
        END AS payment_status,

        CAST(
            SUM(
                CASE
                    WHEN p.payment_status = 'Completed'
                        THEN p.amount
                    ELSE 0
                END
            ) AS DECIMAL(18,2)
        ) AS total_paid

    FROM dbo.Payments AS p

    GROUP BY p.order_id
)

SELECT
    o.order_id,
    o.order_date,
    o.order_status,

    c.customer_id,

    CONCAT(
        c.first_name,
        ' ',
        c.last_name
    ) AS customer_name,

    c.province,

    COALESCE(
        oi.total_items, 0
    ) AS total_items,

    COALESCE(
        oi.order_total, 0
    ) AS order_total,

    COALESCE(
        ps.payment_status, 'No Payment'
    ) AS payment_status,

    COALESCE(
        ps.total_paid, 0
    ) AS total_paid

FROM dbo.Orders AS o

JOIN dbo.Customers AS c
    ON o.customer_id = c.customer_id

LEFT JOIN OrderItemSummary AS oi
    ON o.order_id = oi.order_id

LEFT JOIN PaymentSummary AS ps
    ON o.order_id = ps.order_id;
GO

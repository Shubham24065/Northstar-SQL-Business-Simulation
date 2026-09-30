/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-003
   Department: Finance
   Requested By: Finance Manager
   Priority: High
   Type: Revenue Reconciliation Investigation

   Business Request:
   Investigate the discrepancy between revenue calculated
   from completed order line items and successfully completed
   payments during the most recent 12 months of available
   order data.

   Required Output:

   Result 1:
   - Completed order revenue
   - Completed payment amount
   - Revenue difference
   - Number of affected orders

   Result 2:
   - Order ID
   - Order date
   - Order revenue
   - Completed payment amount
   - Payment status
   - Difference

   Business Rules:
   - Include completed orders only.
   - Use the most recent 12 months of available order data.
   - Order revenue must reflect line-item discounts.
   - Only Completed payments represent successfully
     collected revenue.
   - Both calculations must use the same completed orders
     and reporting period.

   Revenue Formula:
   quantity * unit_price * (1 - discount_percent / 100)

   ========================================================= */

USE NorthstarRetail;
GO


/* =========================================================
   BUILD ORDER-LEVEL RECONCILIATION
   ========================================================= */

WITH OrderRevenue AS
(
    SELECT
        o.order_id,
        o.order_date,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ) AS order_revenue

    FROM Orders AS o

    JOIN OrderItems AS oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Completed'
      AND o.order_date >= DATEADD(
            MONTH,
            -12,
            (SELECT MAX(order_date) FROM Orders)
          )

    GROUP BY
        o.order_id,
        o.order_date
),

PaymentSummary AS
(
    SELECT
        order_id,

        SUM(
            CASE
                WHEN payment_status = 'Completed'
                THEN amount
                ELSE 0
            END
        ) AS completed_payment_amount,

        MAX(payment_status) AS payment_status

    FROM Payments

    GROUP BY order_id
)

SELECT
    o.order_id,
    o.order_date,

    CAST(
        o.order_revenue
        AS DECIMAL(18,2)
    ) AS order_revenue,

    CAST(
        COALESCE(p.completed_payment_amount, 0)
        AS DECIMAL(18,2)
    ) AS completed_payment_amount,

    COALESCE(
        p.payment_status,
        'Missing'
    ) AS payment_status,

    CAST(
        o.order_revenue
        - COALESCE(p.completed_payment_amount, 0)
        AS DECIMAL(18,2)
    ) AS difference

INTO #RevenueReconciliation

FROM OrderRevenue AS o

LEFT JOIN PaymentSummary AS p
    ON o.order_id = p.order_id;


/* =========================================================
   RESULT 1 — RECONCILIATION SUMMARY
   ========================================================= */

SELECT
    CAST(
        SUM(order_revenue)
        AS DECIMAL(18,2)
    ) AS completed_order_revenue,

    CAST(
        SUM(completed_payment_amount)
        AS DECIMAL(18,2)
    ) AS completed_payment_amount,

    CAST(
        SUM(order_revenue)
        - SUM(completed_payment_amount)
        AS DECIMAL(18,2)
    ) AS revenue_difference,

    SUM(
        CASE
            WHEN ABS(difference) > 0.01
            THEN 1
            ELSE 0
        END
    ) AS affected_orders

FROM #RevenueReconciliation;


/* =========================================================
   RESULT 2 — AFFECTED ORDERS
   ========================================================= */

SELECT
    order_id,
    order_date,
    order_revenue,
    completed_payment_amount AS payment_amount,
    payment_status,
    difference

FROM #RevenueReconciliation

WHERE ABS(difference) > 0.01

ORDER BY
    ABS(difference) DESC,
    order_id;


/* =========================================================
   CLEANUP
   ========================================================= */

DROP TABLE #RevenueReconciliation;

GO
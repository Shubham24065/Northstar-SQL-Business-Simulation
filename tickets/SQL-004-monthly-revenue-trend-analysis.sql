/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-004
   Department: Management
   Requested By: Management Team
   Priority: Normal
   Type: Monthly Revenue Trend Analysis

   Business Request:
   Analyze monthly sales revenue from completed orders to
   understand how business performance changes over time and
   identify periods of revenue growth or decline.

   Required Output:
   - Month
   - Number of completed orders
   - Total units sold
   - Total revenue
   - Average order value
   - Previous month's revenue
   - Revenue change from previous month
   - Month-over-month growth percentage

   Business Rules:
   - Include completed orders only.
   - Revenue must be calculated from order item data.
   - Revenue must reflect line-item discounts.
   - Average order value represents total monthly revenue
     divided by the number of completed orders.
   - Previous-month revenue must be based on chronological
     monthly order.
   - Revenue change is calculated as:
       Current Month Revenue - Previous Month Revenue
   - Month-over-month growth percentage is calculated as:
       ((Current Revenue - Previous Revenue)
        / Previous Revenue) * 100
   - Division by zero must be handled safely.
   - Results must be ordered chronologically.

   Revenue Formula:
   quantity * unit_price * (1 - discount_percent / 100)

   ========================================================= */

USE NorthstarRetail;
GO


/* =========================================================
   SOLUTION
   ========================================================= */

WITH MonthlyRevenue AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS revenue_month,

        COUNT(DISTINCT o.order_id) AS completed_orders,

        SUM(oi.quantity) AS total_units,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ) AS total_revenue,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        )
        / COUNT(DISTINCT o.order_id) AS avg_order_value

    FROM Orders AS o

    JOIN OrderItems AS oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Completed'

    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
),

RevenueComparison AS
(
    SELECT
        revenue_month,
        completed_orders,
        total_units,
        total_revenue,
        avg_order_value,

        LAG(total_revenue) OVER (
            ORDER BY revenue_month
        ) AS previous_month_revenue

    FROM MonthlyRevenue
)

SELECT
    revenue_month,
    completed_orders,
    total_units,

    CAST(
        total_revenue AS DECIMAL(18,2)
    ) AS total_revenue,

    CAST(
        avg_order_value AS DECIMAL(18,2)
    ) AS avg_order_value,

    CAST(
        previous_month_revenue AS DECIMAL(18,2)
    ) AS previous_month_revenue,

    CAST(
        total_revenue - previous_month_revenue
        AS DECIMAL(18,2)
    ) AS revenue_change,

    CAST(
        (
            (total_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100
        AS DECIMAL(10,2)
    ) AS mom_growth_percentage

FROM RevenueComparison

ORDER BY revenue_month;

GO
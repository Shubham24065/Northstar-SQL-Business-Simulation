
/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-009
   Department: Sales / Management
   Requested By: Regional Sales Manager
   Priority: Normal
   Type: Regional Sales Performance Analysis

   Business Request:
   Analyze completed-order sales performance across Canadian
   provinces to identify the strongest revenue-generating
   regions and compare customer purchasing activity.

   Required Output:
   - Province
   - Total purchasing customers
   - Completed orders
   - Total units sold
   - Total revenue
   - Average order value
   - Revenue contribution percentage
   - Revenue rank

   Business Rules:
   - Include completed orders only.
   - Use the customer's province as the sales region.
   - Revenue must reflect line-item discounts.
   - Count distinct customers and completed orders.
   - Average order value = revenue / completed orders.
   - Revenue contribution uses total qualifying revenue.
   - Provinces with equal revenue receive equal ranks.
   - Sort regions by revenue descending.

   Revenue Formula:
   quantity * unit_price * (1 - discount_percent / 100)

   ========================================================= */

USE NorthstarRetail;
GO

/* =========================================================
   SOLUTION
   ========================================================= */

WITH RegionalSales AS
(
    SELECT
        c.province,

        COUNT(DISTINCT c.customer_id)
            AS total_customers,

        COUNT(DISTINCT o.order_id)
            AS completed_orders,

        SUM(oi.quantity)
            AS total_units_sold,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ) AS total_revenue

    FROM Customers AS c

    JOIN Orders AS o
        ON c.customer_id = o.customer_id

    JOIN OrderItems AS oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Completed'

    GROUP BY c.province
),

RegionalPerformance AS
(
    SELECT
        province,
        total_customers,
        completed_orders,
        total_units_sold,
        total_revenue,

        total_revenue
        / NULLIF(completed_orders, 0)
            AS avg_order_value,

        SUM(total_revenue) OVER ()
            AS company_revenue,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM RegionalSales
)

SELECT
    province,
    total_customers,
    completed_orders,
    total_units_sold,

    CAST(
        total_revenue AS DECIMAL(18,2)
    ) AS total_revenue,

    CAST(
        avg_order_value AS DECIMAL(18,2)
    ) AS avg_order_value,

    CAST(
        100.0 * total_revenue
        / NULLIF(company_revenue, 0)
        AS DECIMAL(10,2)
    ) AS revenue_contribution_pct,

    revenue_rank

FROM RegionalPerformance

ORDER BY
    revenue_rank,
    province;

GO

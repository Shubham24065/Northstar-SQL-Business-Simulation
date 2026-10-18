
/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-010
   Department: Sales / Management
   Requested By: Sales Manager
   Priority: Normal
   Type: Product Ranking Within Categories

   Business Request:
   Identify the highest-performing products within each
   product category based on completed-order revenue.

   Required Output:
   - Category
   - Product ID
   - Product name
   - Completed orders
   - Total units sold
   - Total revenue
   - Revenue rank within category
   - Dense revenue rank within category
   - Category revenue contribution percentage

   Business Rules:
   - Include completed orders only.
   - Calculate revenue after line-item discounts.
   - Retain products without completed sales.
   - Rank products independently within each category.
   - Products with equal revenue receive equal ranks.
   - Display products in category and revenue order.

   Revenue Formula:
   quantity * unit_price * (1 - discount_percent / 100)

   ========================================================= */

USE NorthstarRetail;
GO

/* =========================================================
   SOLUTION
   ========================================================= */

WITH ProductRevenue AS
(
    SELECT
        p.product_id,
        p.product_name,
        c.category_id,
        c.category_name,

        COUNT(DISTINCT
            CASE
                WHEN o.order_status = 'Completed'
                THEN o.order_id
            END
        ) AS completed_orders,

        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Completed'
                    THEN oi.quantity
                    ELSE 0
                END
            ), 0
        ) AS total_units_sold,

        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Completed'
                    THEN oi.quantity * oi.unit_price
                         * (1 - oi.discount_percent / 100.0)
                    ELSE 0
                END
            ), 0
        ) AS total_revenue

    FROM Products AS p

    JOIN Categories AS c
        ON p.category_id = c.category_id

    LEFT JOIN OrderItems AS oi
        ON p.product_id = oi.product_id

    LEFT JOIN Orders AS o
        ON oi.order_id = o.order_id

    GROUP BY
        p.product_id,
        p.product_name,
        c.category_id,
        c.category_name
),

CategoryRanking AS
(
    SELECT
        category_id,
        category_name,
        product_id,
        product_name,
        completed_orders,
        total_units_sold,
        total_revenue,

        RANK() OVER (
            PARTITION BY category_id
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        DENSE_RANK() OVER (
            PARTITION BY category_id
            ORDER BY total_revenue DESC
        ) AS dense_revenue_rank,

        SUM(total_revenue) OVER (
            PARTITION BY category_id
        ) AS category_revenue

    FROM ProductRevenue
)

SELECT
    category_name,
    product_id,
    product_name,
    completed_orders,
    total_units_sold,

    CAST(
        total_revenue AS DECIMAL(18,2)
    ) AS total_revenue,

    revenue_rank,
    dense_revenue_rank,

    CAST(
        100.0 * total_revenue
        / NULLIF(category_revenue, 0)
        AS DECIMAL(10,2)
    ) AS category_revenue_contribution_pct

FROM CategoryRanking

ORDER BY
    category_name,
    revenue_rank,
    product_id;

GO

/*
    NORTHSTAR RETAIL
    SQL BUSINESS OPERATIONS SIMULATION

    Ticket: SQL-006
    Department: Sales / Management
    Type: Product Sales Performance Analysis

    Objective:
    Analyze product-level sales performance using completed
    orders, including revenue contribution and product rankings.

    Products without completed sales are retained in the report.
*/

USE NorthstarRetail;
GO


WITH ProductSales AS
(
    SELECT
        p.product_id,
        p.product_name,
        c.category_name,
        s.supplier_name,

        COUNT(DISTINCT o.order_id) AS completed_orders,

        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Completed'
                    THEN oi.quantity
                    ELSE 0
                END
            ),
            0
        ) AS total_units_sold,

        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Completed'
                    THEN oi.quantity
                         * oi.unit_price
                         * (1 - oi.discount_percent / 100.0)
                    ELSE 0
                END
            ),
            0
        ) AS total_revenue,

        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Completed'
                    THEN oi.quantity
                         * oi.unit_price
                         * (1 - oi.discount_percent / 100.0)
                    ELSE 0
                END
            )
            /
            NULLIF(
                SUM(
                    CASE
                        WHEN o.order_status = 'Completed'
                        THEN oi.quantity
                        ELSE 0
                    END
                ),
                0
            ),
            0
        ) AS avg_selling_price

    FROM Products AS p

    LEFT JOIN OrderItems AS oi
        ON p.product_id = oi.product_id

    LEFT JOIN Orders AS o
        ON oi.order_id = o.order_id

    LEFT JOIN Categories AS c
        ON p.category_id = c.category_id

    LEFT JOIN Suppliers AS s
        ON p.supplier_id = s.supplier_id

    GROUP BY
        p.product_id,
        p.product_name,
        c.category_name,
        s.supplier_name
),

ProductPerformance AS
(
    SELECT
        product_id,
        product_name,
        category_name,
        supplier_name,
        completed_orders,
        total_units_sold,
        total_revenue,
        avg_selling_price,

        SUM(total_revenue) OVER ()
            AS company_revenue,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS overall_revenue_rank,

        RANK() OVER (
            PARTITION BY category_name
            ORDER BY total_revenue DESC
        ) AS category_revenue_rank

    FROM ProductSales
)

SELECT
    product_id,
    product_name,
    category_name,
    supplier_name,
    completed_orders,
    total_units_sold,

    CAST(
        total_revenue AS DECIMAL(18,2)
    ) AS total_revenue,

    CAST(
        avg_selling_price AS DECIMAL(18,2)
    ) AS avg_selling_price,

    CAST(
        (
            total_revenue
            / NULLIF(company_revenue, 0)
        ) * 100
        AS DECIMAL(10,2)
    ) AS company_revenue_percentage,

    overall_revenue_rank,
    category_revenue_rank

FROM ProductPerformance

ORDER BY
    overall_revenue_rank,
    product_id;

GO
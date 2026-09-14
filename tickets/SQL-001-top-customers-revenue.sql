/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-001
   Department: Sales
   Requested By: Sales Manager
   Priority: Normal
   Type: Customer Revenue Analysis

   Business Request:
   Identify Northstar Retail's 10 highest-value customers
   based on completed orders during the most recent
   12 months of available order data.

   Required Output:
   - Customer ID
   - Customer full name
   - Province
   - Number of completed orders
   - Total units purchased
   - Total revenue generated
   - Average completed order value
   - Revenue rank

   Business Rules:
   - Include completed orders only.
   - Revenue must reflect line-item discounts.
   - Use the most recent 12 months of available order data.
   - Include only customers who generated revenue during
     the reporting period.

   Revenue Formula:
   quantity * unit_price * (1 - discount_percent / 100)

   ========================================================= */


USE NorthstarRetail;
GO


/* =========================================================
   SOLUTION
   ========================================================= */

WITH CustomerRevenue AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.province,

        COUNT(DISTINCT o.order_id) AS completed_orders,

        SUM(oi.quantity) AS total_units,

        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) AS total_revenue,

        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) / COUNT(DISTINCT o.order_id) AS avg_order_value

    FROM Customers AS c

    JOIN Orders AS o
        ON c.customer_id = o.customer_id

    JOIN OrderItems AS oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Completed'
      AND o.order_date >= DATEADD(
            MONTH,
            -12,
            (SELECT MAX(order_date) FROM Orders)
          )

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.province
),
RankedCustomers AS
(
    SELECT
        *,
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM CustomerRevenue
)

SELECT TOP 10
    customer_id,
    customer_name,
    province,
    completed_orders,
    total_units,
    total_revenue,
    avg_order_value,
    revenue_rank

FROM RankedCustomers

ORDER BY total_revenue DESC;

GO
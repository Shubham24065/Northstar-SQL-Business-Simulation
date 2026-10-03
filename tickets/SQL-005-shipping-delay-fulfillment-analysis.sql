/* =========================================================
   NORTHSTAR RETAIL
   SQL BUSINESS OPERATIONS SIMULATION
   =========================================================

   Ticket: SQL-005
   Department: Customer Support / Operations
   Requested By: Customer Support Manager
   Priority: High
   Type: Shipping Delay & Fulfillment Analysis

   Business Request:
   Investigate completed orders that experienced unusually
   long delivery times and determine whether particular
   shipping carriers are contributing to fulfillment delays.

   Required Output:

   Result 1 - Delayed Orders
   - Order ID
   - Customer name
   - Province
   - Order date
   - Shipped date
   - Delivered date
   - Carrier
   - Days to ship
   - Days in transit
   - Total delivery days
   - Order value
   - Delivery delay rank

   Result 2 - Carrier Summary
   - Carrier
   - Number of delayed orders
   - Average delivery days
   - Worst delivery time
   - Total value of delayed orders

   Business Rules:
   - Include completed orders only.
   - Include delivered shipments only.
   - Orders without a valid delivery date are excluded.
   - An order is delayed when total delivery time exceeds
     7 days.
   - Order value must reflect line-item discounts.
   - The slowest delivered order receives rank #1.
   - Orders with equal delivery times receive the same rank.
   - Carrier summary is ordered by delayed-order count
     descending.

   Revenue Formula:
   quantity * unit_price * (1 - discount_percent / 100)

   ========================================================= */

USE NorthstarRetail;
GO


/* =========================================================
   BUILD DELAYED ORDER DATASET
   ========================================================= */

DROP TABLE IF EXISTS #DelayedOrders;

WITH OrderValues AS
(
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ) AS order_value

    FROM Orders AS o

    JOIN OrderItems AS oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Completed'

    GROUP BY
        o.order_id,
        o.customer_id,
        o.order_date
),

DeliveryAnalysis AS
(
    SELECT
        ov.order_id,

        CONCAT(
            c.first_name,
            ' ',
            c.last_name
        ) AS customer_name,

        c.province,

        ov.order_date,
        s.shipped_date,
        s.delivered_date,
        s.carrier,

        DATEDIFF(
            DAY,
            ov.order_date,
            s.shipped_date
        ) AS days_to_ship,

        DATEDIFF(
            DAY,
            s.shipped_date,
            s.delivered_date
        ) AS days_in_transit,

        DATEDIFF(
            DAY,
            ov.order_date,
            s.delivered_date
        ) AS total_delivery_days,

        CAST(
            ov.order_value
            AS DECIMAL(18,2)
        ) AS order_value

    FROM OrderValues AS ov

    JOIN Customers AS c
        ON ov.customer_id = c.customer_id

    JOIN Shipments AS s
        ON ov.order_id = s.order_id

    WHERE s.shipment_status = 'Delivered'
      AND s.delivered_date IS NOT NULL
)

SELECT
    order_id,
    customer_name,
    province,
    order_date,
    shipped_date,
    delivered_date,
    carrier,
    days_to_ship,
    days_in_transit,
    total_delivery_days,
    order_value,

    RANK() OVER (
        ORDER BY total_delivery_days DESC
    ) AS delivery_delay_rank

INTO #DelayedOrders

FROM DeliveryAnalysis

WHERE total_delivery_days > 7;


/* =========================================================
   RESULT 1 — DELAYED ORDERS
   ========================================================= */

SELECT
    order_id,
    customer_name,
    province,
    order_date,
    shipped_date,
    delivered_date,
    carrier,
    days_to_ship,
    days_in_transit,
    total_delivery_days,
    order_value,
    delivery_delay_rank

FROM #DelayedOrders

ORDER BY
    delivery_delay_rank,
    order_id;


/* =========================================================
   RESULT 2 — CARRIER DELAY SUMMARY
   ========================================================= */

SELECT
    carrier,

    COUNT(*) AS delayed_orders,

    CAST(
        AVG(
            CAST(total_delivery_days AS DECIMAL(10,2))
        )
        AS DECIMAL(10,2)
    ) AS avg_delivery_days,

    MAX(total_delivery_days) AS worst_delivery_days,

    CAST(
        SUM(order_value)
        AS DECIMAL(18,2)
    ) AS total_value_of_delayed_orders

FROM #DelayedOrders

GROUP BY carrier

ORDER BY
    delayed_orders DESC,
    avg_delivery_days DESC;


/* =========================================================
   CLEANUP
   ========================================================= */

DROP TABLE #DelayedOrders;

GO

/*
    NORTHSTAR RETAIL
    SQL BUSINESS OPERATIONS SIMULATION

    Ticket: SQL-008
    Department: Sales / Management
    Type: Repeat Customer & Purchase Interval Analysis

    Objective:
    Analyze completed customer orders to understand
    repeat purchasing behaviour and purchase frequency.

    Business Rules:
    - Only completed orders count as purchases.
    - Order sequences are calculated per customer.
    - Orders with the same timestamp are sorted by order ID.
    - First purchases have no previous purchase interval.
    - Customers with one completed order are not repeat customers.
    - Average intervals exclude the first purchase.
*/

USE NorthstarRetail;
GO

DROP TABLE IF EXISTS #CustomerPurchaseHistory;

WITH PurchaseSequence AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name)
            AS customer_name,
        o.order_id,
        o.order_date,

        ROW_NUMBER() OVER
        (
            PARTITION BY c.customer_id
            ORDER BY o.order_date, o.order_id
        ) AS purchase_sequence,

        LAG(o.order_date) OVER
        (
            PARTITION BY c.customer_id
            ORDER BY o.order_date, o.order_id
        ) AS previous_order_date

    FROM Customers AS c
    JOIN Orders AS o
        ON c.customer_id = o.customer_id

    WHERE o.order_status = 'Completed'
)

SELECT
    customer_id,
    customer_name,
    order_id,
    order_date,
    purchase_sequence,
    previous_order_date,

    DATEDIFF(
        DAY,
        previous_order_date,
        order_date
    ) AS days_since_previous_purchase

INTO #CustomerPurchaseHistory
FROM PurchaseSequence;


/* RESULT 1 - CUSTOMER PURCHASE SEQUENCE */

SELECT
    customer_id,
    customer_name,
    order_id,
    order_date,
    purchase_sequence,
    previous_order_date,
    days_since_previous_purchase

FROM #CustomerPurchaseHistory

ORDER BY
    customer_id,
    purchase_sequence;


/* RESULT 2 - CUSTOMER REPEAT PURCHASE SUMMARY */

SELECT
    customer_id,
    customer_name,

    MIN(order_date) AS first_purchase_date,
    MAX(order_date) AS most_recent_purchase_date,

    COUNT(*) AS total_completed_orders,

    CASE
        WHEN COUNT(*) > 1 THEN 'Yes'
        ELSE 'No'
    END AS repeat_customer,

    CAST(
        AVG(
            CAST(
                days_since_previous_purchase
                AS DECIMAL(10,2)
            )
        )
        AS DECIMAL(10,2)
    ) AS avg_days_between_purchases

FROM #CustomerPurchaseHistory

GROUP BY
    customer_id,
    customer_name

ORDER BY
    total_completed_orders DESC,
    customer_id;


/* CLEANUP */

DROP TABLE #CustomerPurchaseHistory;
GO

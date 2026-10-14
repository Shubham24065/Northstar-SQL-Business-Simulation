
/*
    NORTHSTAR RETAIL
    SQL BUSINESS OPERATIONS SIMULATION

    Ticket: SQL-007
    Department: Operations
    Type: Order Fulfillment & Shipping Delay Investigation

    Objective:
    Review fulfillment performance for completed and shipped
    orders, classify delivery delays, and report operational KPIs.

    Delay Rules:
    On Time           = 0-7 calendar days
    Minor Delay       = 8-10 calendar days
    Significant Delay = More than 10 calendar days
    Not Yet Delivered = No delivery date

    Reporting Notes:
    - Only Completed and Shipped orders are included.
    - Delivery times use DATEDIFF(DAY).
    - Delay percentage is based on delivered orders only.
    - Undelivered orders are counted separately.
*/

USE NorthstarRetail;
GO

DROP TABLE IF EXISTS #FulfillmentAnalysis;

WITH FulfillmentData AS
(
    SELECT
        o.order_id,
        CONCAT(c.first_name, ' ', c.last_name)
            AS customer_name,
        c.province,
        o.order_date,
        o.order_status,
        s.shipped_date,
        s.delivered_date,
        COALESCE(s.shipment_status, 'Missing')
            AS shipment_status,

        DATEDIFF(
            DAY, o.order_date, s.shipped_date
        ) AS days_to_ship,

        DATEDIFF(
            DAY, s.shipped_date, s.delivered_date
        ) AS days_in_transit,

        DATEDIFF(
            DAY, o.order_date, s.delivered_date
        ) AS total_fulfillment_days

    FROM Orders AS o
    JOIN Customers AS c
        ON o.customer_id = c.customer_id
    LEFT JOIN Shipments AS s
        ON o.order_id = s.order_id

    WHERE o.order_status IN ('Completed', 'Shipped')
),

ClassifiedOrders AS
(
    SELECT
        *,
        CASE
            WHEN delivered_date IS NULL
                THEN 'Not Yet Delivered'

            WHEN total_fulfillment_days <= 7
                THEN 'On Time'

            WHEN total_fulfillment_days <= 10
                THEN 'Minor Delay'

            ELSE 'Significant Delay'
        END AS delay_classification

    FROM FulfillmentData
)

SELECT *
INTO #FulfillmentAnalysis
FROM ClassifiedOrders;


/* RESULT 1 - ORDER FULFILLMENT DETAILS */

SELECT
    order_id,
    customer_name,
    province,
    order_date,
    shipped_date,
    delivered_date,
    shipment_status,
    days_to_ship,
    days_in_transit,
    total_fulfillment_days,
    delay_classification

FROM #FulfillmentAnalysis

ORDER BY
    CASE delay_classification
        WHEN 'Significant Delay' THEN 1
        WHEN 'Minor Delay' THEN 2
        WHEN 'Not Yet Delivered' THEN 3
        WHEN 'On Time' THEN 4
    END,
    total_fulfillment_days DESC,
    order_id;


/* RESULT 2 - FULFILLMENT PERFORMANCE SUMMARY */

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE WHEN delivered_date IS NOT NULL
            THEN 1 ELSE 0 END
    ) AS delivered_orders,

    SUM(
        CASE WHEN delivered_date IS NULL
            THEN 1 ELSE 0 END
    ) AS undelivered_orders,

    CAST(
        AVG(
            CAST(total_fulfillment_days AS DECIMAL(10,2))
        )
        AS DECIMAL(10,2)
    ) AS avg_fulfillment_days,

    SUM(
        CASE WHEN delay_classification
            IN ('Minor Delay', 'Significant Delay')
            THEN 1 ELSE 0 END
    ) AS delayed_orders,

    CAST(
        100.0 *
        SUM(
            CASE WHEN delay_classification
                IN ('Minor Delay', 'Significant Delay')
                THEN 1 ELSE 0 END
        )
        /
        NULLIF(
            SUM(
                CASE WHEN delivered_date IS NOT NULL
                    THEN 1 ELSE 0 END
            ), 0
        )
        AS DECIMAL(10,2)
    ) AS delayed_order_percentage

FROM #FulfillmentAnalysis;


/* RESULT 3 - DELAY CLASSIFICATION BREAKDOWN */

SELECT
    delay_classification,
    COUNT(*) AS order_count

FROM #FulfillmentAnalysis

GROUP BY delay_classification

ORDER BY
    CASE delay_classification
        WHEN 'Significant Delay' THEN 1
        WHEN 'Minor Delay' THEN 2
        WHEN 'Not Yet Delivered' THEN 3
        WHEN 'On Time' THEN 4
    END;


/* CLEANUP */

DROP TABLE #FulfillmentAnalysis;
GO

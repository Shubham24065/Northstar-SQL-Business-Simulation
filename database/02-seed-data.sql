USE NorthstarRetail;
GO


/* =========================================================
   NORTHSTAR RETAIL
   SEED DATA - PART 1

   Creates:
   - Categories
   - Suppliers
   - Employees
   - Products
   ========================================================= */


/* =========================
   CATEGORIES
   ========================= */

INSERT INTO Categories (category_id, category_name)
VALUES
(1, 'Laptops'),
(2, 'Smartphones'),
(3, 'Computer Accessories'),
(4, 'Audio'),
(5, 'Gaming'),
(6, 'Home Office'),
(7, 'Smart Home'),
(8, 'Wearables'),
(9, 'Storage'),
(10, 'Networking');


/* =========================
   SUPPLIERS
   ========================= */

INSERT INTO Suppliers
(
    supplier_id,
    supplier_name,
    contact_name,
    email,
    phone,
    city,
    province
)
VALUES
(1, 'MapleTech Distribution', 'Daniel Brooks',
    'daniel@mapletech.ca', '416-555-0101', 'Toronto', 'Ontario'),

(2, 'Northern Digital Supply', 'Sarah Wilson',
    'sarah@northerndigital.ca', '905-555-0102', 'Mississauga', 'Ontario'),

(3, 'Pacific Electronics', 'Kevin Chen',
    'kevin@pacificelectronics.ca', '604-555-0103', 'Vancouver', 'British Columbia'),

(4, 'Prairie Technology Group', 'Emily Parker',
    'emily@prairietech.ca', '403-555-0104', 'Calgary', 'Alberta'),

(5, 'Capital Computer Supply', 'Marc Tremblay',
    'marc@capitalcomputer.ca', '613-555-0105', 'Ottawa', 'Ontario'),

(6, 'Atlantic Digital', 'Rachel Morgan',
    'rachel@atlanticdigital.ca', '902-555-0106', 'Halifax', 'Nova Scotia'),

(7, 'Vertex Technology Supply', 'Jason Lee',
    'jason@vertextech.ca', '416-555-0107', 'Markham', 'Ontario'),

(8, 'Quantum Electronics Canada', 'Priya Patel',
    'priya@quantumelectronics.ca', '905-555-0108', 'Brampton', 'Ontario'),

(9, 'WestPeak Computing', 'Alex Thompson',
    'alex@westpeak.ca', '780-555-0109', 'Edmonton', 'Alberta'),

(10, 'Metro Device Wholesale', 'Amanda Singh',
    'amanda@metrodevice.ca', '416-555-0110', 'Toronto', 'Ontario'),

(11, 'TrueNorth Components', 'Michael Brown',
    'michael@truenorthcomponents.ca', '519-555-0111', 'London', 'Ontario'),

(12, 'BlueWave Electronics', 'Sophie Martin',
    'sophie@bluewave.ca', '514-555-0112', 'Montreal', 'Quebec'),

(13, 'Summit Technology Partners', 'Ryan Cooper',
    'ryan@summittech.ca', '905-555-0113', 'Oakville', 'Ontario'),

(14, 'Canadian Office Systems', 'Laura Evans',
    'laura@canadianoffice.ca', '416-555-0114', 'Toronto', 'Ontario'),

(15, 'NextGen Device Supply', 'Arjun Mehta',
    'arjun@nextgendevice.ca', '647-555-0115', 'Toronto', 'Ontario'),

(16, 'RedLeaf Electronics', 'Nicole Adams',
    'nicole@redleaf.ca', '613-555-0116', 'Kingston', 'Ontario'),

(17, 'TechBridge Wholesale', 'David Kim',
    'david@techbridge.ca', '604-555-0117', 'Burnaby', 'British Columbia'),

(18, 'Central Canada Computing', 'Olivia Clark',
    'olivia@centralcomputing.ca', '204-555-0118', 'Winnipeg', 'Manitoba'),

(19, 'UrbanTech Distribution', 'Ethan Miller',
    'ethan@urbantech.ca', '416-555-0119', 'Toronto', 'Ontario'),

(20, 'Frontier Digital Supply', 'Grace Taylor',
    'grace@frontierdigital.ca', '306-555-0120', 'Saskatoon', 'Saskatchewan');


/* =========================
   EMPLOYEES
   ========================= */

INSERT INTO Employees
(
    employee_id,
    first_name,
    last_name,
    department,
    job_title,
    hire_date,
    salary,
    employee_status
)
VALUES
(1, 'Olivia', 'Carter', 'Sales', 'Sales Representative', '2022-03-14', 58000, 'Active'),
(2, 'Liam', 'Anderson', 'Sales', 'Sales Representative', '2023-01-09', 56000, 'Active'),
(3, 'Noah', 'Martin', 'Sales', 'Senior Sales Representative', '2020-06-22', 72000, 'Active'),
(4, 'Emma', 'Wilson', 'Sales', 'Sales Manager', '2019-04-15', 89000, 'Active'),
(5, 'Ethan', 'Brown', 'Operations', 'Operations Analyst', '2022-08-08', 65000, 'Active'),
(6, 'Sophia', 'Taylor', 'Operations', 'Operations Coordinator', '2024-02-12', 54000, 'Active'),
(7, 'Lucas', 'Thomas', 'Operations', 'Operations Manager', '2019-11-04', 92000, 'Active'),
(8, 'Ava', 'Moore', 'Finance', 'Financial Analyst', '2021-07-19', 68000, 'Active'),
(9, 'Mason', 'Jackson', 'Finance', 'Senior Financial Analyst', '2018-09-10', 81000, 'Active'),
(10, 'Isabella', 'White', 'Finance', 'Finance Manager', '2017-05-01', 98000, 'Active'),
(11, 'Logan', 'Harris', 'Customer Support', 'Support Specialist', '2023-06-05', 50000, 'Active'),
(12, 'Mia', 'Clark', 'Customer Support', 'Support Specialist', '2024-01-15', 49000, 'Active'),
(13, 'James', 'Lewis', 'Customer Support', 'Senior Support Specialist', '2020-10-26', 61000, 'Active'),
(14, 'Charlotte', 'Walker', 'Customer Support', 'Support Manager', '2019-02-11', 78000, 'Active'),
(15, 'Benjamin', 'Hall', 'IT', 'Database Administrator', '2018-04-23', 94000, 'Active'),
(16, 'Amelia', 'Young', 'IT', 'Database Support Analyst', '2022-09-06', 71000, 'Active'),
(17, 'Henry', 'King', 'IT', 'Systems Analyst', '2021-03-29', 76000, 'Active'),
(18, 'Harper', 'Wright', 'IT', 'IT Manager', '2017-08-14', 105000, 'Active'),
(19, 'Alexander', 'Scott', 'Warehouse', 'Warehouse Supervisor', '2020-01-20', 64000, 'Active'),
(20, 'Evelyn', 'Green', 'Warehouse', 'Inventory Coordinator', '2023-05-08', 52000, 'Active'),
(21, 'Daniel', 'Baker', 'Warehouse', 'Inventory Specialist', '2022-11-14', 55000, 'Active'),
(22, 'Ella', 'Adams', 'Sales', 'Sales Representative', '2024-04-01', 55000, 'Active'),
(23, 'Matthew', 'Nelson', 'Sales', 'Sales Representative', '2021-12-06', 60000, 'Active'),
(24, 'Scarlett', 'Hill', 'Operations', 'Business Operations Analyst', '2021-05-17', 70000, 'Active'),
(25, 'Jack', 'Campbell', 'Finance', 'Accounts Specialist', '2023-03-13', 57000, 'Active'),
(26, 'Victoria', 'Mitchell', 'Marketing', 'Marketing Analyst', '2022-02-28', 62000, 'Active'),
(27, 'Owen', 'Roberts', 'Marketing', 'Marketing Manager', '2019-07-08', 85000, 'Active'),
(28, 'Lily', 'Turner', 'Customer Support', 'Support Specialist', '2023-10-16', 50000, 'Active'),
(29, 'Samuel', 'Phillips', 'Warehouse', 'Inventory Specialist', '2024-05-06', 51000, 'Active'),
(30, 'Grace', 'Parker', 'Sales', 'Sales Representative', '2020-08-24', 63000, 'Inactive');


/* =========================
   PRODUCTS

   We generate 200 products.
   ========================= */

;WITH Numbers AS
(
    SELECT TOP (200)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO Products
(
    product_id,
    product_name,
    category_id,
    supplier_id,
    unit_price,
    cost_price,
    product_status
)
SELECT
    n,

    CONCAT(
        CASE ((n - 1) % 10) + 1
            WHEN 1 THEN 'Northstar Laptop '
            WHEN 2 THEN 'Nova Smartphone '
            WHEN 3 THEN 'Precision Accessory '
            WHEN 4 THEN 'Pulse Audio '
            WHEN 5 THEN 'Vertex Gaming '
            WHEN 6 THEN 'WorkPro Office '
            WHEN 7 THEN 'Nexa Smart Home '
            WHEN 8 THEN 'Motion Wearable '
            WHEN 9 THEN 'DataVault Storage '
            WHEN 10 THEN 'LinkPro Network '
        END,
        RIGHT('000' + CAST(n AS VARCHAR(3)), 3)
    ),

    ((n - 1) % 10) + 1,

    ((n - 1) % 20) + 1,

    CAST(
        19.99 +
        (((n * 47) % 1450))
        AS DECIMAL(10,2)
    ),

    CAST(
        (
            19.99 +
            (((n * 47) % 1450))
        ) * (0.55 + ((n % 15) / 100.0))
        AS DECIMAL(10,2)
    ),

    CASE
        WHEN n % 29 = 0 THEN 'Discontinued'
        WHEN n % 17 = 0 THEN 'Inactive'
        ELSE 'Active'
    END

FROM Numbers;

GO

/* =========================================================
   SEED DATA - PART 2

   Creates:
   - 1,000 Customers
   - 5,000 Orders
   ========================================================= */


/* =========================
   CUSTOMERS
   ========================= */

;WITH Numbers AS
(
    SELECT TOP (1000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Customers
(
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    province,
    signup_date,
    customer_status
)
SELECT
    n,

    CASE n % 20
        WHEN 0 THEN 'Liam'
        WHEN 1 THEN 'Olivia'
        WHEN 2 THEN 'Noah'
        WHEN 3 THEN 'Emma'
        WHEN 4 THEN 'Ethan'
        WHEN 5 THEN 'Sophia'
        WHEN 6 THEN 'Lucas'
        WHEN 7 THEN 'Ava'
        WHEN 8 THEN 'Mason'
        WHEN 9 THEN 'Isabella'
        WHEN 10 THEN 'Logan'
        WHEN 11 THEN 'Mia'
        WHEN 12 THEN 'James'
        WHEN 13 THEN 'Charlotte'
        WHEN 14 THEN 'Benjamin'
        WHEN 15 THEN 'Amelia'
        WHEN 16 THEN 'Henry'
        WHEN 17 THEN 'Harper'
        WHEN 18 THEN 'Daniel'
        ELSE 'Grace'
    END,

    CASE (n * 7) % 20
        WHEN 0 THEN 'Smith'
        WHEN 1 THEN 'Brown'
        WHEN 2 THEN 'Wilson'
        WHEN 3 THEN 'Taylor'
        WHEN 4 THEN 'Anderson'
        WHEN 5 THEN 'Thomas'
        WHEN 6 THEN 'Jackson'
        WHEN 7 THEN 'White'
        WHEN 8 THEN 'Harris'
        WHEN 9 THEN 'Martin'
        WHEN 10 THEN 'Thompson'
        WHEN 11 THEN 'Moore'
        WHEN 12 THEN 'Clark'
        WHEN 13 THEN 'Lewis'
        WHEN 14 THEN 'Walker'
        WHEN 15 THEN 'Hall'
        WHEN 16 THEN 'Young'
        WHEN 17 THEN 'King'
        WHEN 18 THEN 'Wright'
        ELSE 'Scott'
    END,

    CONCAT('customer', n, '@northstarmail.ca'),

    CONCAT(
        '416-',
        RIGHT('000' + CAST((n * 13) % 1000 AS VARCHAR(3)), 3),
        '-',
        RIGHT('0000' + CAST((n * 37) % 10000 AS VARCHAR(4)), 4)
    ),

    CASE n % 12
        WHEN 0 THEN 'Toronto'
        WHEN 1 THEN 'Mississauga'
        WHEN 2 THEN 'Brampton'
        WHEN 3 THEN 'Ottawa'
        WHEN 4 THEN 'Hamilton'
        WHEN 5 THEN 'London'
        WHEN 6 THEN 'Vancouver'
        WHEN 7 THEN 'Calgary'
        WHEN 8 THEN 'Edmonton'
        WHEN 9 THEN 'Winnipeg'
        WHEN 10 THEN 'Montreal'
        ELSE 'Halifax'
    END,

    CASE n % 12
        WHEN 0 THEN 'Ontario'
        WHEN 1 THEN 'Ontario'
        WHEN 2 THEN 'Ontario'
        WHEN 3 THEN 'Ontario'
        WHEN 4 THEN 'Ontario'
        WHEN 5 THEN 'Ontario'
        WHEN 6 THEN 'British Columbia'
        WHEN 7 THEN 'Alberta'
        WHEN 8 THEN 'Alberta'
        WHEN 9 THEN 'Manitoba'
        WHEN 10 THEN 'Quebec'
        ELSE 'Nova Scotia'
    END,

    DATEADD(
        DAY,
        -((n * 17) % 1400),
        CAST('2026-08-31' AS DATE)
    ),

    CASE
        WHEN n % 19 = 0 THEN 'Inactive'
        WHEN n % 47 = 0 THEN 'Suspended'
        ELSE 'Active'
    END

FROM Numbers;

GO


/* =========================
   ORDERS
   ========================= */

;WITH Numbers AS
(
    SELECT TOP (5000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Orders
(
    order_id,
    customer_id,
    order_date,
    order_status,
    sales_employee_id
)
SELECT
    n,

    ((n * 37) % 1000) + 1,

    DATEADD(
        MINUTE,
        (n * 43) % 1440,
        DATEADD(
            DAY,
            -((n * 11) % 730),
            CAST('2026-08-31' AS DATETIME2)
        )
    ),

    CASE
        WHEN n % 31 = 0 THEN 'Cancelled'
        WHEN n % 23 = 0 THEN 'Returned'
        WHEN n % 17 = 0 THEN 'Processing'
        WHEN n % 13 = 0 THEN 'Shipped'
        ELSE 'Completed'
    END,

    CASE
        WHEN n % 8 = 0 THEN NULL
        ELSE
            CASE n % 6
                WHEN 0 THEN 1
                WHEN 1 THEN 2
                WHEN 2 THEN 3
                WHEN 3 THEN 22
                WHEN 4 THEN 23
                ELSE 4
            END
    END

FROM Numbers;

GO

/* =========================================================
   SEED DATA - PART 3

   Creates:
   - Order Items
   - Approximately 15,000 line items
   ========================================================= */

;WITH ItemNumbers AS
(
    SELECT 1 AS item_number
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3
    UNION ALL
    SELECT 4
    UNION ALL
    SELECT 5
),
GeneratedItems AS
(
    SELECT
        o.order_id,
        i.item_number,

        ((o.order_id * 17 + i.item_number * 31) % 200) + 1
            AS product_id,

        ((o.order_id + i.item_number) % 4) + 1
            AS quantity,

        CASE
            WHEN (o.order_id + i.item_number) % 20 = 0 THEN 20.00
            WHEN (o.order_id + i.item_number) % 13 = 0 THEN 15.00
            WHEN (o.order_id + i.item_number) % 9 = 0 THEN 10.00
            WHEN (o.order_id + i.item_number) % 7 = 0 THEN 5.00
            ELSE 0.00
        END AS discount_percent

    FROM Orders o
    CROSS JOIN ItemNumbers i

    WHERE i.item_number <=
        CASE
            WHEN o.order_id % 10 < 2 THEN 1
            WHEN o.order_id % 10 < 5 THEN 2
            WHEN o.order_id % 10 < 8 THEN 3
            WHEN o.order_id % 10 = 8 THEN 4
            ELSE 5
        END
)
INSERT INTO OrderItems
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percent
)
SELECT
    ROW_NUMBER() OVER
        (ORDER BY g.order_id, g.item_number),

    g.order_id,

    g.product_id,

    g.quantity,

    p.unit_price,

    g.discount_percent

FROM GeneratedItems g

JOIN Products p
    ON g.product_id = p.product_id;

GO

/* =========================================================
   SEED DATA - PART 4

   Creates:
   - Payments
   - Successful, failed, pending, and refunded cases
   ========================================================= */

;WITH OrderTotals AS
(
    SELECT
        o.order_id,
        o.order_date,

        CAST(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - (oi.discount_percent / 100.0))
            )
            AS DECIMAL(10,2)
        ) AS order_total

    FROM Orders o

    JOIN OrderItems oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.order_id,
        o.order_date
)
INSERT INTO Payments
(
    payment_id,
    order_id,
    payment_date,
    payment_method,
    amount,
    payment_status
)
SELECT
    ot.order_id AS payment_id,

    ot.order_id,

    CASE
        WHEN ot.order_id % 29 = 0 THEN NULL
        ELSE DATEADD(
            MINUTE,
            (ot.order_id * 7) % 240,
            ot.order_date
        )
    END AS payment_date,

    CASE ot.order_id % 5
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'Debit Card'
        WHEN 2 THEN 'PayPal'
        WHEN 3 THEN 'Apple Pay'
        ELSE 'Google Pay'
    END AS payment_method,

    CASE
        WHEN ot.order_id % 23 = 0
            THEN CAST(ot.order_total * 0.90 AS DECIMAL(10,2))

        WHEN ot.order_id % 31 = 0
            THEN CAST(ot.order_total * 0.50 AS DECIMAL(10,2))

        ELSE ot.order_total
    END AS amount,

    CASE
        WHEN ot.order_id % 31 = 0 THEN 'Refunded'
        WHEN ot.order_id % 23 = 0 THEN 'Failed'
        WHEN ot.order_id % 17 = 0 THEN 'Pending'
        ELSE 'Completed'
    END AS payment_status

FROM OrderTotals ot;

GO

/* =========================================================
   SEED DATA - PART 5

   Creates:
   - Shipments
   - Delivered, shipped, delayed, and pending cases
   ========================================================= */

INSERT INTO Shipments
(
    shipment_id,
    order_id,
    shipped_date,
    delivered_date,
    carrier,
    tracking_number,
    shipment_status
)
SELECT
    o.order_id AS shipment_id,

    o.order_id,

    CASE
        WHEN o.order_status IN ('Cancelled', 'Processing')
            THEN NULL
        ELSE DATEADD(
            DAY,
            1 + (o.order_id % 3),
            o.order_date
        )
    END AS shipped_date,

    CASE
        WHEN o.order_status = 'Completed'
            AND o.order_id % 19 <> 0
        THEN DATEADD(
            DAY,
            3 + (o.order_id % 8),
            o.order_date
        )
        ELSE NULL
    END AS delivered_date,

    CASE o.order_id % 5
        WHEN 0 THEN 'Canada Post'
        WHEN 1 THEN 'UPS'
        WHEN 2 THEN 'FedEx'
        WHEN 3 THEN 'Purolator'
        ELSE 'DHL'
    END AS carrier,

    CASE
        WHEN o.order_status IN ('Cancelled', 'Processing')
            THEN NULL
        ELSE CONCAT(
            'NS',
            RIGHT('00000000' + CAST(o.order_id AS VARCHAR(8)), 8)
        )
    END AS tracking_number,

    CASE
        WHEN o.order_status = 'Cancelled' THEN 'Cancelled'
        WHEN o.order_status = 'Processing' THEN 'Pending'
        WHEN o.order_status = 'Completed'
             AND o.order_id % 19 = 0 THEN 'Delayed'
        WHEN o.order_status = 'Completed' THEN 'Delivered'
        WHEN o.order_status = 'Returned' THEN 'Returned'
        ELSE 'Shipped'
    END AS shipment_status

FROM Orders o;

GO

/* =========================================================
   SEED DATA - PART 6

   Creates:
   - Inventory records
   - Multiple warehouse locations
   - Low-stock and reorder situations
   ========================================================= */

;WITH Warehouses AS
(
    SELECT 'Toronto' AS warehouse_location
    UNION ALL
    SELECT 'Vancouver'
)
INSERT INTO Inventory
(
    inventory_id,
    product_id,
    warehouse_location,
    quantity_in_stock,
    reorder_level,
    last_updated
)
SELECT
    ROW_NUMBER() OVER
        (ORDER BY p.product_id, w.warehouse_location),

    p.product_id,

    w.warehouse_location,

    CASE
        WHEN (p.product_id + LEN(w.warehouse_location)) % 17 = 0
            THEN 0
        WHEN (p.product_id + LEN(w.warehouse_location)) % 11 = 0
            THEN 4
        WHEN (p.product_id + LEN(w.warehouse_location)) % 7 = 0
            THEN 9
        ELSE
            20 + ((p.product_id * 13) % 180)
    END AS quantity_in_stock,

    CASE
        WHEN p.product_id % 3 = 0 THEN 15
        WHEN p.product_id % 3 = 1 THEN 20
        ELSE 25
    END AS reorder_level,

    DATEADD(
        HOUR,
        -(p.product_id % 72),
        CAST('2026-08-31 23:00:00' AS DATETIME2)
    ) AS last_updated

FROM Products p
CROSS JOIN Warehouses w;

GO

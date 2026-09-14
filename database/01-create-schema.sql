CREATE DATABASE NorthstarRetail;
GO

USE NorthstarRetail;
GO

CREATE TABLE Customers
(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    province VARCHAR(50),
    signup_date DATE NOT NULL,
    customer_status VARCHAR(20) NOT NULL
);

CREATE TABLE Categories
(
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Suppliers
(
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    province VARCHAR(50)
);

CREATE TABLE Products
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    product_status VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (category_id)
        REFERENCES Categories(category_id),

    CONSTRAINT FK_Products_Suppliers
        FOREIGN KEY (supplier_id)
        REFERENCES Suppliers(supplier_id)
);
GO

CREATE TABLE Employees
(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    employee_status VARCHAR(20) NOT NULL
);

CREATE TABLE Orders
(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME2 NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    sales_employee_id INT NULL,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT FK_Orders_Employees
        FOREIGN KEY (sales_employee_id)
        REFERENCES Employees(employee_id)
);

CREATE TABLE OrderItems
(
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

CREATE TABLE Payments
(
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATETIME2,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);

CREATE TABLE Shipments
(
    shipment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    shipped_date DATETIME2,
    delivered_date DATETIME2,
    carrier VARCHAR(50),
    tracking_number VARCHAR(100),
    shipment_status VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Shipments_Orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);

CREATE TABLE Inventory
(
    inventory_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_location VARCHAR(50) NOT NULL,
    quantity_in_stock INT NOT NULL,
    reorder_level INT NOT NULL,
    last_updated DATETIME2 NOT NULL,

    CONSTRAINT FK_Inventory_Products
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);
GO
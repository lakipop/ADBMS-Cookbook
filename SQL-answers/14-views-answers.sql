-- ==========================================
-- PRACTICAL 14: Views - ANSWERS
-- 10 Questions at Different Levels
-- ==========================================

-- ==========================================
-- SETUP: Create Base Tables
-- ==========================================

CREATE DATABASE IF NOT EXISTS ViewsPractice;
USE ViewsPractice;

-- Employee Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2),
    stock_quantity INT
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    product_id INT,
    quantity INT,
    order_date DATE,
    status VARCHAR(20)
);

-- Insert sample data
INSERT INTO employees VALUES 
(1, 'Kamal', 'IT', 75000, '2020-01-15', NULL),
(2, 'Nimal', 'IT', 55000, '2021-03-20', 1),
(3, 'Sunil', 'HR', 45000, '2019-06-10', 1),
(4, 'Amara', 'Finance', 65000, '2022-02-28', NULL),
(5, 'Kumari', 'HR', 40000, '2023-01-10', 3);

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 150000, 25),
(2, 'Mouse', 'Electronics', 2500, 100),
(3, 'Desk', 'Furniture', 35000, 40),
(4, 'Chair', 'Furniture', 15000, 60),
(5, 'Monitor', 'Electronics', 45000, 30);

INSERT INTO orders VALUES
(1, 'John', 1, 2, '2024-01-15', 'Completed'),
(2, 'Jane', 2, 5, '2024-01-16', 'Pending'),
(3, 'Bob', 3, 1, '2024-01-17', 'Pending'),
(4, 'Alice', 1, 1, '2024-01-18', 'Shipped'),
(5, 'Tom', 4, 3, '2024-01-19', 'Pending');

-- ==========================================
-- Question 1: Simple View
-- Display only employee ID and name
-- ==========================================

CREATE VIEW vw_employee_names AS
SELECT emp_id, emp_name
FROM employees;

-- Test: SELECT * FROM vw_employee_names;

-- ==========================================
-- Question 2: Filtered View
-- Employees earning more than 50,000
-- ==========================================

CREATE VIEW vw_high_salary AS
SELECT *
FROM employees
WHERE salary > 50000;

-- Test: SELECT * FROM vw_high_salary;

-- ==========================================
-- Question 3: Column Alias View
-- Rename columns for better readability
-- ==========================================

CREATE VIEW vw_product_info AS
SELECT 
    product_id AS 'ID',
    product_name AS 'Product',
    price AS 'Unit Price'
FROM products;

-- Test: SELECT * FROM vw_product_info;

-- ==========================================
-- Question 4: Aggregation View
-- Department salary statistics
-- ==========================================

CREATE VIEW vw_dept_salary_stats AS
SELECT 
    department,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department;

-- Test: SELECT * FROM vw_dept_salary_stats;

-- ==========================================
-- Question 5: Group By View
-- Category stock totals
-- ==========================================

CREATE VIEW vw_category_stock AS
SELECT 
    category,
    SUM(stock_quantity) AS total_stock
FROM products
GROUP BY category;

-- Test: SELECT * FROM vw_category_stock;

-- ==========================================
-- Question 6: Join View
-- Order details with product info
-- ==========================================

CREATE VIEW vw_order_details AS
SELECT 
    o.order_id,
    o.customer_name,
    p.product_name,
    o.quantity,
    (o.quantity * p.price) AS total_amount
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id;

-- Test: SELECT * FROM vw_order_details;

-- ==========================================
-- Question 7: Self-Join View
-- Employee with their manager
-- ==========================================

CREATE VIEW vw_employee_manager AS
SELECT 
    e.emp_id,
    e.emp_name AS employee_name,
    m.emp_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Test: SELECT * FROM vw_employee_manager;

-- ==========================================
-- Question 8: View with WITH CHECK OPTION
-- Only pending orders allowed
-- ==========================================

CREATE VIEW vw_pending_orders AS
SELECT *
FROM orders
WHERE status = 'Pending'
WITH CHECK OPTION;

-- Test: SELECT * FROM vw_pending_orders;

-- This will FAIL because status is not 'Pending':
-- INSERT INTO vw_pending_orders VALUES (6, 'Test', 1, 1, '2024-01-20', 'Completed');

-- This will SUCCEED:
-- INSERT INTO vw_pending_orders VALUES (6, 'Test', 1, 1, '2024-01-20', 'Pending');

-- ==========================================
-- Question 9: View Based on View
-- Expensive products with low stock
-- ==========================================

-- First view: Expensive products
CREATE VIEW vw_expensive_products AS
SELECT *
FROM products
WHERE price > 10000;

-- Second view: Based on first view (expensive + low stock)
CREATE VIEW vw_expensive_low_stock AS
SELECT *
FROM vw_expensive_products
WHERE stock_quantity < 50;

-- Test: SELECT * FROM vw_expensive_low_stock;

-- ==========================================
-- Question 10: CREATE OR REPLACE & DROP
-- ==========================================

-- a) Modify existing view to add department
CREATE OR REPLACE VIEW vw_employee_names AS
SELECT emp_id, emp_name, department
FROM employees;

-- Test: SELECT * FROM vw_employee_names;

-- b) Drop a view
DROP VIEW IF EXISTS vw_category_stock;

-- Verify: SHOW TABLES LIKE 'vw_%';

-- ==========================================
-- Bonus: Show all views
-- ==========================================

-- SHOW FULL TABLES WHERE Table_type = 'VIEW';

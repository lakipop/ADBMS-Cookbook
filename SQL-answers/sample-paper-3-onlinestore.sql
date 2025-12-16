-- ==========================================
-- SAMPLE PAPER 3: OnlineStoreDB - ANSWERS
-- Duration: 2 Hours | Total: 100 Marks
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE IF NOT EXISTS OnlineStoreDB;
USE OnlineStoreDB;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(50),
    registration_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    min_stock_level INT DEFAULT 10
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(20),
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO customers (first_name, last_name, email, phone, city, registration_date) VALUES
('Kamal', 'Perera', 'kamal@email.com', '0771234567', 'Colombo', '2023-01-15'),
('Nimal', 'Silva', 'nimal@email.com', '0772345678', 'Kandy', '2023-02-20'),
('Sunil', 'Fernando', 'sunil@email.com', '0773456789', 'Galle', '2023-03-10');

INSERT INTO products (product_name, category, price, stock_quantity, min_stock_level) VALUES
('Laptop', 'Electronics', 85000.00, 25, 10),
('Smartphone', 'Electronics', 45000.00, 50, 15),
('Headphones', 'Accessories', 5000.00, 5, 10),
('Keyboard', 'Accessories', 3500.00, 30, 10);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-01-15', 90000.00, 'Completed'),
(1, '2024-02-20', 45000.00, 'Completed'),
(2, '2024-03-10', 8500.00, 'Completed'),
(2, '2024-04-05', 85000.00, 'Completed'),
(3, '2024-05-15', 48500.00, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 85000.00), (1, 4, 1, 3500.00), (1, 3, 1, 5000.00),
(2, 2, 1, 45000.00),
(3, 3, 1, 5000.00), (3, 4, 1, 3500.00),
(4, 1, 1, 85000.00),
(5, 2, 1, 45000.00), (5, 4, 1, 3500.00);

-- ==========================================
-- SECTION A: VIEWS (15 Marks)
-- ==========================================

-- Question 1 (8 Marks): vw_CustomerOrderSummary
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(o.order_id) >= 2;

-- Test:
SELECT * FROM vw_CustomerOrderSummary;


-- Question 2 (7 Marks): vw_LowStockProducts
CREATE VIEW vw_LowStockProducts AS
SELECT 
    product_id,
    product_name,
    category,
    stock_quantity,
    min_stock_level,
    (min_stock_level - stock_quantity) AS shortage
FROM products
WHERE stock_quantity < min_stock_level
WITH CHECK OPTION;

-- Test:
SELECT * FROM vw_LowStockProducts;

-- ==========================================
-- SECTION B: USER-DEFINED FUNCTIONS (15 Marks)
-- ==========================================

-- Question 3 (7 Marks): fn_CalculateOrderTotal
DELIMITER //

CREATE FUNCTION fn_CalculateOrderTotal(p_order_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);
    
    SELECT COALESCE(SUM(quantity * unit_price), 0) INTO total
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN total;
END //

DELIMITER ;

-- Test:
SELECT fn_CalculateOrderTotal(1);


-- Question 4 (8 Marks): fn_GetCustomerStatus
DELIMITER //

CREATE FUNCTION fn_GetCustomerStatus(p_customer_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_spending DECIMAL(12,2);
    DECLARE status VARCHAR(20);
    
    SELECT COALESCE(SUM(total_amount), 0) INTO total_spending
    FROM orders
    WHERE customer_id = p_customer_id;
    
    IF total_spending > 50000 THEN
        SET status = 'Platinum';
    ELSEIF total_spending > 25000 THEN
        SET status = 'Gold';
    ELSEIF total_spending > 10000 THEN
        SET status = 'Silver';
    ELSE
        SET status = 'Bronze';
    END IF;
    
    RETURN status;
END //

DELIMITER ;

-- Test:
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS name, 
       fn_GetCustomerStatus(customer_id) AS status
FROM customers;

-- ==========================================
-- SECTION C: STORED PROCEDURES (20 Marks)
-- ==========================================

-- Question 5 (10 Marks): sp_PlaceOrder
DELIMITER //

CREATE PROCEDURE sp_PlaceOrder(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    OUT p_order_id INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_total DECIMAL(12,2);
    
    -- Get current product price
    SELECT price INTO v_price FROM products WHERE product_id = p_product_id;
    
    -- Calculate total
    SET v_total = v_price * p_quantity;
    
    -- Create order
    INSERT INTO orders (customer_id, order_date, total_amount, status)
    VALUES (p_customer_id, CURDATE(), v_total, 'Pending');
    
    SET p_order_id = LAST_INSERT_ID();
    
    -- Add order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price);
END //

DELIMITER ;

-- Test:
CALL sp_PlaceOrder(1, 2, 2, @new_order);
SELECT @new_order;


-- Question 6 (10 Marks): sp_GetSalesReport
DELIMITER //

CREATE PROCEDURE sp_GetSalesReport(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error: Invalid date or query failed' AS error_message;
    END;
    
    -- Validate dates
    IF p_start_date IS NULL OR p_end_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Dates cannot be NULL';
    END IF;
    
    IF p_start_date > p_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Start date cannot be after end date';
    END IF;
    
    -- Generate report
    SELECT 
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_date BETWEEN p_start_date AND p_end_date
    GROUP BY p.product_id, p.product_name
    ORDER BY total_revenue DESC;
END //

DELIMITER ;

-- Test:
CALL sp_GetSalesReport('2024-01-01', '2024-12-31');

-- ==========================================
-- SECTION D: TRIGGERS (20 Marks)
-- ==========================================

-- Question 7 (10 Marks): trg_UpdateStockOnOrder
DELIMITER //

CREATE TRIGGER trg_UpdateStockOnOrder
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_new_stock INT;
    
    -- Update stock
    UPDATE products 
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
    
    -- Get new stock level
    SELECT stock_quantity INTO v_new_stock 
    FROM products WHERE product_id = NEW.product_id;
    
    -- Log warning if stock is low
    IF v_new_stock <= 0 THEN
        INSERT INTO audit_log (table_name, operation, record_id, old_value, new_value, changed_by)
        VALUES ('products', 'LOW_STOCK_WARNING', NEW.product_id, 
                NULL, CONCAT('Stock depleted! Current: ', v_new_stock), CURRENT_USER());
    END IF;
END //

DELIMITER ;


-- Question 8 (10 Marks): trg_PreventNegativeStock
DELIMITER //

CREATE TRIGGER trg_PreventNegativeStock
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_available INT;
    
    SELECT stock_quantity INTO v_available
    FROM products WHERE product_id = NEW.product_id;
    
    IF v_available < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock available for this order';
    END IF;
END //

DELIMITER ;

-- ==========================================
-- SECTION E: TRANSACTIONS (15 Marks)
-- ==========================================

-- Question 9 (8 Marks): sp_TransferStock
DELIMITER //

CREATE PROCEDURE sp_TransferStock(
    IN p_from_product_id INT,
    IN p_to_product_id INT,
    IN p_quantity INT,
    OUT p_status VARCHAR(100)
)
BEGIN
    DECLARE v_from_stock INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 'FAILED: Transaction rolled back';
    END;
    
    START TRANSACTION;
    
    -- Check source product stock
    SELECT stock_quantity INTO v_from_stock
    FROM products WHERE product_id = p_from_product_id
    FOR UPDATE;
    
    IF v_from_stock IS NULL THEN
        ROLLBACK;
        SET p_status = 'FAILED: Source product not found';
    ELSEIF v_from_stock < p_quantity THEN
        ROLLBACK;
        SET p_status = 'FAILED: Insufficient stock in source product';
    ELSE
        -- Transfer stock
        UPDATE products SET stock_quantity = stock_quantity - p_quantity 
        WHERE product_id = p_from_product_id;
        
        UPDATE products SET stock_quantity = stock_quantity + p_quantity 
        WHERE product_id = p_to_product_id;
        
        COMMIT;
        SET p_status = 'SUCCESS: Stock transferred';
    END IF;
END //

DELIMITER ;

-- Test:
CALL sp_TransferStock(1, 2, 5, @status);
SELECT @status;


-- Question 10 (7 Marks): ACID Explanation
/*
A - Atomicity:
In OnlineStoreDB, when placing an order (sp_PlaceOrder), we create an order 
record AND an order_item record. Both must succeed or both must fail. 
If inserting order_item fails, the order should also be rolled back.

C - Consistency:
Before a transaction, if total products = 100, after transferring 5 units 
between products, total should still = 100. No units should be lost or created.

I - Isolation:
If User A is transferring stock and User B queries stock simultaneously,
User B should see either before-transfer or after-transfer state, never partial.

D - Durability:
Once sp_TransferStock commits, even if server crashes immediately after,
the stock transfer is permanent and will be there after restart.
*/

-- ==========================================
-- SECTION F: SECURITY (10 Marks)
-- ==========================================

-- Question 11 (5 Marks): Create users and grant privileges
CREATE USER 'sales_user'@'localhost' IDENTIFIED BY 'SalesPass123!';
GRANT SELECT ON OnlineStoreDB.orders TO 'sales_user'@'localhost';
GRANT SELECT ON OnlineStoreDB.order_items TO 'sales_user'@'localhost';
GRANT EXECUTE ON PROCEDURE OnlineStoreDB.sp_GetSalesReport TO 'sales_user'@'localhost';
FLUSH PRIVILEGES;


-- Question 12 (5 Marks): Create role and assign
CREATE ROLE 'inventory_manager';
GRANT SELECT, UPDATE ON OnlineStoreDB.products TO 'inventory_manager';
GRANT INSERT ON OnlineStoreDB.audit_log TO 'inventory_manager';

CREATE USER 'stock_user'@'localhost' IDENTIFIED BY 'StockPass123!';
GRANT 'inventory_manager' TO 'stock_user'@'localhost';
SET DEFAULT ROLE 'inventory_manager' TO 'stock_user'@'localhost';
FLUSH PRIVILEGES;

-- ==========================================
-- SECTION G: INDEXING (5 Marks)
-- ==========================================

-- Question 13a (2 Marks): Create composite index
CREATE INDEX idx_customer_orderdate ON orders(customer_id, order_date);

-- Question 13b (3 Marks): Leftmost Prefix Rule explanation
/*
The Leftmost Prefix Rule states that a composite index can only be used 
if the query starts filtering from the leftmost column(s) of the index.

For index (customer_id, order_date):
✅ WHERE customer_id = 1                    -- Uses index (leftmost)
✅ WHERE customer_id = 1 AND order_date...  -- Uses index (both columns)
❌ WHERE order_date = '2024-01-01'          -- Cannot use index (skips customer_id)

This is because the index is sorted by customer_id first, then by order_date 
within each customer_id. Without customer_id filter, MySQL can't efficiently 
navigate the index structure.
*/

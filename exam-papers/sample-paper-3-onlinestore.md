# 📝 ADBMS Final Exam - Sample Paper 3

> **Duration:** 2 Hours  
> **Total Marks:** 100  
> **Database:** OnlineStoreDB

---

## 📋 Database Schema

```sql
CREATE DATABASE OnlineStoreDB;
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
```

---

## SECTION A: VIEWS (15 Marks)

### Question 1 (8 Marks)
Create a view named `vw_CustomerOrderSummary` that displays:
- Customer full name (first_name + last_name)
- Customer email
- Total number of orders placed
- Total amount spent
- Only include customers who have placed at least 2 orders

```sql
-- Your answer here

```

---

### Question 2 (7 Marks)
Create a view named `vw_LowStockProducts` that:
- Shows products where stock_quantity is below min_stock_level
- Include: product_id, product_name, category, stock_quantity, min_stock_level
- Add a column `shortage` showing how many units are needed
- Use WITH CHECK OPTION to prevent inserting products with adequate stock

```sql
-- Your answer here

```

---

## SECTION B: USER-DEFINED FUNCTIONS (15 Marks)

### Question 3 (7 Marks)
Create a function `fn_CalculateOrderTotal` that:
- Accepts order_id as parameter
- Calculates total by summing (quantity × unit_price) from order_items
- Returns the total amount

```sql
-- Your answer here

```

---

### Question 4 (8 Marks)
Create a function `fn_GetCustomerStatus` that:
- Accepts customer_id as parameter
- Returns customer status based on total spending:
  - 'Platinum' if total > 50000
  - 'Gold' if total > 25000
  - 'Silver' if total > 10000
  - 'Bronze' otherwise

```sql
-- Your answer here

```

---

## SECTION C: STORED PROCEDURES (20 Marks)

### Question 5 (10 Marks)
Create a stored procedure `sp_PlaceOrder` that:
- Accepts: customer_id (IN), product_id (IN), quantity (IN), order_id (OUT)
- Creates a new order with status 'Pending'
- Adds item to order_items with current product price
- Calculates and updates total_amount in orders table
- Returns the new order_id

```sql
-- Your answer here

```

---

### Question 6 (10 Marks)
Create a stored procedure `sp_GetSalesReport` that:
- Accepts: start_date (IN), end_date (IN)
- Returns: product_name, total_quantity_sold, total_revenue
- Only for products sold in the date range
- Ordered by total_revenue descending
- Include error handling for invalid dates

```sql
-- Your answer here

```

---

## SECTION D: TRIGGERS (20 Marks)

### Question 7 (10 Marks)
Create a trigger `trg_UpdateStockOnOrder` that:
- Fires AFTER INSERT on order_items
- Decreases stock_quantity in products table
- If stock becomes 0 or negative, logs a warning to audit_log

```sql
-- Your answer here

```

---

### Question 8 (10 Marks)
Create a trigger `trg_PreventNegativeStock` that:
- Fires BEFORE INSERT on order_items
- Checks if sufficient stock is available
- If not, raises a custom error and blocks the insert

```sql
-- Your answer here

```

---

## SECTION E: TRANSACTIONS (15 Marks)

### Question 9 (8 Marks)
Create a stored procedure `sp_TransferStock` that:
- Accepts: from_product_id, to_product_id, quantity
- Transfers stock from one product to another
- Uses transaction to ensure atomicity
- Rolls back if either product doesn't have enough stock or doesn't exist

```sql
-- Your answer here

```

---

### Question 10 (7 Marks)
Explain the ACID properties with examples from the OnlineStoreDB context. (3.5 marks each for any 2)

```
A - Atomicity:


C - Consistency:


I - Isolation:


D - Durability:

```

---

## SECTION F: SECURITY (10 Marks)

### Question 11 (5 Marks)
Write SQL commands to:
1. Create a user 'sales_user'@'localhost' with password 'SalesPass123!'
2. Grant SELECT on orders and order_items tables
3. Grant EXECUTE on sp_GetSalesReport procedure

```sql
-- Your answer here

```

---

### Question 12 (5 Marks)
Create a role `inventory_manager` and:
1. Grant SELECT, UPDATE on products table
2. Grant INSERT on audit_log table
3. Assign this role to a new user 'stock_user'@'localhost'

```sql
-- Your answer here

```

---

## SECTION G: INDEXING (5 Marks)

### Question 13 (5 Marks)
a) Create an appropriate composite index to optimize this query: (2 marks)
```sql
SELECT * FROM orders WHERE customer_id = ? AND order_date BETWEEN ? AND ?;
```

b) Explain the Leftmost Prefix Rule and why `WHERE order_date = ?` alone won't use the above index. (3 marks)

```sql
-- Your answer here (a):


-- Your answer here (b):

```

---

## ✅ Marking Scheme

| Section | Topic | Marks |
|---------|-------|-------|
| A | Views (2 questions) | 15 |
| B | Functions (2 questions) | 15 |
| C | Procedures (2 questions) | 20 |
| D | Triggers (2 questions) | 20 |
| E | Transactions (2 questions) | 15 |
| F | Security (2 questions) | 10 |
| G | Indexing (1 question) | 5 |
| **Total** | **13 Questions** | **100** |

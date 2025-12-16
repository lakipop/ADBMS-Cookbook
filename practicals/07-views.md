# Practical: Views (10 Questions)

> **Category:** Lab/Practical Instructions  
> **Topics:** Simple Views, Join Views, Aggregate Views, WITH CHECK OPTION, View Management

---

## 📋 Base Tables for Practice

```sql
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
```

---

## 🎯 Practice Questions

### Level 1: Basic Views

---

### Question 1: Simple View
**Task:** Create a view called `vw_employee_names` that displays only employee ID and name from the employees table.

```sql
-- Your answer here

```

---

### Question 2: Filtered View
**Task:** Create a view called `vw_high_salary` that shows all employees earning more than 50,000.

```sql
-- Your answer here

```

---

### Question 3: Column Alias View
**Task:** Create a view called `vw_product_info` that displays product_id as "ID", product_name as "Product", and price as "Unit Price".

```sql
-- Your answer here

```

---

### Level 2: Aggregate Views

---

### Question 4: Aggregation View
**Task:** Create a view called `vw_dept_salary_stats` that shows department name, total salary, average salary, and employee count for each department.

```sql
-- Your answer here

```

---

### Question 5: Group By View
**Task:** Create a view called `vw_category_stock` that displays category and total stock quantity for each product category.

```sql
-- Your answer here

```

---

### Level 3: Join Views

---

### Question 6: Join View
**Task:** Create a view called `vw_order_details` that joins orders with products to show order_id, customer_name, product_name, quantity, and total_amount (quantity × price).

```sql
-- Your answer here

```

---

### Question 7: Self-Join View
**Task:** Create a view called `vw_employee_manager` that shows employee name and their manager's name using a self-join.

```sql
-- Your answer here

```

---

### Level 4: Advanced Views

---

### Question 8: View with WITH CHECK OPTION
**Task:** Create a view called `vw_pending_orders` that shows only pending orders. Use WITH CHECK OPTION to ensure any inserted/updated rows must have status = 'Pending'.

```sql
-- Your answer here

```

---

### Question 9: View Based on View
**Task:** Create a view called `vw_expensive_products` that shows products with price > 100. Then create another view `vw_expensive_low_stock` based on the first view, showing only those with stock < 50.

```sql
-- Your answer here

```

---

### Question 10: CREATE OR REPLACE & DROP
**Task:** 
a) Use CREATE OR REPLACE to modify `vw_employee_names` to also include department.
b) Drop the view `vw_category_stock`.

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Q1: Simple View (emp_id, emp_name)
- [ ] Q2: Filtered View (salary > 50000)
- [ ] Q3: Column Alias View
- [ ] Q4: Aggregation View (SUM, AVG, COUNT)
- [ ] Q5: Group By View
- [ ] Q6: Join View (orders + products)
- [ ] Q7: Self-Join View (employee-manager)
- [ ] Q8: WITH CHECK OPTION
- [ ] Q9: View on View
- [ ] Q10: CREATE OR REPLACE & DROP

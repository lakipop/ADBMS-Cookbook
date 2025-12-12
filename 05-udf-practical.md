# Practical Sheet 03: User Defined Functions (UDFs)

> **Category:** Lab/Practical Instructions  
> **Topics:** Scalar Functions, Table-Valued Functions, Inline Functions

---

## 📋 Table Definitions

### Table: `customers`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `customer_id` | int | Customer ID (Primary Key) |
| `first_name` | varchar(50) | First Name |
| `last_name` | varchar(50) | Last Name |
| `phone` | varchar(20) | Phone Number |
| `email` | varchar(100) | Email Address |
| `street` | varchar(100) | Street Address |
| `city` | varchar(50) | City |
| `state` | varchar(50) | State |
| `zip_code` | varchar(10) | Zip Code |

**Sample Data:**
| customer_id | first_name | last_name | phone | email | street | city | state | zip_code |
|-------------|------------|-----------|-------|-------|--------|------|-------|----------|
| 1 | Miriam | Baker | ... | ... | ... | ... | New York | 10001 |
| 2 | Jeanie | Kirkland | ... | ... | ... | ... | California | 90001 |
| 3 | Marquerite | Dawson | ... | ... | ... | ... | New York | 10002 |
| 4 | Babara | Ochoa | ... | ... | ... | ... | Texas | 75001 |
| 5 | Nova | Hess | ... | ... | ... | ... | New York | 10001 |
| 6 | Carley | Reynolds | ... | ... | ... | ... | Florida | 33001 |
| 7 | Carissa | Foreman | ... | ... | ... | ... | California | 90002 |
| 8 | Genoveva | Tyler | ... | ... | ... | ... | New York | 10003 |
| 9 | Deane | Sears | ... | ... | ... | ... | Texas | 75002 |
| 10 | Karey | Steele | ... | ... | ... | ... | Florida | 33002 |
| 11 | Lena | Mills | ... | ... | ... | ... | New York | 10001 |

---

### Table: `Employee`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `ID` | int | Employee ID (Primary Key) |
| `Name` | varchar(50) | Employee Name |
| `Age` | int | Employee Age |
| `Address` | varchar(100) | Employee Address |
| `Salary` | decimal(10,2) | Employee Salary |

**Sample Data:**
| ID | Name | Age | Address | Salary |
|----|------|-----|---------|--------|
| 1 | Ramesh | 32 | Ahmedabad | 2000.00 |
| 2 | Khilan | 25 | Delhi | 1500.00 |
| 3 | Kaushik | 23 | Kota | 2000.00 |
| 4 | Chaitali | 25 | Mumbai | 6500.00 |
| 5 | Hardik | 27 | Bhopal | 8500.00 |
| 6 | Komal | 22 | MP | 4500.00 |

---

## 🎯 Practice Questions

### Question 1: Create Database
**Task:** Create database `MyDatabase`.

```sql
-- Your answer here

```

---

### Question 2: Create 'customers' Table
**Task:** Create table `customers` and insert sample data.

```sql
-- Your answer here (Create table)


-- Your answer here (Insert data)

```

---

### Question 3: Function - Get Customer Full Name
**Task:** Write a user-defined SQL function to get customer id and full name.  
**Output format:** "Miriam Baker"

```sql
-- Your answer here

```

---

### Question 4: Create 'Employee' Table
**Task:** Create table `Employee` with the sample data provided.

```sql
-- Your answer here

```

---

### Question 5: Function - Average Salary
**Task:** Create a function to get the average salary of employees.

```sql
-- Your answer here

```

---

### Question 6: Function - Employees Above Average
**Task:** Create a function to get average salary and find employee ID and Name whose salary is **greater than or equal to** average.

```sql
-- Your answer here

```

---

### Question 7: Scalar Function - Total Price
**Task:** Create a scalar function to compute total price for a detail line in an order (based on quantity, unit price, discount).

**Formula:** `total_price = quantity * unit_price * (1 - discount)`

```sql
-- Your answer here

```

---

### Question 8: Function - Customers in New York
**Task:** Create a function to get all customers' details where state is "New York".

```sql
-- Your answer here

```

---

### Question 9: Table-Valued Function - Customers by Zip Code
**Task:** Create a table-valued function to return a list of customers (first name, street, city) for a specific zip code.

```sql
-- Your answer here

```

---

### Question 10: Table-Valued Function - Employees by ID
**Task:** Create a table-valued function to return a list of employees (name, salary) for a specific ID value.

```sql
-- Your answer here

```

---

### Question 11: Modified Function - Employees by Age Range
**Task:** Modify the function to return a list of employees (name, salary) for a specific **age range**.

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Question 1: Create Database
- [ ] Question 2: Create 'customers' Table
- [ ] Question 3: Function - Get Customer Full Name
- [ ] Question 4: Create 'Employee' Table
- [ ] Question 5: Function - Average Salary
- [ ] Question 6: Function - Employees Above Average
- [ ] Question 7: Scalar Function - Total Price
- [ ] Question 8: Function - Customers in New York
- [ ] Question 9: Table-Valued Function - Customers by Zip Code
- [ ] Question 10: Table-Valued Function - Employees by ID
- [ ] Question 11: Modified Function - Employees by Age Range

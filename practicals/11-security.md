# Practical: Database Security

> **Category:** Lab/Practical Instructions  
> **Topics:** User Management, GRANT, REVOKE, Roles, Views for Security

---

## 📋 Database Setup

### Schema: CompanyDB

```sql
CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    salary DECIMAL(12,2),
    ssn VARCHAR(20),
    department VARCHAR(50),
    hire_date DATE
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    manager_id INT,
    budget DECIMAL(15,2)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100),
    department_id INT,
    budget DECIMAL(12,2),
    start_date DATE,
    end_date DATE
);

CREATE TABLE user_activity_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100),
    action VARCHAR(100),
    table_name VARCHAR(100),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO employees VALUES
(1, 'Kamal', 'Perera', 'kamal@company.com', '0771234567', 85000, 'SSN-001', 'IT', '2020-01-15'),
(2, 'Nimal', 'Silva', 'nimal@company.com', '0772345678', 75000, 'SSN-002', 'HR', '2021-03-20'),
(3, 'Sunil', 'Fernando', 'sunil@company.com', '0773456789', 95000, 'SSN-003', 'Finance', '2019-06-10'),
(4, 'Amara', 'Jayawardena', 'amara@company.com', '0774567890', 65000, 'SSN-004', 'IT', '2022-02-28'),
(5, 'Kumari', 'Rathnayake', 'kumari@company.com', '0775678901', 70000, 'SSN-005', 'HR', '2021-08-15');

INSERT INTO departments VALUES
(1, 'Information Technology', 1, 500000),
(2, 'Human Resources', 2, 200000),
(3, 'Finance', 3, 300000);
```

---

## 🎯 Practice Questions

### Question 1: Create Users
**Task:** Create the following users:
1. `hr_user` - can only access from localhost
2. `finance_user` - can access from any host
3. `readonly_user` - can only access from 192.168.1.*

```sql
-- Your answer here

```

---

### Question 2: Grant SELECT Privileges
**Task:** 
- Grant `readonly_user` SELECT privilege on all tables in CompanyDB
- Grant `hr_user` SELECT on employees table only

```sql
-- Your answer here

```

---

### Question 3: Grant Multiple Privileges
**Task:** Grant `hr_user` the ability to:
- SELECT, INSERT, UPDATE on employees table
- SELECT only on departments table
- Cannot DELETE from any table

```sql
-- Your answer here

```

---

### Question 4: Grant All Privileges
**Task:** Grant `finance_user` all privileges on the Finance-related data:
- Full access to all tables in CompanyDB
- Include the ability to grant permissions to others

```sql
-- Your answer here

```

---

### Question 5: Create Security View
**Task:** Create a view `vw_PublicEmployeeInfo` that shows only:
- employee_id, first_name, last_name, department
- Hides: email, phone, salary, ssn

Then grant SELECT on this view to `readonly_user`.

```sql
-- Your answer here

```

---

### Question 6: Column-Level Privileges
**Task:** Grant `hr_user` permission to UPDATE only the following columns in employees table:
- first_name, last_name, phone, department
- NOT salary or ssn

```sql
-- Your answer here

```

---

### Question 7: Revoke Privileges
**Task:** 
- Revoke INSERT privilege from `hr_user` on employees table
- Revoke all privileges from `readonly_user`

```sql
-- Your answer here

```

---

### Question 8: Create Roles (MySQL 8.0+)
**Task:** Create the following roles and assign privileges:
1. `role_viewer` - SELECT on all tables
2. `role_editor` - SELECT, INSERT, UPDATE on all tables
3. `role_admin` - ALL PRIVILEGES

Then assign `role_viewer` to `readonly_user`.

```sql
-- Your answer here

```

---

### Question 9: Stored Procedure for Security
**Task:** Create a procedure `sp_GetEmployeeSalary` that:
- Takes employee_id as input
- Returns employee name and salary
- Only users with EXECUTE permission can access salary data

```sql
-- Your answer here

```

---

### Question 10: View User Privileges
**Task:** Write queries to:
1. View all users in MySQL
2. View privileges granted to `hr_user`
3. View privileges on employees table

```sql
-- Your answer here

```

---

### Question 11: Password Management
**Task:** 
1. Change password for `hr_user` to 'NewHRPass123!'
2. Show how to hash a password using SHA2

```sql
-- Your answer here

```

---

### Question 12: Audit Trigger
**Task:** Create a trigger that logs all INSERT operations on employees table to user_activity_log.

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Question 1: Create Users
- [ ] Question 2: Grant SELECT Privileges
- [ ] Question 3: Grant Multiple Privileges
- [ ] Question 4: Grant All Privileges
- [ ] Question 5: Create Security View
- [ ] Question 6: Column-Level Privileges
- [ ] Question 7: Revoke Privileges
- [ ] Question 8: Create Roles
- [ ] Question 9: Stored Procedure for Security
- [ ] Question 10: View User Privileges
- [ ] Question 11: Password Management
- [ ] Question 12: Audit Trigger

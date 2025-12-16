# 📖 User-Defined Functions (UDFs) - Theory Notes

> **Topics:** Scalar Functions, Table-Valued Functions, Built-in Functions, UDF vs Stored Procedures

---

## 🤔 What is a Function?

A **Function** is a reusable block of code that takes inputs, performs calculations, and **returns a value**. Unlike procedures, functions MUST return something.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Calculator = You give numbers → It returns result         │
│   Function = You give parameters → It returns value         │
│                                                             │
│   SELECT fn_GetAge('1990-01-15') → Returns: 34              │
└─────────────────────────────────────────────────────────────┘
```

### Key Difference from Procedures:
| Stored Procedure | Function |
|------------------|----------|
| Called with `CALL` | Called in `SELECT` |
| Return is optional | Return is **mandatory** |
| Can return multiple results | Returns **single value** or table |

---

## 📊 Types of Functions

### 1. Built-in Functions (Provided by MySQL)
Already exist in MySQL - just use them!

### 2. User-Defined Functions (UDFs)
You create them for custom logic.

```
┌─────────────────────────────────────────────────────────────┐
│                    FUNCTION TYPES                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BUILT-IN                    USER-DEFINED                   │
│  ├── Aggregate (SUM, AVG)    ├── Scalar (returns 1 value)   │
│  ├── String (CONCAT, UPPER)  └── Table-Valued (returns set) │
│  ├── Date (NOW, DATEDIFF)                                   │
│  ├── Math (ROUND, ABS)                                      │
│  └── Control (IF, CASE)                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Built-in Functions Reference

### Aggregate Functions
Calculate values from multiple rows.

| Function | Description | Example |
|----------|-------------|---------|
| `COUNT()` | Count rows | `COUNT(*)` |
| `SUM()` | Add values | `SUM(salary)` |
| `AVG()` | Average | `AVG(marks)` |
| `MAX()` | Maximum | `MAX(price)` |
| `MIN()` | Minimum | `MIN(age)` |

### String Functions
Manipulate text data.

| Function | Description | Example |
|----------|-------------|---------|
| `CONCAT()` | Join strings | `CONCAT(first, ' ', last)` |
| `LENGTH()` | String length | `LENGTH('Hello')` → 5 |
| `UPPER()` | Uppercase | `UPPER('hello')` → 'HELLO' |
| `LOWER()` | Lowercase | `LOWER('HELLO')` → 'hello' |
| `SUBSTRING()` | Extract part | `SUBSTRING('Hello', 1, 3)` → 'Hel' |
| `TRIM()` | Remove spaces | `TRIM('  Hi  ')` → 'Hi' |

### Date/Time Functions
Work with dates and times.

| Function | Description | Example |
|----------|-------------|---------|
| `NOW()` | Current datetime | `2025-12-16 17:30:00` |
| `CURDATE()` | Current date | `2025-12-16` |
| `YEAR()` | Extract year | `YEAR('2025-12-16')` → 2025 |
| `MONTH()` | Extract month | `MONTH('2025-12-16')` → 12 |
| `DATEDIFF()` | Days between | `DATEDIFF('2025-12-31', '2025-12-16')` → 15 |
| `DATE_ADD()` | Add interval | `DATE_ADD(NOW(), INTERVAL 7 DAY)` |

### Math Functions
| Function | Description | Example |
|----------|-------------|---------|
| `ROUND()` | Round number | `ROUND(3.567, 2)` → 3.57 |
| `CEIL()` | Round up | `CEIL(3.1)` → 4 |
| `FLOOR()` | Round down | `FLOOR(3.9)` → 3 |
| `ABS()` | Absolute value | `ABS(-5)` → 5 |
| `MOD()` | Remainder | `MOD(10, 3)` → 1 |

### Control Flow Functions
| Function | Description | Example |
|----------|-------------|---------|
| `IF()` | If-then-else | `IF(score>=50, 'Pass', 'Fail')` |
| `IFNULL()` | Replace NULL | `IFNULL(phone, 'N/A')` |
| `COALESCE()` | First non-NULL | `COALESCE(mobile, home, 'None')` |
| `NULLIF()` | NULL if equal | `NULLIF(a, b)` |
| `CASE` | Multiple conditions | See example below |

```sql
-- CASE example
SELECT name,
    CASE 
        WHEN marks >= 75 THEN 'A'
        WHEN marks >= 60 THEN 'B'
        WHEN marks >= 45 THEN 'C'
        ELSE 'F'
    END AS grade
FROM students;
```

---

## 🔨 Creating User-Defined Functions

### Basic Syntax
```sql
DELIMITER //

CREATE FUNCTION function_name(parameter datatype)
RETURNS return_datatype
DETERMINISTIC
BEGIN
    DECLARE variable datatype;
    -- logic here
    RETURN value;
END //

DELIMITER ;
```

### Required Keywords:
| Keyword | Purpose |
|---------|---------|
| `RETURNS` | Specify return data type |
| `DETERMINISTIC` | Same input = same output |
| `READS SQL DATA` | Function reads from tables |
| `RETURN` | Send back the result |

---

## 📝 UDF Examples

### Example 1: Simple Calculation
```sql
DELIMITER //

CREATE FUNCTION fn_CalculateAge(birthdate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, birthdate, CURDATE());
END //

DELIMITER ;

-- Usage:
SELECT name, fn_CalculateAge(dob) AS age FROM students;
```

### Example 2: Get Full Name
```sql
DELIMITER //

CREATE FUNCTION fn_GetFullName(first VARCHAR(50), last VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first, ' ', last);
END //

DELIMITER ;

-- Usage:
SELECT fn_GetFullName(first_name, last_name) AS full_name FROM employees;
```

### Example 3: Calculate Grade
```sql
DELIMITER //

CREATE FUNCTION fn_GetGrade(marks INT)
RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    DECLARE grade CHAR(1);
    
    IF marks >= 75 THEN SET grade = 'A';
    ELSEIF marks >= 65 THEN SET grade = 'B';
    ELSEIF marks >= 55 THEN SET grade = 'C';
    ELSEIF marks >= 45 THEN SET grade = 'S';
    ELSE SET grade = 'F';
    END IF;
    
    RETURN grade;
END //

DELIMITER ;

-- Usage:
SELECT name, marks, fn_GetGrade(marks) AS grade FROM students;
```

### Example 4: Read from Database
```sql
DELIMITER //

CREATE FUNCTION fn_GetStudentName(studentID INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE studentName VARCHAR(100);
    
    SELECT name INTO studentName
    FROM students
    WHERE id = studentID;
    
    RETURN IFNULL(studentName, 'Not Found');
END //

DELIMITER ;

-- Usage:
SELECT fn_GetStudentName(5);
```

### Example 5: Calculate Fine
```sql
DELIMITER //

CREATE FUNCTION fn_CalculateFine(dueDate DATE, returnDate DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE days_late INT;
    DECLARE fine DECIMAL(10,2);
    
    SET days_late = DATEDIFF(returnDate, dueDate);
    
    IF days_late > 0 THEN
        SET fine = days_late * 10;  -- Rs. 10 per day
    ELSE
        SET fine = 0;
    END IF;
    
    RETURN fine;
END //

DELIMITER ;
```

---

## ❌ Table-Valued Functions in MySQL

**Important:** MySQL does NOT support true table-valued functions like SQL Server.

### Workarounds:
1. **Use Stored Procedures** - Return result sets
2. **Use Views** - Create parameterized views
3. **Use Temporary Tables** - Store results

```sql
-- Instead of table-valued function, use procedure:
DELIMITER //

CREATE PROCEDURE sp_GetStudentsByGrade(IN grade CHAR(1))
BEGIN
    SELECT * FROM students WHERE student_grade = grade;
END //

DELIMITER ;

-- Call:
CALL sp_GetStudentsByGrade('A');
```

---

## ⚖️ Function vs Stored Procedure

| Feature | Function | Stored Procedure |
|---------|----------|------------------|
| **Call Method** | `SELECT fn_name()` | `CALL sp_name()` |
| **Return Value** | Mandatory | Optional |
| **Use in SELECT/WHERE** | ✅ Yes | ❌ No |
| **Multiple Results** | ❌ No | ✅ Yes |
| **DML (INSERT/UPDATE)** | ⚠️ Limited | ✅ Yes |
| **Transactions** | ❌ No | ✅ Yes |
| **Call from Trigger** | ✅ Yes | ✅ Yes |

### When to Use Function:
- Need to use result in SELECT/WHERE
- Single value calculation
- No side effects (data changes)

### When to Use Procedure:
- Need to modify data
- Return multiple result sets
- Complex transaction logic

---

## 🔄 Managing Functions

### View All Functions
```sql
SHOW FUNCTION STATUS WHERE Db = 'database_name';
```

### View Function Definition
```sql
SHOW CREATE FUNCTION function_name;
```

### Delete Function
```sql
DROP FUNCTION IF EXISTS function_name;
```

---

## 📝 Common Exam Questions

### Q1: What is the difference between a Function and Stored Procedure?
**Answer:** Functions must return a value and can be used in SELECT statements. Procedures are called with CALL, can return multiple results, and are used for data manipulation.

### Q2: What types of UDFs exist?
**Answer:**
- **Scalar Functions:** Return single value
- **Table-Valued Functions:** Return a table (not supported in MySQL)

### Q3: What does DETERMINISTIC mean?
**Answer:** A deterministic function always returns the same result for the same input parameters. Required for functions in MySQL.

### Q4: Can functions modify table data?
**Answer:** Functions have limited ability to modify data. For INSERT/UPDATE/DELETE, use stored procedures instead.

### Q5: List 3 built-in aggregate functions.
**Answer:** COUNT(), SUM(), AVG(), MAX(), MIN() (any 3)

---

## ✅ Quick Reference

```sql
-- Create function
DELIMITER //
CREATE FUNCTION fn_name(param INT)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result VARCHAR(50);
    -- logic
    RETURN result;
END //
DELIMITER ;

-- Use function
SELECT fn_name(5);
SELECT name, fn_name(id) FROM table;
SELECT * FROM table WHERE fn_name(col) = 'value';

-- View functions
SHOW FUNCTION STATUS WHERE Db = 'mydb';

-- Delete function
DROP FUNCTION IF EXISTS fn_name;
```

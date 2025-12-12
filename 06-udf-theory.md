# User Defined Functions (UDFs) - Theory

> **Category:** Lecture Slides (Theory)  
> **Topics:** Built-in Functions, UDF Types, Scalar Functions, Table-Valued Functions

---

## 📚 Database Functions Overview

Functions enhance SQL power and can be invoked in `SELECT`, `FROM`, and `WHERE` clauses.

### Classifications

| Type | Description |
|------|-------------|
| **Built-in** | Incorporated in DBMS (e.g., MAX, SUBSTR) |
| **User Defined (UDFs)** | Written by the user/customer |

---

## 🔧 Built-in Function Types

### 1. Aggregate Functions
Used to perform calculations on a set of values and return a single value.

| Function | Description |
|----------|-------------|
| `AVG()` | Average value |
| `COUNT()` | Number of rows |
| `SUM()` | Sum of values |
| `MAX()` | Maximum value |
| `MIN()` | Minimum value |

### 2. String Functions
Used for string manipulation.

| Function | Description |
|----------|-------------|
| `CONCAT()` | Concatenate strings |
| `LENGTH()` | String length |
| `SUBSTRING()` | Extract substring |
| `TRIM()` | Remove leading/trailing spaces |
| `UPPER()` / `LOWER()` | Change case |

### 3. Control Flow Functions
| Function | Description |
|----------|-------------|
| `CASE` | Conditional logic |
| `IF()` | If-then-else logic |
| `IFNULL()` | Handle NULL values |
| `NULLIF()` | Return NULL if equal |

### 4. Date/Time Functions
| Function | Description |
|----------|-------------|
| `CURDATE()` | Current date |
| `NOW()` | Current date and time |
| `YEAR()` | Extract year |
| `MONTH()` | Extract month |
| `DATEDIFF()` | Difference between dates |

### 5. Comparison Functions
| Function | Description |
|----------|-------------|
| `COALESCE()` | First non-NULL value |
| `GREATEST()` | Largest value |
| `LEAST()` | Smallest value |
| `ISNULL()` | Check if NULL |

### 6. Math Functions
| Function | Description |
|----------|-------------|
| `ABS()` | Absolute value |
| `CEIL()` | Round up |
| `FLOOR()` | Round down |
| `ROUND()` | Round to decimal places |
| `MOD()` | Modulus |

---

## 📝 User-Defined Functions (UDF)

### Types of UDFs

```
┌─────────────────────────────────────────────────────────┐
│                    UDF Types                             │
├─────────────────┬─────────────────┬─────────────────────┤
│   Scalar        │  Table Function │  Multi-Statement    │
│   (one value)   │  (returns table)│  Function           │
└─────────────────┴─────────────────┴─────────────────────┘
```

### Categories of UDFs

| Category | Description |
|----------|-------------|
| **External** | Written in host language (C, Java, etc.) |
| **SQL** | Code written in SQL within definition |
| **Sourced** | Based on existing function |

---

## ❓ Why Use UDFs?

1. **Special transformations** - Custom data transformations
2. **Simple calculations** - Years of service, age calculations
3. **Standardization** - Consistent business logic
4. **Migration** - Easier code migration
5. **Embedding complex logic** - Simpler SQL statements

---

## 🔨 Creating a UDF

### Steps to Create
1. Set up environment
2. Write/Prepare function code
3. Define to DBMS
4. Invoke from SQL

### Basic Syntax (SQL Server Style)
```sql
CREATE FUNCTION dbo.function_name (@param datatype)
RETURNS datatype
AS
BEGIN
    -- Function logic here
    RETURN value
END
```

### MySQL Syntax
```sql
DELIMITER //
CREATE FUNCTION function_name(param datatype)
RETURNS datatype
DETERMINISTIC
BEGIN
    DECLARE variable datatype;
    -- Function logic here
    RETURN value;
END //
DELIMITER ;
```

---

## 📊 Types of UDFs in Detail

### 1. Scalar Functions
- Returns a **single value**
- Cannot return: text, ntext, image, cursor, timestamp

**Example: Calculate Circle Area**
```sql
CREATE FUNCTION dbo.CalculateCircleArea(@radius FLOAT)
RETURNS FLOAT
AS
BEGIN
    RETURN PI() * @radius * @radius
END
```

**Usage:**
```sql
SELECT dbo.CalculateCircleArea(5) AS Area;
```

---

### 2. Inline Table-Valued Functions
- Returns a **table variable** from a single SELECT
- No BEGIN/END needed
- No need to specify table variable name

**Example: Get Employees by Department**
```sql
CREATE FUNCTION GetEmployeesByDepartment(@deptId INT)
RETURNS TABLE
AS
RETURN (
    SELECT EmployeeId, Name, Salary
    FROM Employees
    WHERE DepartmentId = @deptId
);
```

**Usage:**
```sql
SELECT * FROM GetEmployeesByDepartment(5);
```

---

### 3. Multi-Statement Table-Valued Functions
- Uses **multiple statements** to build returned table
- Table variable must be **explicitly declared**
- Can be used in FROM clause

**Example: Get Employees by Salary Range**
```sql
CREATE FUNCTION GetEmployeesBySalaryRange(@minSalary DECIMAL, @maxSalary DECIMAL)
RETURNS @EmployeeTable TABLE (
    EmployeeId INT,
    Name VARCHAR(100),
    Salary DECIMAL
)
AS
BEGIN
    INSERT INTO @EmployeeTable
    SELECT EmployeeId, Name, Salary
    FROM Employees
    WHERE Salary BETWEEN @minSalary AND @maxSalary;
    
    RETURN;
END
```

---

## ⚖️ Stored Procedures vs UDFs

| Feature | Stored Procedure | User-Defined Function |
|---------|------------------|----------------------|
| **Call Method** | `EXEC/CALL` | Within SQL statement |
| **Return Value** | Optional | Mandatory |
| **Server Variables** | Can change | Cannot change |
| **Error Handling** | Can continue | Stops on error |
| **Result Sets** | Multiple | Single |
| **Usage in Clauses** | Cannot use in SELECT/WHERE/FROM | Can use in SELECT/WHERE/FROM |
| **Non-deterministic Functions** | Can use (GETDATE, NEWID) | Cannot use |

---

## 🎯 Practice Questions

### Question 1: Function Types
**Q:** What are the three types of User-Defined Functions?

```
Your answer:


```

---

### Question 2: Scalar vs Table-Valued
**Q:** What is the main difference between a Scalar function and a Table-Valued function?

```
Your answer:


```

---

### Question 3: When to Use UDFs
**Q:** List 3 scenarios where you would use a UDF instead of a stored procedure.

```
Your answer:


```

---

### Question 4: Built-in Functions
**Q:** Categorize these functions: AVG, CONCAT, NOW, ROUND, CASE, MAX

```
Your answer:


```

---

### Question 5: Function Limitations
**Q:** What data types cannot be returned by a Scalar function?

```
Your answer:


```

---

### Question 6: Multi-Statement vs Inline
**Q:** What is the key difference between Inline Table-Valued and Multi-Statement Table-Valued functions?

```
Your answer:


```

---

### Question 7: SP vs UDF Comparison
**Q:** Why can't UDFs use non-deterministic functions like GETDATE()?

```
Your answer:


```

---

## ✅ Checklist
- [ ] Understand difference between Built-in and UDF
- [ ] Know all Built-in function categories
- [ ] Understand Scalar Functions
- [ ] Understand Inline Table-Valued Functions
- [ ] Understand Multi-Statement Table-Valued Functions
- [ ] Know differences between SP and UDF
- [ ] Practice creating each type of UDF

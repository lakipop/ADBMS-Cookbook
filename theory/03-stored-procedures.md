# 📖 Stored Procedures - Theory Notes

> **Topics:** Procedures, Parameters (IN/OUT/INOUT), Control Flow, Error Handling

---

## 🤔 What is a Stored Procedure?

A **Stored Procedure** is a group of SQL statements saved in the database that can be executed together with a single command.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Regular SQL = Cooking from scratch every time             │
│   Stored Procedure = Pre-made recipe you just execute       │
│                                                             │
│   Write once, call many times!                              │
└─────────────────────────────────────────────────────────────┘
```

### Key Features:
- 📦 **Stored in database** - Not in application code
- ⚡ **Pre-compiled** - Faster execution
- 🔄 **Reusable** - Call multiple times
- 🔒 **Secure** - Control access permissions

---

## 🔨 Creating Stored Procedures

### Basic Syntax (MySQL)
```sql
DELIMITER //

CREATE PROCEDURE procedure_name(parameters)
BEGIN
    -- SQL statements here
END //

DELIMITER ;
```

### Why DELIMITER?
MySQL uses `;` to end statements. Inside procedure, we have multiple `;`. So we temporarily change delimiter to `//`.

```
Without DELIMITER:
CREATE PROCEDURE sp_test()
BEGIN
    SELECT * FROM table;  ← MySQL thinks procedure ends here!
END;

With DELIMITER:
DELIMITER //
CREATE PROCEDURE sp_test()
BEGIN
    SELECT * FROM table;  ← Now this is just part of procedure
END //                    ← NOW procedure ends
DELIMITER ;               ← Back to normal
```

---

## 📋 Parameter Types

Procedures can have **three types** of parameters:

| Type | Direction | Purpose |
|------|-----------|---------|
| `IN` | Into procedure | Pass value TO procedure |
| `OUT` | Out of procedure | Get value FROM procedure |
| `INOUT` | Both ways | Pass in AND get out |

### IN Parameter (Default)
```sql
CREATE PROCEDURE sp_GetStudent(IN studentID INT)
BEGIN
    SELECT * FROM students WHERE id = studentID;
END;

-- Call:
CALL sp_GetStudent(5);
```

### OUT Parameter
```sql
CREATE PROCEDURE sp_CountStudents(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total FROM students;
END;

-- Call:
CALL sp_CountStudents(@count);
SELECT @count;  -- Shows the result
```

### INOUT Parameter
```sql
CREATE PROCEDURE sp_DoubleNumber(INOUT num INT)
BEGIN
    SET num = num * 2;
END;

-- Call:
SET @myNum = 5;
CALL sp_DoubleNumber(@myNum);
SELECT @myNum;  -- Shows 10
```

### Visual Flow:
```
┌────────────┐
│    IN      │  Value goes IN → (read only)
├────────────┤
│    OUT     │  Value comes OUT ← (write only)
├────────────┤
│   INOUT    │  Goes IN → processed → comes OUT ←→
└────────────┘
```

---

## 🎛️ Variables in Procedures

### Declaring Variables
```sql
DECLARE variable_name datatype [DEFAULT value];
```

### Example:
```sql
CREATE PROCEDURE sp_Calculate()
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE average DECIMAL(10,2);
    
    SELECT COUNT(*) INTO total FROM students;
    SELECT AVG(marks) INTO average FROM students;
    
    SELECT total, average;
END;
```

---

## 🔄 Control Flow Statements

### IF...THEN...ELSE
```sql
IF condition THEN
    -- statements
ELSEIF another_condition THEN
    -- statements
ELSE
    -- statements
END IF;
```

**Example:**
```sql
CREATE PROCEDURE sp_GetGrade(IN marks INT, OUT grade VARCHAR(2))
BEGIN
    IF marks >= 75 THEN
        SET grade = 'A';
    ELSEIF marks >= 65 THEN
        SET grade = 'B';
    ELSEIF marks >= 55 THEN
        SET grade = 'C';
    ELSEIF marks >= 45 THEN
        SET grade = 'S';
    ELSE
        SET grade = 'F';
    END IF;
END;
```

### CASE Statement
```sql
CASE expression
    WHEN value1 THEN statements;
    WHEN value2 THEN statements;
    ELSE statements;
END CASE;
```

**Example:**
```sql
CASE status
    WHEN 'A' THEN SET message = 'Active';
    WHEN 'I' THEN SET message = 'Inactive';
    ELSE SET message = 'Unknown';
END CASE;
```

### WHILE Loop
```sql
WHILE condition DO
    -- statements
END WHILE;
```

**Example:**
```sql
DECLARE counter INT DEFAULT 1;
WHILE counter <= 10 DO
    INSERT INTO numbers VALUES (counter);
    SET counter = counter + 1;
END WHILE;
```

### LOOP with LEAVE
```sql
loop_label: LOOP
    -- statements
    IF condition THEN
        LEAVE loop_label;  -- Exit loop
    END IF;
END LOOP;
```

---

## ⚠️ Error Handling

### DECLARE HANDLER Syntax
```sql
DECLARE handler_action HANDLER FOR condition statement;
```

### Handler Actions:
| Action | Behavior |
|--------|----------|
| `EXIT` | Stop procedure after handling |
| `CONTINUE` | Continue to next statement |

### Common Error Codes:
| Code | Meaning |
|------|---------|
| `1062` | Duplicate key |
| `1452` | Foreign key violation |
| `SQLEXCEPTION` | Any SQL error |
| `NOT FOUND` | No data found |

### Example with Error Handling:
```sql
CREATE PROCEDURE sp_SafeInsert(IN studentID INT, IN name VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT 'Error: Duplicate student ID!' AS Message;
    END;
    
    INSERT INTO students (id, name) VALUES (studentID, name);
    SELECT 'Student added successfully!' AS Message;
END;
```

---

## ✅ Advantages of Stored Procedures

| Advantage | Explanation |
|-----------|-------------|
| **Performance** | Pre-compiled, cached execution plan |
| **Reduced Network** | One call instead of multiple queries |
| **Security** | Grant EXECUTE without table access |
| **Reusability** | Write once, call from anywhere |
| **Maintainability** | Change logic in one place |

---

## ⚠️ Disadvantages

| Disadvantage | Explanation |
|--------------|-------------|
| **Database Lock-in** | Tied to specific DBMS |
| **Debugging** | Harder to debug than app code |
| **Version Control** | Difficult to track changes |
| **Testing** | Limited unit testing support |

---

## ⚖️ Stored Procedure vs Function

| Feature | Stored Procedure | Function |
|---------|------------------|----------|
| **Call Method** | `CALL sp_name()` | `SELECT fn_name()` |
| **Return Value** | Optional | Mandatory |
| **Use in SELECT** | ❌ No | ✅ Yes |
| **Multiple Results** | ✅ Yes | ❌ No |
| **DML Operations** | ✅ Can INSERT/UPDATE/DELETE | ⚠️ Limited |
| **Transaction** | ✅ Can use | ❌ Cannot |

---

## 📝 Common Exam Questions

### Q1: What is a Stored Procedure?
**Answer:** A stored procedure is a group of pre-compiled SQL statements stored in the database that can be executed together using CALL command.

### Q2: Explain IN, OUT, INOUT parameters
**Answer:**
- **IN:** Pass value into procedure (default, read-only)
- **OUT:** Return value from procedure (write-only)
- **INOUT:** Both pass in and return value

### Q3: Why use DELIMITER when creating procedures?
**Answer:** Because procedures contain multiple semicolons inside. DELIMITER temporarily changes the end-of-statement marker so MySQL doesn't prematurely end the CREATE PROCEDURE statement.

### Q4: What error handling options exist?
**Answer:** 
- **EXIT HANDLER:** Stop procedure on error
- **CONTINUE HANDLER:** Handle error and continue

### Q5: List 3 advantages of stored procedures
**Answer:**
1. Better performance (pre-compiled)
2. Reduced network traffic
3. Enhanced security

---

## ✅ Quick Reference

```sql
-- Create procedure
DELIMITER //
CREATE PROCEDURE sp_name(IN param1 INT, OUT param2 VARCHAR(50))
BEGIN
    -- statements
END //
DELIMITER ;

-- Call procedure
CALL sp_name(value, @output);
SELECT @output;

-- View all procedures
SHOW PROCEDURE STATUS WHERE Db = 'database_name';

-- View procedure definition
SHOW CREATE PROCEDURE sp_name;

-- Delete procedure
DROP PROCEDURE IF EXISTS sp_name;
```

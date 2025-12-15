# Error Handling in MySQL - Theory

> **Category:** Theory Notes  
> **Topics:** DECLARE HANDLER, EXIT, CONTINUE, Error Codes

---

## 📚 What is Error Handling?

Error handling allows stored programs to **catch and respond to errors** instead of crashing.

Without error handling: Error → Program crashes
With error handling: Error → Handler runs → Continue or Exit gracefully

---

## 📝 Basic Syntax

```sql
DECLARE handler_action HANDLER FOR condition statement;
```

---

## 🔧 Handler Actions

| Action | Behavior |
|--------|----------|
| `EXIT` | Stop procedure immediately after handler |
| `CONTINUE` | Continue with next statement after handler |

---

## 🎯 Common Conditions

| Condition | Meaning |
|-----------|---------|
| `1062` | Duplicate key error |
| `1452` | Foreign key constraint error |
| `SQLEXCEPTION` | Any SQL error (catch-all) |
| `NOT FOUND` | SELECT INTO returned no rows |
| `SQLWARNING` | Any warning |

---

## 📍 Where Can Error Handlers Be Used?

| Object | Supported? |
|--------|------------|
| Stored Procedures | ✅ Yes |
| Functions | ✅ Yes |
| Triggers | ✅ Yes |
| Events | ✅ Yes |
| Plain SQL queries | ❌ No |

---

## 📝 Examples

### Example 1: EXIT Handler - Duplicate Key

```sql
DELIMITER //

CREATE PROCEDURE sp_AddStudent(IN p_id INT, IN p_name VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT 'Error: Student ID already exists!' AS Message;
    END;
    
    INSERT INTO students (StudentID, Name) VALUES (p_id, p_name);
    SELECT 'Student added successfully!' AS Message;
END //

DELIMITER ;

-- If duplicate: Shows error message and stops
-- If success: Shows success message
```

---

### Example 2: CONTINUE Handler - Count Errors

```sql
DELIMITER //

CREATE PROCEDURE sp_InsertWithCount(IN p_id INT, OUT p_status INT)
BEGIN
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SET p_status = -1;  -- Mark as failed
    END;
    
    SET p_status = 0;
    INSERT INTO students (StudentID, Name) VALUES (p_id, 'Test');
    
    IF p_status = 0 THEN
        SET p_status = 1;  -- Mark as success
    END IF;
END //

DELIMITER ;

-- p_status: 1 = success, -1 = duplicate error
```

---

### Example 3: SQLEXCEPTION - Catch All Errors

```sql
DELIMITER //

CREATE PROCEDURE sp_SafeInsert(IN p_id INT, IN p_name VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An unexpected error occurred!' AS Message;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    INSERT INTO students VALUES (p_id, p_name);
    COMMIT;
    SELECT 'Success!' AS Message;
END //

DELIMITER ;

-- Catches ANY SQL error, rolls back, and exits
```

---

### Example 4: NOT FOUND Handler

```sql
DELIMITER //

CREATE PROCEDURE sp_GetStudent(IN p_id INT, OUT p_name VARCHAR(50))
BEGIN
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET p_name = 'NOT FOUND';
    END;
    
    SELECT Name INTO p_name FROM students WHERE StudentID = p_id;
END //

DELIMITER ;

-- If student doesn't exist, p_name = 'NOT FOUND'
```

---

### Example 5: Multiple Handlers

```sql
DELIMITER //

CREATE PROCEDURE sp_ComplexInsert(IN p_id INT, OUT p_result VARCHAR(50))
BEGIN
    -- Handler for duplicate key
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SET p_result = 'DUPLICATE_ERROR';
    END;
    
    -- Handler for foreign key error
    DECLARE CONTINUE HANDLER FOR 1452
    BEGIN
        SET p_result = 'FK_ERROR';
    END;
    
    SET p_result = 'SUCCESS';
    INSERT INTO enrollments (StudentID, CourseID) VALUES (p_id, 101);
END //

DELIMITER ;

-- Returns specific error type or SUCCESS
```

---

## 🔄 EXIT vs CONTINUE - Visual

```
EXIT Handler:
┌──────────┐    ┌───────┐    ┌─────────────┐
│ SQL Runs │ ─► │ ERROR │ ─► │ Handler     │ ─► STOP (Exit procedure)
└──────────┘    └───────┘    │ Runs        │
                             └─────────────┘

CONTINUE Handler:
┌──────────┐    ┌───────┐    ┌─────────────┐    ┌──────────────┐
│ SQL Runs │ ─► │ ERROR │ ─► │ Handler     │ ─► │ Next Line    │
└──────────┘    └───────┘    │ Runs        │    │ Continues    │
                             └─────────────┘    └──────────────┘
```

---

## ✅ Quick Reference

```sql
-- EXIT on duplicate
DECLARE EXIT HANDLER FOR 1062 BEGIN ... END;

-- CONTINUE on any error
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN ... END;

-- NOT FOUND (for SELECT INTO)
DECLARE CONTINUE HANDLER FOR NOT FOUND SET var = NULL;
```

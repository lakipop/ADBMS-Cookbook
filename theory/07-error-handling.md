# 📖 Error Handling - Theory Notes

> **Topics:** DECLARE HANDLER, EXIT vs CONTINUE, Error Codes, SIGNAL SQLSTATE

---

## 🤔 What is Error Handling?

**Error Handling** allows stored programs to gracefully catch and respond to errors instead of crashing unexpectedly.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Without error handling:                                   │
│   Error → Crash! 💥 → User sees ugly error message          │
│                                                             │
│   With error handling:                                      │
│   Error → Handler catches it → Clean response to user       │
└─────────────────────────────────────────────────────────────┘
```

---

## 📍 Where Can You Use Error Handling?

| Object | Can Use HANDLER? |
|--------|------------------|
| Stored Procedures | ✅ Yes |
| Functions | ✅ Yes |
| Triggers | ✅ Yes |
| Events | ✅ Yes |
| Plain SQL (SELECT, INSERT) | ❌ No |

**Error handlers work in any stored program, NOT in standalone SQL queries!**

---

## 🔨 Basic Syntax

```sql
DECLARE handler_action HANDLER FOR condition statement;
```

### Components:
1. **handler_action:** What to do after handling (EXIT or CONTINUE)
2. **condition:** What error to catch
3. **statement:** What to execute when error occurs

---

## 🎛️ Handler Actions

### EXIT Handler
**Stops** the procedure immediately after handling the error.

```sql
DECLARE EXIT HANDLER FOR 1062
BEGIN
    SELECT 'Duplicate entry error!' AS Message;
END;
-- After handler runs → Procedure STOPS
```

### CONTINUE Handler
**Continues** to the next statement after handling the error.

```sql
DECLARE CONTINUE HANDLER FOR 1062
BEGIN
    SET @error_occurred = 1;
END;
-- After handler runs → Procedure CONTINUES
```

### Visual Comparison:
```
EXIT Handler:
┌──────────┐    ┌───────┐    ┌─────────────┐
│ SQL Runs │ ─► │ ERROR │ ─► │ Handler     │ ─► STOP ■
└──────────┘    └───────┘    │ Runs        │
                             └─────────────┘

CONTINUE Handler:
┌──────────┐    ┌───────┐    ┌─────────────┐    ┌──────────────┐
│ SQL Runs │ ─► │ ERROR │ ─► │ Handler     │ ─► │ Next Line    │ ─►
└──────────┘    └───────┘    │ Runs        │    │ Continues    │
                             └─────────────┘    └──────────────┘
```

---

## 🎯 Error Conditions

### Specific Error Codes
```sql
DECLARE EXIT HANDLER FOR 1062 ...;  -- Duplicate key error
DECLARE EXIT HANDLER FOR 1452 ...;  -- Foreign key violation
```

### Common Error Codes:
| Code | Error |
|------|-------|
| `1062` | Duplicate entry (unique constraint) |
| `1452` | Foreign key constraint fails (insert/update) |
| `1451` | Foreign key constraint fails (delete) |
| `1048` | Column cannot be null |
| `1054` | Unknown column |

### General Conditions
| Condition | Catches |
|-----------|---------|
| `SQLEXCEPTION` | Any SQL error |
| `SQLWARNING` | Any SQL warning |
| `NOT FOUND` | No data found (for SELECT INTO) |

---

## 📝 Complete Examples

### Example 1: EXIT Handler for Duplicate Key

```sql
DELIMITER //

CREATE PROCEDURE sp_AddStudent(IN p_id INT, IN p_name VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT 'ERROR: Student ID already exists!' AS Message;
    END;
    
    INSERT INTO students (id, name) VALUES (p_id, p_name);
    SELECT 'Student added successfully!' AS Message;
END //

DELIMITER ;

-- Test:
-- CALL sp_AddStudent(1, 'John');  -- First time: Success
-- CALL sp_AddStudent(1, 'Jane');  -- Second time: Error message
```

### Example 2: CONTINUE Handler to Track Errors

```sql
DELIMITER //

CREATE PROCEDURE sp_InsertWithTracking(IN p_id INT, OUT p_status INT)
BEGIN
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SET p_status = -1;  -- Mark as failed
    END;
    
    SET p_status = 0;  -- Initial state
    INSERT INTO students (id) VALUES (p_id);
    
    -- This line WILL run even if error occurred
    IF p_status = 0 THEN
        SET p_status = 1;  -- Mark as success
    END IF;
END //

DELIMITER ;

-- p_status: 1 = success, -1 = duplicate error, 0 = other issue
```

### Example 3: Catch Any Error (SQLEXCEPTION)

```sql
DELIMITER //

CREATE PROCEDURE sp_SafeInsert(IN p_id INT, IN p_name VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error occurred. Transaction rolled back.' AS Message;
    END;
    
    START TRANSACTION;
    INSERT INTO students (id, name) VALUES (p_id, p_name);
    INSERT INTO enrollment (student_id) VALUES (p_id);
    COMMIT;
    SELECT 'Success!' AS Message;
END //

DELIMITER ;
```

### Example 4: NOT FOUND Handler (for SELECT INTO)

```sql
DELIMITER //

CREATE PROCEDURE sp_GetStudentName(IN p_id INT, OUT p_name VARCHAR(50))
BEGIN
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET p_name = 'NOT FOUND';
    END;
    
    SELECT name INTO p_name FROM students WHERE id = p_id;
END //

DELIMITER ;

-- If student doesn't exist, p_name = 'NOT FOUND'
```

### Example 5: Multiple Handlers

```sql
DELIMITER //

CREATE PROCEDURE sp_ComplexInsert(IN p_id INT, OUT p_result VARCHAR(50))
BEGIN
    -- Handler for duplicate key
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SET p_result = 'DUPLICATE_KEY_ERROR';
    END;
    
    -- Handler for foreign key error
    DECLARE CONTINUE HANDLER FOR 1452
    BEGIN
        SET p_result = 'FOREIGN_KEY_ERROR';
    END;
    
    -- Handler for any other error
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_result = 'UNKNOWN_ERROR';
    END;
    
    SET p_result = 'SUCCESS';
    INSERT INTO enrollments (student_id, course_id) VALUES (p_id, 101);
END //

DELIMITER ;
```

---

## 🚨 SIGNAL SQLSTATE - Raise Custom Errors

Use `SIGNAL` to throw your own errors:

```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Your custom error message';
```

### In a Trigger:
```sql
CREATE TRIGGER trg_ValidateAge
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.age < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Age cannot be negative!';
    END IF;
END;
```

### Common SQLSTATE Codes:
| Code | Category |
|------|----------|
| `'45000'` | User-defined error (generic) |
| `'23000'` | Integrity constraint violation |
| `'02000'` | No data found |

---

## ⚠️ Important Rules

1. **Declare handlers FIRST** - Must be at the beginning of BEGIN block
2. **Order matters** - More specific handlers before general ones
3. **One action per handler** - Can't have EXIT and CONTINUE for same error
4. **Handler runs ONCE** - Then execution continues/stops based on action

### Handler Declaration Order:
```sql
BEGIN
    -- Declare handlers FIRST (before any other statements)
    DECLARE EXIT HANDLER FOR 1062 ...;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION ...;
    
    -- Then your actual code
    INSERT INTO ...;
END;
```

---

## 📝 Common Exam Questions

### Q1: What is the difference between EXIT and CONTINUE handlers?
**Answer:**
- **EXIT:** Stops the procedure immediately after handler executes
- **CONTINUE:** Executes handler, then continues with the next statement

### Q2: What condition catches all SQL errors?
**Answer:** `SQLEXCEPTION` catches any SQL error.
```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION ...;
```

### Q3: How do you raise a custom error?
**Answer:** Use SIGNAL statement:
```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Custom error message';
```

### Q4: What does error code 1062 mean?
**Answer:** Duplicate entry - trying to insert a value that violates a unique constraint (primary key or unique index).

### Q5: Where can error handlers be used?
**Answer:** In stored procedures, functions, triggers, and events. NOT in plain SQL queries.

---

## ✅ Quick Reference

```sql
-- EXIT handler (stops on error)
DECLARE EXIT HANDLER FOR 1062
BEGIN
    SELECT 'Duplicate error!' AS Message;
END;

-- CONTINUE handler (continues after error)
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
    SET @error = 1;
END;

-- NOT FOUND handler
DECLARE CONTINUE HANDLER FOR NOT FOUND
SET @notfound = 1;

-- Raise custom error
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Error message';

-- Common error codes:
-- 1062 = Duplicate key
-- 1452 = Foreign key violation
-- SQLEXCEPTION = Any SQL error
-- NOT FOUND = No data found
```

---

## 🔄 Handler Flow Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    ERROR HANDLING FLOW                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Statement executes                                      │
│                 ↓                                           │
│  2. Error occurs?                                           │
│        ├── NO → Continue normally                           │
│        └── YES → Find matching handler                      │
│                          ↓                                  │
│  3. Handler executes                                        │
│                          ↓                                  │
│  4. Check handler action:                                   │
│        ├── EXIT → Stop procedure                            │
│        └── CONTINUE → Execute next statement                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

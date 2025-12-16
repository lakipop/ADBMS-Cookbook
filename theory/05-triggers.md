# 📖 MySQL Triggers - Theory Notes

> **Topics:** BEFORE/AFTER Triggers, INSERT/UPDATE/DELETE, NEW/OLD Keywords

---

## 🤔 What is a Trigger?

A **Trigger** is a stored program that automatically executes when a specific event (INSERT, UPDATE, DELETE) occurs on a table.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Motion Sensor Light = Light turns ON when you walk by     │
│   Database Trigger = Code runs when data changes            │
│                                                             │
│   "Whenever someone updates salary, log the change"         │
└─────────────────────────────────────────────────────────────┘
```

### Key Characteristics:
- 🔄 **Automatic** - No need to call manually
- 📋 **Table-bound** - Attached to specific table
- ⚡ **Event-driven** - Fires on INSERT, UPDATE, or DELETE
- ⏰ **Timed** - BEFORE or AFTER the event

---

## 🎯 Why Use Triggers?

| Use Case | Example |
|----------|---------|
| **Audit Logging** | Record who changed what |
| **Data Validation** | Check constraints before saving |
| **Automatic Calculations** | Update totals/averages |
| **Enforce Business Rules** | Prevent invalid operations |
| **Maintain Related Data** | Update inventory when order placed |
| **Cascading Changes** | Update child tables |

---

## 📊 Trigger Types

### By Timing:
| Timing | When it Runs |
|--------|--------------|
| `BEFORE` | Before data is saved to table |
| `AFTER` | After data is saved to table |

### By Event:
| Event | When it Fires |
|-------|---------------|
| `INSERT` | New row added |
| `UPDATE` | Existing row modified |
| `DELETE` | Row removed |

### 6 Possible Combinations:
```
┌─────────────────────────────────────────────────────────────┐
│                    TRIGGER TYPES                             │
├─────────────────────────────────────────────────────────────┤
│  BEFORE INSERT    │    BEFORE UPDATE    │    BEFORE DELETE  │
├─────────────────────────────────────────────────────────────┤
│  AFTER INSERT     │    AFTER UPDATE     │    AFTER DELETE   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 NEW and OLD Keywords

**NEW** = The row being inserted/updated (new values)  
**OLD** = The row before update/deletion (previous values)

| Trigger Type | NEW | OLD |
|--------------|-----|-----|
| INSERT | ✅ Available | ❌ Doesn't exist |
| UPDATE | ✅ (new values) | ✅ (old values) |
| DELETE | ❌ Doesn't exist | ✅ Available |

### Visual:
```
INSERT:  NULL ───────► [NEW Row]     (only NEW)
UPDATE:  [OLD Row] ──► [NEW Row]     (both OLD and NEW)
DELETE:  [OLD Row] ──► NULL          (only OLD)
```

### Example Usage:
```sql
-- In INSERT trigger
SET NEW.created_at = NOW();  -- Modify incoming data

-- In UPDATE trigger
IF NEW.price != OLD.price THEN  -- Compare old vs new
    INSERT INTO price_history VALUES (OLD.price, NEW.price);
END IF;

-- In DELETE trigger
INSERT INTO archive VALUES (OLD.id, OLD.name);  -- Save before delete
```

---

## 🔨 Creating Triggers - Syntax

### Basic Syntax
```sql
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON table_name
FOR EACH ROW
BEGIN
    -- trigger body
END;
```

### With DELIMITER
```sql
DELIMITER //

CREATE TRIGGER trigger_name
AFTER INSERT ON table_name
FOR EACH ROW
BEGIN
    -- multiple statements here
END //

DELIMITER ;
```

---

## 📝 Complete Examples

### Example 1: Auto-Set Timestamps
```sql
DELIMITER //

CREATE TRIGGER trg_SetCreatedAt
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
    SET NEW.status = 'Pending';
END //

DELIMITER ;
```

### Example 2: Audit Trail (Log Changes)
```sql
DELIMITER //

CREATE TRIGGER trg_LogSalaryChange
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary != OLD.salary THEN
        INSERT INTO salary_history (
            employee_id, old_salary, new_salary, changed_at
        ) VALUES (
            NEW.employee_id, OLD.salary, NEW.salary, NOW()
        );
    END IF;
END //

DELIMITER ;
```

### Example 3: Update Inventory on Sale
```sql
DELIMITER //

CREATE TRIGGER trg_DecreaseStock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //

DELIMITER ;
```

### Example 4: Prevent Invalid Data
```sql
DELIMITER //

CREATE TRIGGER trg_ValidateAge
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.age < 0 OR NEW.age > 150 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid age value';
    END IF;
END //

DELIMITER ;
```

### Example 5: Auto-Calculate Total
```sql
DELIMITER //

CREATE TRIGGER trg_CalculateOrderTotal
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * price)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;
```

### Example 6: Archive Deleted Records
```sql
DELIMITER //

CREATE TRIGGER trg_ArchiveEmployee
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employees_archive (
        id, name, department, deleted_at
    ) VALUES (
        OLD.id, OLD.name, OLD.department, NOW()
    );
END //

DELIMITER ;
```

---

## 🔒 SIGNAL SQLSTATE - Raise Errors

Use `SIGNAL` to throw custom errors and stop operations:

```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Your error message here';
```

### Common SQLSTATE Codes:
| Code | Meaning |
|------|---------|
| `'45000'` | Generic error (user-defined) |
| `'23000'` | Integrity constraint violation |
| `'02000'` | No data found |

---

## 🔄 BEFORE vs AFTER - When to Use?

| Use Case | Use BEFORE | Use AFTER |
|----------|------------|-----------|
| Modify incoming data | ✅ | ❌ |
| Validate data | ✅ | ❌ |
| Auto-fill defaults | ✅ | ❌ |
| Log changes | ❌ | ✅ |
| Update other tables | ❌ | ✅ |
| Send notifications | ❌ | ✅ |

### Simple Rule:
```
BEFORE = Change/Validate the data being saved
AFTER = React to what was saved
```

---

## 🔄 Managing Triggers

### View All Triggers
```sql
SHOW TRIGGERS;
SHOW TRIGGERS FROM database_name;
```

### View Trigger Definition
```sql
SHOW CREATE TRIGGER trigger_name;
```

### Delete Trigger
```sql
DROP TRIGGER IF EXISTS trigger_name;
```

### Modify Trigger
**Note:** MySQL doesn't support `ALTER TRIGGER`. You must drop and recreate.

```sql
DROP TRIGGER IF EXISTS old_trigger;
CREATE TRIGGER old_trigger ...;
```

---

## ⚠️ Important Notes

1. **Cannot modify same table in AFTER trigger** (causes infinite loop)
2. **One trigger per timing+event combination** per table
3. **Triggers don't fire on TRUNCATE** or CASCADE operations
4. **Performance impact** - Complex triggers slow down operations
5. **Hidden logic** - Can make debugging difficult

---

## 📝 Common Exam Questions

### Q1: What is a Trigger?
**Answer:** A trigger is a stored program that automatically executes when INSERT, UPDATE, or DELETE operations occur on a table.

### Q2: Explain NEW and OLD keywords
**Answer:**
- **NEW:** Contains the new row values (available in INSERT/UPDATE)
- **OLD:** Contains the original row values (available in UPDATE/DELETE)

### Q3: BEFORE vs AFTER trigger - when to use each?
**Answer:**
- **BEFORE:** To modify/validate data before saving (can change NEW values)
- **AFTER:** To log changes or update other tables (data already saved)

### Q4: How many triggers can a table have?
**Answer:** One trigger per combination of timing (BEFORE/AFTER) and event (INSERT/UPDATE/DELETE) = maximum 6 triggers per table.

### Q5: How to raise a custom error in a trigger?
**Answer:**
```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Custom error message';
```

---

## ✅ Quick Reference

```sql
-- Create BEFORE INSERT trigger
CREATE TRIGGER trg_name
BEFORE INSERT ON table_name
FOR EACH ROW
SET NEW.column = value;

-- Create AFTER UPDATE trigger
DELIMITER //
CREATE TRIGGER trg_name
AFTER UPDATE ON table_name
FOR EACH ROW
BEGIN
    IF NEW.col != OLD.col THEN
        INSERT INTO log VALUES (...);
    END IF;
END //
DELIMITER ;

-- Raise error
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error!';

-- View triggers
SHOW TRIGGERS;

-- Delete trigger
DROP TRIGGER IF EXISTS trg_name;
```

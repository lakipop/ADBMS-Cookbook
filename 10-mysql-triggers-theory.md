# MySQL Triggers - Theory

> **Category:** Lecture Slides (Theory)  
> **Topics:** Triggers, Row-Level, Statement-Level, NEW/OLD Modifiers

---

## 📚 What is a Trigger?

**Definition:** A set of SQL statements associated with a table, invoked automatically in response to an event (INSERT, UPDATE, DELETE).

### Types (Standard)
| Type | Description |
|------|-------------|
| **Row-Level** | Activated for each row affected |
| **Statement-Level** | Fired once per event regardless of rows |

---

## 🎯 Usage & Benefits

| Benefit | Description |
|---------|-------------|
| **Business Rules** | Enforce rules and validate data |
| **Audit Trails** | Maintain logs |
| **Integrity Checks** | Check data integrity |
| **Scheduled Tasks** | Run automated tasks |
| **Performance** | Pre-compiled execution |
| **Reduce Client Code** | Logic in database |

## ⚠️ Limitations

- Limited validations (extended only)
- Invisible execution (hard to troubleshoot)
- Increased server overhead

---

## 📊 Trigger Types (Timing & Event)

```
              INSERT    UPDATE    DELETE
           ┌─────────┬─────────┬─────────┐
   BEFORE  │BI INSERT│BU UPDATE│BD DELETE│
           ├─────────┼─────────┼─────────┤
   AFTER   │AI INSERT│AU UPDATE│AD DELETE│
           └─────────┴─────────┴─────────┘
```

**6 Combinations:**
1. BEFORE INSERT
2. AFTER INSERT
3. BEFORE UPDATE
4. AFTER UPDATE
5. BEFORE DELETE
6. AFTER DELETE

---

## 📝 Syntax

### Create Trigger
```sql
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON table_name
FOR EACH ROW
BEGIN
    -- trigger body
END;
```

### Drop Trigger
```sql
DROP TRIGGER [IF EXISTS] schema_name.trigger_name;
```

### Show Triggers
```sql
SHOW TRIGGERS;
```

---

## 🔄 NEW vs OLD Modifiers

| Modifier | Description | Available In |
|----------|-------------|--------------|
| `OLD.col_name` | Value before update/delete | UPDATE, DELETE |
| `NEW.col_name` | New row value or value after update | INSERT, UPDATE |

```sql
-- Example: Log old and new values
CREATE TRIGGER log_update
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (old_name, new_name)
    VALUES (OLD.name, NEW.name);
END;
```

---

## 📝 Trigger Examples

### BEFORE INSERT - Auto Grade
```sql
CREATE TRIGGER set_grade
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.score < 35 THEN
        SET NEW.grade = 'FAIL';
    ELSE
        SET NEW.grade = 'PASS';
    END IF;
END;
```

### AFTER INSERT - Notification
```sql
CREATE TRIGGER birthday_notify
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.birthday IS NOT NULL THEN
        INSERT INTO notifications (message)
        VALUES (CONCAT('Birthday: ', NEW.name));
    END IF;
END;
```

### BEFORE UPDATE - Validation
```sql
CREATE TRIGGER validate_qty
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.quantity > OLD.quantity * 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity increase too large';
    END IF;
END;
```

### AFTER UPDATE - Logging
```sql
CREATE TRIGGER log_class_change
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    IF OLD.class != NEW.class THEN
        INSERT INTO class_log (student_id, old_class, new_class)
        VALUES (NEW.id, OLD.class, NEW.class);
    END IF;
END;
```

### BEFORE DELETE - Archive
```sql
CREATE TRIGGER archive_salary
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_archive (emp_id, salary, deleted_at)
    VALUES (OLD.id, OLD.salary, NOW());
END;
```

### AFTER DELETE - Update Total
```sql
CREATE TRIGGER update_budget
AFTER DELETE ON expenses
FOR EACH ROW
BEGIN
    UPDATE budget SET total = total - OLD.amount;
END;
```

---

## 🎯 Practice Questions

### Q1: What is a Trigger?
```
Answer:

```

### Q2: Row-Level vs Statement-Level?
```
Answer:

```

### Q3: List all 6 trigger timing combinations
```
Answer:

```

### Q4: When to use OLD vs NEW?
```
Answer:

```

### Q5: Trigger limitations?
```
Answer:

```

---

## ✅ Checklist
- [ ] Understand trigger definition
- [ ] Know Row-Level vs Statement-Level
- [ ] Understand 6 timing/event combinations
- [ ] Know CREATE/DROP syntax
- [ ] Master NEW and OLD modifiers
- [ ] Practice all trigger types

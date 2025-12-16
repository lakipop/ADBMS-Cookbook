# 📖 Views - Theory Notes

> **Topics:** Virtual Tables, View Types, WITH CHECK OPTION, Materialized Views

---

## 🤔 What is a VIEW?

A **VIEW** is a **virtual table** created from a stored SELECT statement. It doesn't store data itself - it fetches data from underlying tables every time you query it.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Real Table = Physical notebook with written data          │
│   View = Window that shows specific pages of the notebook   │
│                                                             │
│   The view doesn't copy the data - it just shows it!        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Why Use Views?

| Purpose | Example |
|---------|---------|
| **Simplify Complex Queries** | Hide JOIN logic, just `SELECT * FROM view` |
| **Security** | Show only non-sensitive columns to users |
| **Data Abstraction** | Users don't need to know table structure |
| **Consistent Data** | Same logic across all applications |
| **Combine Data** | Merge first_name + last_name into full_name |

---

## 📝 Types of Views

### 1. Simple View
- Based on **one table**
- Can perform INSERT, UPDATE, DELETE
- No GROUP BY, DISTINCT, or aggregate functions

```sql
CREATE VIEW vw_ActiveStudents AS
SELECT student_id, name, email 
FROM students 
WHERE status = 'Active';
```

### 2. Complex View
- Based on **multiple tables** (JOINs)
- Usually read-only
- May contain aggregate functions

```sql
CREATE VIEW vw_StudentMarks AS
SELECT s.name, m.subject, m.marks
FROM students s
JOIN marks m ON s.student_id = m.student_id;
```

### 3. Aggregate View
- Contains **GROUP BY** and aggregate functions
- Always read-only

```sql
CREATE VIEW vw_DeptSalary AS
SELECT department, AVG(salary) AS avg_salary, COUNT(*) AS emp_count
FROM employees
GROUP BY department;
```

---

## 🔨 Creating Views - Syntax

### Basic Syntax
```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

### Full Syntax with Options
```sql
CREATE [OR REPLACE] VIEW view_name [(column_list)]
AS select_statement
[WITH CHECK OPTION];
```

---

## 🔒 WITH CHECK OPTION - Security Feature

**Purpose:** Prevents INSERT/UPDATE that would make the row invisible in the view.

### Without WITH CHECK OPTION:
```sql
CREATE VIEW vw_ActiveStudents AS
SELECT * FROM students WHERE status = 'Active';

-- This INSERT works, but row won't appear in view!
INSERT INTO vw_ActiveStudents (name, status) VALUES ('John', 'Inactive');
-- ✅ Inserted (but invisible in view - sneaky!)
```

### With WITH CHECK OPTION:
```sql
CREATE VIEW vw_ActiveStudents AS
SELECT * FROM students WHERE status = 'Active'
WITH CHECK OPTION;

-- This INSERT is BLOCKED!
INSERT INTO vw_ActiveStudents (name, status) VALUES ('John', 'Inactive');
-- ❌ ERROR: CHECK OPTION failed
```

### Visual:
```
┌─────────────────────────────────────────────────────────────┐
│  WITH CHECK OPTION = Security Guard at the door             │
│                                                             │
│  "Only data that matches the WHERE clause can enter!"       │
│                                                             │
│  View shows status='Active'                                 │
│  → INSERT status='Inactive' → BLOCKED! ❌                   │
│  → INSERT status='Active' → ALLOWED! ✅                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 Managing Views

### Update View Definition
```sql
CREATE OR REPLACE VIEW view_name AS
SELECT new_columns FROM table;
```

### Rename View (MySQL)
```sql
RENAME TABLE old_view_name TO new_view_name;
```

### Delete View
```sql
DROP VIEW view_name;
DROP VIEW IF EXISTS view_name;
```

### View All Views
```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

### View Definition
```sql
SHOW CREATE VIEW view_name;
```

---

## 📊 View vs Table - Key Differences

| Feature | Table | View |
|---------|-------|------|
| Stores Data | ✅ Yes | ❌ No (virtual) |
| Takes Space | ✅ Yes | ❌ No |
| Real-time Data | ❌ Stored | ✅ Always fresh |
| Can be Indexed | ✅ Yes | ❌ No |
| INSERT/UPDATE | ✅ Always | ⚠️ Sometimes |

---

## 🗃️ Materialized Views (Advanced)

Unlike regular views, **Materialized Views** store the query result as actual data.

### Regular View vs Materialized View:
```
Regular View:      Query → Fetch from tables → Show result
Materialized View: Query → Store result → Show stored result
```

### When to Use Materialized Views:
- Heavy JOIN queries
- Reports that don't need real-time data
- Aggregations that take long to compute

### Refresh Options:
| Option | Description |
|--------|-------------|
| `ON COMMIT` | Refresh after every transaction |
| `ON DEMAND` | Refresh manually when needed |
| `COMPLETE` | Rebuild entire view |
| `FAST` | Update only changed rows |

> **Note:** MySQL doesn't support true Materialized Views natively. Use tables with scheduled refresh as workaround.

---

## ⚠️ View Limitations

1. **Performance** - Not faster than direct query (runs query each time)
2. **Nested Views** - Views based on views can be slow
3. **DML Restrictions** - Can't always INSERT/UPDATE/DELETE
4. **No Indexes** - Views can't be indexed directly

---

## 📝 Common Exam Questions

### Q1: What is a VIEW?
**Answer:** A VIEW is a virtual table based on a stored SELECT query. It doesn't store data but fetches from underlying tables.

### Q2: List 4 uses of Views
**Answer:**
1. Simplify complex queries
2. Provide data security (hide columns)
3. Present consistent data
4. Combine fields from multiple tables

### Q3: What does WITH CHECK OPTION do?
**Answer:** It prevents INSERT/UPDATE operations that would make the row invisible in the view (violate WHERE condition).

### Q4: What is the difference between a View and Materialized View?
**Answer:**
- Regular View: Virtual, always fresh, no storage
- Materialized View: Stores data, needs refresh, faster for complex queries

### Q5: Can you always UPDATE through a View?
**Answer:** No. Views with JOINs, GROUP BY, DISTINCT, or aggregate functions are usually read-only.

---

## ✅ Quick Reference

```sql
-- Create simple view
CREATE VIEW vw_name AS SELECT * FROM table WHERE condition;

-- Create with check option
CREATE VIEW vw_name AS SELECT ... WITH CHECK OPTION;

-- Replace existing view
CREATE OR REPLACE VIEW vw_name AS SELECT ...;

-- Delete view
DROP VIEW IF EXISTS vw_name;

-- Show all views
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

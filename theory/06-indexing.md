# 📖 Indexing - Theory Notes

> **Topics:** Clustered vs Non-Clustered, Unique, Composite, Leftmost Prefix Rule

---

## 🤔 What is an Index?

An **Index** is a data structure that improves the speed of data retrieval operations on a database table - like the index at the back of a book!

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Book without index: Read every page to find a topic       │
│   Book with index: Look up topic → Go directly to page      │
│                                                             │
│   Table without index: Scan every row (SLOW)                │
│   Table with index: Jump directly to matching rows (FAST)   │
└─────────────────────────────────────────────────────────────┘
```

### Without Index:
```
SELECT * FROM employees WHERE name = 'John';
-- Scans ALL 1,000,000 rows to find John (Full Table Scan)
```

### With Index on 'name':
```
SELECT * FROM employees WHERE name = 'John';
-- Uses B-tree index → Finds John in milliseconds!
```

---

## 📊 Types of Indexes

### 1. Clustered Index
- **Physically sorts** the table data
- **Only ONE** per table (because data can only be sorted one way)
- Usually the **Primary Key**
- Data rows are stored in the same order as index

```
┌─────────────────────────────────────────────────────────────┐
│ CLUSTERED INDEX = Sorted Phone Directory                    │
│                                                             │
│ Names are PHYSICALLY arranged A-Z                           │
│ Only one way to sort the book!                              │
└─────────────────────────────────────────────────────────────┘
```

**In MySQL (InnoDB):** Primary Key IS the clustered index automatically!

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,  -- This is the clustered index!
    name VARCHAR(100)
);
```

### 2. Non-Clustered Index
- **Separate structure** from table data
- **Multiple allowed** per table
- Contains pointers to actual data rows
- Faster for specific column lookups

```
┌─────────────────────────────────────────────────────────────┐
│ NON-CLUSTERED INDEX = Book's Back Index                     │
│                                                             │
│ Topic → Page Number → Go to that page                       │
│ Can have multiple indexes (by topic, by author, etc.)       │
└─────────────────────────────────────────────────────────────┘
```

```sql
CREATE INDEX idx_name ON students(name);
-- Separate index structure pointing to rows
```

### Comparison:
| Feature | Clustered | Non-Clustered |
|---------|-----------|---------------|
| Quantity | 1 per table | Multiple allowed |
| Data Storage | Sorts actual data | Separate structure |
| Speed (range queries) | Faster | Slower |
| Speed (point queries) | Similar | Similar |
| In MySQL | Primary Key | CREATE INDEX |

---

## 🔑 Unique Index

Ensures all values in the indexed column(s) are **unique** - no duplicates allowed.

```sql
CREATE UNIQUE INDEX idx_unique_email ON users(email);

-- Now this will fail:
INSERT INTO users (email) VALUES ('john@email.com');  -- ✅ OK
INSERT INTO users (email) VALUES ('john@email.com');  -- ❌ ERROR: Duplicate
```

---

## 📦 Composite (Multi-Column) Index

Index on **multiple columns** together.

```sql
CREATE INDEX idx_city_status ON customers(city, status);
```

### ⚠️ THE LEFTMOST PREFIX RULE

This is **CRITICAL** for exams! A composite index can only be used if you filter from the **left side**.

**Given index:** `(city, status, name)`

| Query Filter | Uses Index? | Why |
|--------------|-------------|-----|
| `WHERE city = 'NY'` | ✅ Yes | Matches leftmost column |
| `WHERE city = 'NY' AND status = 'Active'` | ✅ Yes | Matches first 2 columns |
| `WHERE city = 'NY' AND status = 'Active' AND name = 'John'` | ✅ Yes | Matches all 3 |
| `WHERE status = 'Active'` | ❌ No | Skips 'city' (leftmost) |
| `WHERE name = 'John'` | ❌ No | Skips 'city' and 'status' |
| `WHERE city = 'NY' AND name = 'John'` | ⚠️ Partially | Uses only 'city' |

### Visual:
```
Index: (A, B, C)

Can use:
✅ A only
✅ A + B
✅ A + B + C

Cannot use efficiently:
❌ B only (A is missing)
❌ C only (A, B missing)
❌ B + C (A is missing)
```

---

## 🔨 Creating Indexes - Syntax

### Basic Index
```sql
CREATE INDEX index_name ON table_name(column);
```

### Unique Index
```sql
CREATE UNIQUE INDEX index_name ON table_name(column);
```

### Composite Index
```sql
CREATE INDEX index_name ON table_name(col1, col2, col3);
```

### Using ALTER TABLE
```sql
ALTER TABLE table_name ADD INDEX index_name (column);
ALTER TABLE table_name ADD UNIQUE INDEX index_name (column);
```

### Primary Key (Clustered in InnoDB)
```sql
ALTER TABLE table_name ADD PRIMARY KEY (column);
```

---

## 🔄 Managing Indexes

### View Indexes on a Table
```sql
SHOW INDEX FROM table_name;
SHOW INDEXES FROM table_name;
```

### Drop Index
```sql
DROP INDEX index_name ON table_name;
ALTER TABLE table_name DROP INDEX index_name;
```

### Check if Query Uses Index
```sql
EXPLAIN SELECT * FROM table WHERE column = 'value';
```

**Look for:**
- `type: ref` or `type: range` = Using index ✅
- `type: ALL` = Full table scan ❌

---

## 📈 When to Create Indexes

### ✅ Good candidates for indexing:
| Scenario | Why Index |
|----------|-----------|
| Columns in WHERE clauses | Speed up filtering |
| Columns in JOIN conditions | Speed up joins |
| Columns in ORDER BY | Speed up sorting |
| Columns in GROUP BY | Speed up grouping |
| Foreign Keys | Speed up referential integrity checks |
| Frequently searched columns | Common query patterns |

### ❌ Avoid indexing:
| Scenario | Why Not |
|----------|---------|
| Small tables | Full scan is fast enough |
| Columns with many NULLs | Limited benefit |
| Columns rarely used in queries | Wasted space |
| Frequently updated columns | Index maintenance overhead |
| Low-cardinality columns | Few unique values (like gender) |

---

## ⚠️ Index Trade-offs

### Advantages:
- ✅ Faster SELECT queries
- ✅ Faster JOINs
- ✅ Faster ORDER BY / GROUP BY

### Disadvantages:
- ❌ Slower INSERT/UPDATE/DELETE (index must be updated)
- ❌ Takes disk space
- ❌ Too many indexes = confusion for optimizer

---

## 📝 Complete Examples

### Example 1: Basic Index
```sql
-- Speed up searches by customer name
CREATE INDEX idx_customer_name ON customers(name);

-- This query will now be faster:
SELECT * FROM customers WHERE name = 'John Smith';
```

### Example 2: Unique Index
```sql
-- Ensure unique email addresses
CREATE UNIQUE INDEX idx_unique_email ON users(email);
```

### Example 3: Composite Index
```sql
-- For queries filtering by department AND salary range
CREATE INDEX idx_dept_salary ON employees(department, salary);

-- Uses index:
SELECT * FROM employees WHERE department = 'IT' AND salary > 50000;
```

### Example 4: Index for JOIN
```sql
-- Speed up joins on foreign key
CREATE INDEX idx_order_customer ON orders(customer_id);

-- This join is now faster:
SELECT * FROM orders o
JOIN customers c ON o.customer_id = c.id;
```

---

## 📝 Common Exam Questions

### Q1: What is an Index?
**Answer:** An index is a data structure that improves data retrieval speed by providing quick lookup paths to table rows, similar to a book's index.

### Q2: Clustered vs Non-Clustered Index
**Answer:**
- **Clustered:** Physically sorts table data. Only 1 per table. In MySQL, it's the Primary Key.
- **Non-Clustered:** Separate structure with pointers to data. Multiple allowed per table.

### Q3: Explain the Leftmost Prefix Rule
**Answer:** For composite index (A, B, C), the index is only used when filtering starts from the leftmost column. Can use: A, A+B, A+B+C. Cannot use: B, C, B+C alone.

### Q4: When should you NOT create an index?
**Answer:**
- Small tables
- Columns rarely used in WHERE/JOIN
- High-update columns
- Low-cardinality columns (few unique values)

### Q5: How do you check if a query uses an index?
**Answer:** Use `EXPLAIN` before the query:
```sql
EXPLAIN SELECT * FROM table WHERE column = 'value';
```

---

## ✅ Quick Reference

```sql
-- Create basic index
CREATE INDEX idx_name ON table(column);

-- Create unique index
CREATE UNIQUE INDEX idx_name ON table(column);

-- Create composite index
CREATE INDEX idx_name ON table(col1, col2);

-- View indexes
SHOW INDEX FROM table_name;

-- Drop index
DROP INDEX idx_name ON table_name;

-- Check query uses index
EXPLAIN SELECT ... FROM table WHERE ...;

-- Clustered index (Primary Key)
ALTER TABLE table ADD PRIMARY KEY (column);
```

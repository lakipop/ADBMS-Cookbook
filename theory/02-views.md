# Views - Theory

> **Category:** Lecture Slides (Theory)  
> **Topics:** Views, Virtual Tables, Materialized Views

---

## 📚 What is a VIEW?

A **VIEW** is a **VIRTUAL TABLE** or a **STORED SELECT QUERY** representing data stored in tables.

---

## 🎯 Uses of Views

| Use Case | Description |
|----------|-------------|
| **Join Data** | Easy interface to query multiple tables |
| **Partition Data** | Selected subset from large tables |
| **Aggregate Data** | Pre-calculated totals |
| **Customize Data** | Combine fields (First + Last Name) |
| **Hide Columns** | Use aliases for intuitive naming |
| **Secure Data** | Grant access to non-sensitive data |

---

## 🔨 Creating Views

### Basic Syntax
```sql
CREATE VIEW "VIEW_NAME" AS "SQL_STATEMENT";
```

### Detailed Syntax
```sql
CREATE VIEW [Schema_name.]View_name [(Column...)]
[WITH attributes]
AS select_statement
[WITH CHECK OPTION];
```

### Attributes
- `ENCRYPTION` - Prevents publishing of view definition
- `SCHEMABINDING` - Binds to schema, prevents base table modification
- `WITH CHECK OPTION` - Forces modifications to follow criteria

---

## 📝 View Examples

```sql
-- Hide Salary
CREATE VIEW v_instructors AS
SELECT instructor_id, name, department FROM instructors;

-- Aggregation
CREATE VIEW v_dept_totals AS
SELECT department, SUM(salary) AS total FROM instructors GROUP BY department;
```

---

## 🔄 Managing Views

```sql
-- Update
CREATE OR REPLACE VIEW view_name AS SELECT ...;

-- Drop
DROP VIEW view_name [RESTRICT | CASCADE];
```

- **CASCADE**: Deletes dependent objects
- **RESTRICT**: Rejects if dependencies exist

---

## ⚠️ View Drawbacks

1. Not faster than direct query
2. Performance issues with nested views
3. Hides complexity

---

## 📊 Materialized Views

Stores the result table in advance (pre-computed data).

### Refresh Options
| Option | Description |
|--------|-------------|
| COMPLETE | Total refresh |
| FAST | Incremental changes |
| FORCE | Fast if possible, else Complete |

### Refresh Modes
- `ON COMMIT` - Automatic on transaction
- `ON DEMAND` - Manual refresh

---

## 🎯 Questions

### Q1: What is a VIEW?
```
Answer:

```

### Q2: List 4 uses of Views
```
Answer:

```

### Q3: WITH CHECK OPTION purpose?
```
Answer:

```

### Q4: CASCADE vs RESTRICT?
```
Answer:

```

### Q5: View vs Materialized View?
```
Answer:

```

---

## ✅ Checklist
- [ ] Understand VIEW definition
- [ ] Know all use cases
- [ ] Understand CREATE VIEW syntax
- [ ] Know VIEW attributes
- [ ] Drop Views with CASCADE/RESTRICT
- [ ] Understand Materialized Views
- [ ] Know refresh options

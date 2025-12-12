# Indexing - Theory

> **Category:** Lecture Slides (Theory)  
> **Topics:** Clustered Index, Non-Clustered Index, Unique Index, Composite Index

---

## 📚 What is an Index?

**Definition:** A data structure that improves the speed of data retrieval operations on a database table.

**Analogy:** Like a book index - allows locating rows much faster than reading the entire table.

---

## 📊 Index Types

```
┌─────────────────────────────────────────────────────────┐
│                     INDEX TYPES                          │
├─────────────────┬─────────────────┬─────────────────────┤
│   Clustered     │  Non-Clustered  │   Unique/Composite  │
│   (1 per table) │  (Multiple)     │   (Special types)   │
└─────────────────┴─────────────────┴─────────────────────┘
```

---

## 🔷 Clustered Index

| Feature | Description |
|---------|-------------|
| Structure | Rows maintained in sorted order (like dictionary) |
| Constraint | Only **ONE** per table |
| Storage | No separate storage - data itself is sorted |

### InnoDB Behavior
1. Uses **Primary Key** as clustered index
2. If no PK, uses first **UNIQUE index with NOT NULL**
3. If neither, creates **hidden clustered index**

**Example:** Inserting IDs 29, 23, 25, 31, 30 → Physical storage: 23, 25, 29, 30, 31

---

## 🔶 Non-Clustered (Secondary) Index

| Feature | Description |
|---------|-------------|
| Definition | All indexes other than clustered |
| Structure | Rows NOT in sorted order |
| Count | Multiple per table allowed |
| Storage | Separate space (extra storage required) |

**Analogy:** Like a table of contents - holds column value + reference address.

```sql
CREATE INDEX idx_name ON employees (name);
```

---

## 🔒 Unique Index

- Enforces **uniqueness** of values
- Can have multiple Unique indexes (unlike Primary Key)
- Throws error (Code 1062) on duplicate values

```sql
CREATE UNIQUE INDEX idx_email ON employees (email);
```

---

## 📑 Composite Index

- Index on **multiple columns** (up to 16 in MySQL)
- Follows **Leftmost Prefix Rule**

```sql
CREATE INDEX idx_name ON employees (lastName, firstName);
```

### Leftmost Prefix Rule

| Query | Uses Index? |
|-------|-------------|
| `WHERE lastName = 'X'` | ✅ Yes |
| `WHERE lastName = 'X' AND firstName = 'Y'` | ✅ Yes |
| `WHERE firstName = 'Y'` | ❌ No |

> ⚠️ Optimizer cannot use index if columns don't form leftmost prefix!

---

## 📝 Index Syntax

```sql
-- Create Index
CREATE INDEX index_name ON table (column);

-- Create Unique Index
CREATE UNIQUE INDEX index_name ON table (column);

-- Create Composite Index
CREATE INDEX index_name ON table (col1, col2, col3);

-- Drop Index
DROP INDEX index_name ON table;

-- Show Indexes
SHOW INDEX FROM table_name;
```

---

## 🎯 Practice Questions

### Q1: Clustered vs Non-Clustered difference?
```
Answer:

```

### Q2: How many clustered indexes per table?
```
Answer:

```

### Q3: Explain Leftmost Prefix Rule
```
Answer:

```

### Q4: When to use Unique Index?
```
Answer:

```

### Q5: What happens if no Primary Key in InnoDB?
```
Answer:

```

---

## ✅ Checklist
- [ ] Understand index purpose
- [ ] Know Clustered Index behavior
- [ ] Know Non-Clustered Index features
- [ ] Understand Unique Index
- [ ] Master Composite Index & Leftmost Prefix Rule
- [ ] Know index syntax

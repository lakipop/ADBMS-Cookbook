# Stored Procedures - Theory

> **Category:** Lecture Slides (Theory)  
> **Topics:** Stored Procedures, Parameters, Control Flow, Error Handling

---

## 📚 What is a Stored Procedure?

A **Stored Procedure** is a series of SQL statements stored in DB server to accomplish a task.

- Imperative (loops, conditions)
- Pre-compiled for efficiency
- Can be invoked multiple times
- Can be written in other languages (C, Java)

---

## 🔨 Creating Stored Procedures

### Syntax
```sql
CREATE PROCEDURE dbo.StoredProcedure (@Param datatype...)
AS
RETURN
```

### MySQL Example
```sql
DELIMITER //
CREATE PROCEDURE get_employees_in_dept(IN dept INT)
BEGIN
    SELECT * FROM employees WHERE department_id = dept;
END //
DELIMITER ;
```

### Modifying & Dropping
```sql
ALTER PROCEDURE procedure_name ...;
DROP PROCEDURE procedure_name;
```

### Calling
```sql
CALL procedure_name(parameter_value_list);
```

---

## 📋 Parameters

| Type | Description |
|------|-------------|
| **IN** | Input parameter (default) |
| **OUT** | Output parameter |
| **INOUT** | Both input and output |

```sql
CREATE PROCEDURE example(
    IN input_param INT,
    OUT output_param VARCHAR(50),
    INOUT both_param INT
)
```

---

## 🔄 Body Statements

### Conditional Statements
```sql
-- IF...THEN...ELSE
IF condition THEN
    statements;
ELSEIF condition THEN
    statements;
ELSE
    statements;
END IF;

-- CASE
CASE expression
    WHEN value1 THEN statements;
    WHEN value2 THEN statements;
    ELSE statements;
END CASE;
```

### Loop Statements
```sql
-- LOOP
label: LOOP
    statements;
    IF condition THEN LEAVE label; END IF;
END LOOP;

-- WHILE
WHILE condition DO
    statements;
END WHILE;
```

### Other Statements
- `FOR` - Loop with counter
- `GOTO` - Jump to label
- `RETURN` - Exit procedure

---

## ✅ Advantages

| Advantage | Description |
|-----------|-------------|
| **Performance** | Pre-compilation |
| **Reduced Network Traffic** | One call vs multiple |
| **Separation of Concerns** | DB logic separate |
| **Security** | Grant EXECUTE permission |
| **Server Power** | Full server resources |

## ⚠️ Disadvantages

| Disadvantage | Description |
|--------------|-------------|
| **Hidden Complexity** | Logic in database |
| **Restricted Access** | Need DB access to debug |
| **Limited IDE** | Less advanced tools |
| **Testing** | Limited testing features |

---

## ⚖️ SP vs UDF Comparison

| Feature | Stored Procedure | UDF |
|---------|------------------|-----|
| Call Method | EXEC/CALL | In SQL statement |
| Return | Optional | Mandatory |
| Server Variables | Can change | Cannot change |
| Error Handling | Can continue | Stops on error |
| Result Sets | Multiple | Single |
| Use in SELECT | No | Yes |
| Non-deterministic | Can use | Cannot use |

---

## 🎯 Questions

### Q1: What is a Stored Procedure?
```
Answer:

```

### Q2: IN, OUT, INOUT difference?
```
Answer:

```

### Q3: List 3 advantages of SP
```
Answer:

```

### Q4: SP vs UDF - main differences?
```
Answer:

```

### Q5: Control flow statements in SP?
```
Answer:

```

---

## ✅ Checklist
- [ ] Understand SP definition
- [ ] Know CREATE PROCEDURE syntax
- [ ] Understand parameter types (IN/OUT/INOUT)
- [ ] Know control flow statements
- [ ] Understand advantages/disadvantages
- [ ] Know SP vs UDF differences

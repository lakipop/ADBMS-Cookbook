# 📖 Transactions - Theory Notes

> **Topics:** ACID Properties, COMMIT, ROLLBACK, SAVEPOINT, Isolation Levels

---

## 🤔 What is a Transaction?

A **Transaction** is a sequence of SQL operations that are treated as a **single unit of work**. Either ALL operations succeed, or NONE of them do.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Bank Transfer:                                            │
│   1. Deduct $100 from Account A                             │
│   2. Add $100 to Account B                                  │
│                                                             │
│   Both must succeed, or neither should happen!              │
│   If #1 succeeds but #2 fails → Money disappears! 😱        │
│                                                             │
│   Transaction ensures: All or Nothing                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🏛️ ACID Properties

Every transaction must follow these four properties:

### A - Atomicity
**"All or Nothing"**
- Either all operations complete successfully, OR
- None of them take effect

```
Transfer $100: A → B
✅ Success: Both debit and credit happen
❌ Failure: Neither happens (rolled back)
```

### C - Consistency
**"Valid State to Valid State"**
- Database must be consistent before and after transaction
- All rules/constraints maintained

```
Before: A=$500, B=$200, Total=$700
After:  A=$400, B=$300, Total=$700 ✅
```

### I - Isolation
**"Transactions Don't Interfere"**
- Concurrent transactions don't affect each other
- Each transaction sees consistent data

```
User 1 reading data shouldn't see User 2's uncommitted changes
```

### D - Durability
**"Permanent Once Committed"**
- Once committed, changes survive system failures
- Data is written to permanent storage

```
COMMIT → Power failure → Data still there ✅
```

### Visual:
```
┌─────────────────────────────────────────────────────────────┐
│                      ACID PROPERTIES                         │
├─────────────────────────────────────────────────────────────┤
│  A - Atomicity     │  All or nothing                        │
│  C - Consistency   │  Valid state → Valid state             │
│  I - Isolation     │  Transactions don't interfere          │
│  D - Durability    │  Committed = Permanent                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔨 Transaction Commands

### START TRANSACTION
Begin a new transaction.
```sql
START TRANSACTION;
-- or
BEGIN;
```

### COMMIT
Save all changes permanently.
```sql
COMMIT;
```

### ROLLBACK
Undo all changes since transaction started.
```sql
ROLLBACK;
```

### SAVEPOINT
Create checkpoint within transaction.
```sql
SAVEPOINT savepoint_name;
```

### ROLLBACK TO SAVEPOINT
Undo to specific checkpoint.
```sql
ROLLBACK TO SAVEPOINT savepoint_name;
```

---

## 📝 Transaction Examples

### Example 1: Basic Transaction
```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;  -- Both changes saved
```

### Example 2: With ROLLBACK
```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- Something went wrong!

ROLLBACK;  -- Undo the debit
```

### Example 3: Using SAVEPOINT
```sql
START TRANSACTION;

INSERT INTO orders (customer_id, total) VALUES (1, 500);
SAVEPOINT order_created;

INSERT INTO order_items (order_id, product_id) VALUES (1, 101);
INSERT INTO order_items (order_id, product_id) VALUES (1, 102);
-- Error in item 2!

ROLLBACK TO SAVEPOINT order_created;  -- Keep order, undo items
-- Fix and retry items

COMMIT;
```

### Example 4: In Stored Procedure
```sql
DELIMITER //

CREATE PROCEDURE sp_TransferMoney(
    IN from_account INT,
    IN to_account INT,
    IN amount DECIMAL(10,2),
    OUT status VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET status = 'FAILED - Transaction rolled back';
    END;
    
    START TRANSACTION;
    
    UPDATE accounts SET balance = balance - amount WHERE id = from_account;
    UPDATE accounts SET balance = balance + amount WHERE id = to_account;
    
    COMMIT;
    SET status = 'SUCCESS - Transfer completed';
END //

DELIMITER ;
```

---

## 🔒 Isolation Levels

Control how transactions see each other's changes.

| Level | Dirty Read | Non-Repeatable Read | Phantom Read |
|-------|------------|---------------------|--------------|
| READ UNCOMMITTED | ✅ Possible | ✅ Possible | ✅ Possible |
| READ COMMITTED | ❌ Prevented | ✅ Possible | ✅ Possible |
| REPEATABLE READ | ❌ Prevented | ❌ Prevented | ✅ Possible |
| SERIALIZABLE | ❌ Prevented | ❌ Prevented | ❌ Prevented |

### Problems Explained:

**Dirty Read:** Reading uncommitted data from another transaction
```
T1: UPDATE salary = 5000  (not committed)
T2: SELECT salary → sees 5000
T1: ROLLBACK
T2: Has wrong data!
```

**Non-Repeatable Read:** Same query, different results in same transaction
```
T1: SELECT salary → 3000
T2: UPDATE salary = 5000, COMMIT
T1: SELECT salary → 5000 (different!)
```

**Phantom Read:** New rows appear during transaction
```
T1: SELECT COUNT(*) WHERE age > 25 → 10
T2: INSERT new row with age 30, COMMIT
T1: SELECT COUNT(*) WHERE age > 25 → 11 (phantom row!)
```

### Set Isolation Level:
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- MySQL default
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

---

## ⚙️ Auto-Commit Mode

By default, MySQL auto-commits each statement. To use transactions:

```sql
-- Check current setting
SELECT @@autocommit;

-- Disable auto-commit
SET autocommit = 0;

-- Now you must explicitly COMMIT or ROLLBACK

-- Re-enable auto-commit
SET autocommit = 1;
```

---

## 📝 Common Exam Questions

### Q1: What is a Transaction?
**Answer:** A transaction is a sequence of SQL operations treated as a single unit of work, following the ACID properties - either all succeed or none take effect.

### Q2: Explain ACID properties.
**Answer:**
- **Atomicity:** All or nothing
- **Consistency:** Valid state to valid state
- **Isolation:** Transactions don't interfere
- **Durability:** Committed changes are permanent

### Q3: Difference between COMMIT and ROLLBACK?
**Answer:**
- **COMMIT:** Saves all changes permanently
- **ROLLBACK:** Undoes all changes since transaction started

### Q4: What is a SAVEPOINT?
**Answer:** A savepoint is a checkpoint within a transaction. You can ROLLBACK to a specific savepoint without undoing the entire transaction.

### Q5: What is the default isolation level in MySQL?
**Answer:** REPEATABLE READ

---

## ✅ Quick Reference

```sql
-- Start transaction
START TRANSACTION;
-- or
BEGIN;

-- Save changes
COMMIT;

-- Undo changes
ROLLBACK;

-- Create savepoint
SAVEPOINT sp_name;

-- Rollback to savepoint
ROLLBACK TO SAVEPOINT sp_name;

-- Release savepoint
RELEASE SAVEPOINT sp_name;

-- Check autocommit
SELECT @@autocommit;

-- Disable autocommit
SET autocommit = 0;

-- Set isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

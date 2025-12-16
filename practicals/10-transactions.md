# Practical: Transactions

> **Category:** Lab/Practical Instructions  
> **Topics:** COMMIT, ROLLBACK, SAVEPOINT, Isolation Levels

---

## 📋 Database Setup

### Schema: BankDB

```sql
CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    account_type VARCHAR(20) DEFAULT 'Savings',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    from_account INT,
    to_account INT,
    amount DECIMAL(12,2),
    transaction_type VARCHAR(20),
    status VARCHAR(20),
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO accounts (account_holder, balance, account_type) VALUES
('Kamal Perera', 50000.00, 'Savings'),
('Nimal Silva', 25000.00, 'Savings'),
('Sunil Fernando', 100000.00, 'Current'),
('Amara Jayawardena', 15000.00, 'Savings'),
('Kumari Rathnayake', 75000.00, 'Current');
```

---

## 🎯 Practice Questions

### Question 1: Basic Transaction - Money Transfer
**Task:** Create a transaction that transfers Rs. 5000 from Kamal (account 1) to Nimal (account 2). Both operations must succeed or fail together.

```sql
-- Your answer here

```

---

### Question 2: Transaction with ROLLBACK
**Task:** Start a transaction that attempts to:
1. Deduct Rs. 10000 from Sunil (account 3)
2. Check if Sunil's new balance is below Rs. 50000
3. If yes, ROLLBACK the transaction
4. If no, COMMIT the transaction

```sql
-- Your answer here

```

---

### Question 3: Using SAVEPOINT
**Task:** Create a transaction that:
1. Inserts a new account for "Tharuka Fernando" with Rs. 20000
2. Creates a SAVEPOINT named `account_created`
3. Transfers Rs. 5000 to this new account from Kumari (account 5)
4. If transfer fails, ROLLBACK TO SAVEPOINT (keep account, undo transfer)
5. COMMIT if everything succeeds

```sql
-- Your answer here

```

---

### Question 4: Transaction in Stored Procedure
**Task:** Create a stored procedure `sp_TransferFunds` that:
- Accepts: from_account_id, to_account_id, amount
- Returns: status message (OUT parameter)
- Uses transaction to ensure atomicity
- Includes error handling to ROLLBACK on failure

```sql
-- Your answer here

```

---

### Question 5: Check Balance Before Transfer
**Task:** Create a stored procedure `sp_SafeTransfer` that:
- Checks if source account has sufficient balance
- If insufficient, return error without transaction
- If sufficient, perform transfer with transaction
- Log the transaction in transactions_log table

```sql
-- Your answer here

```

---

### Question 6: Concurrent Transaction Simulation
**Task:** 
1. Open two MySQL connections
2. In connection 1: Start transaction, UPDATE Kamal's balance
3. In connection 2: Try to SELECT Kamal's balance
4. Observe the isolation level behavior
5. Document what you see

```sql
-- Connection 1:

-- Connection 2:

-- Observations:

```

---

### Question 7: Change Isolation Level
**Task:** Write commands to:
1. View the current transaction isolation level
2. Set isolation level to READ COMMITTED
3. Set isolation level back to REPEATABLE READ

```sql
-- Your answer here

```

---

### Question 8: Multiple SAVEPOINTs
**Task:** Create a transaction with multiple savepoints:
1. Insert Account A, SAVEPOINT sp1
2. Insert Account B, SAVEPOINT sp2
3. Insert Account C, SAVEPOINT sp3
4. ROLLBACK TO sp2 (remove Account C only)
5. COMMIT

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Question 1: Basic Transaction
- [ ] Question 2: Transaction with ROLLBACK
- [ ] Question 3: Using SAVEPOINT
- [ ] Question 4: Transaction in Stored Procedure
- [ ] Question 5: Check Balance Before Transfer
- [ ] Question 6: Concurrent Transaction Simulation
- [ ] Question 7: Change Isolation Level
- [ ] Question 8: Multiple SAVEPOINTs

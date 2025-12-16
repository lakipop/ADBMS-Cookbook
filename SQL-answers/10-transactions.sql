-- ==========================================
-- PRACTICAL 10: Transactions - ANSWERS
-- Database: BankDB
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

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

INSERT INTO accounts (account_holder, balance, account_type) VALUES
('Kamal Perera', 50000.00, 'Savings'),
('Nimal Silva', 25000.00, 'Savings'),
('Sunil Fernando', 100000.00, 'Current'),
('Amara Jayawardena', 15000.00, 'Savings'),
('Kumari Rathnayake', 75000.00, 'Current');

-- ==========================================
-- Question 1: Basic Transaction - Money Transfer
-- ==========================================

START TRANSACTION;

-- Deduct from Kamal
UPDATE accounts 
SET balance = balance - 5000 
WHERE account_id = 1;

-- Add to Nimal
UPDATE accounts 
SET balance = balance + 5000 
WHERE account_id = 2;

-- Both succeed, so commit
COMMIT;

-- Verify:
SELECT * FROM accounts WHERE account_id IN (1, 2);

-- ==========================================
-- Question 2: Transaction with ROLLBACK
-- ==========================================

-- Reset Sunil's balance first for testing
UPDATE accounts SET balance = 100000 WHERE account_id = 3;

START TRANSACTION;

-- Deduct Rs. 10000 from Sunil
UPDATE accounts 
SET balance = balance - 10000 
WHERE account_id = 3;

-- Check new balance
SELECT balance INTO @new_balance 
FROM accounts 
WHERE account_id = 3;

-- If balance below 50000, rollback
-- Otherwise commit
-- Note: In a procedure, use IF statement

-- For testing, check manually:
SELECT @new_balance;
-- If @new_balance < 50000, run: ROLLBACK;
-- Otherwise run: COMMIT;

-- Since 100000 - 10000 = 90000 > 50000:
COMMIT;

-- ==========================================
-- Question 3: Using SAVEPOINT
-- ==========================================

START TRANSACTION;

-- Step 1: Insert new account
INSERT INTO accounts (account_holder, balance, account_type)
VALUES ('Tharuka Fernando', 20000, 'Savings');

-- Step 2: Create savepoint
SAVEPOINT account_created;

-- Get the new account ID
SET @new_account_id = LAST_INSERT_ID();

-- Step 3: Transfer Rs. 5000 from Kumari (account 5)
UPDATE accounts SET balance = balance - 5000 WHERE account_id = 5;
UPDATE accounts SET balance = balance + 5000 WHERE account_id = @new_account_id;

-- If transfer successful:
COMMIT;

-- If transfer fails (run this instead of COMMIT):
-- ROLLBACK TO SAVEPOINT account_created;
-- COMMIT;  -- This keeps the new account but undoes transfer

-- ==========================================
-- Question 4: Transaction in Stored Procedure
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_TransferFunds(
    IN p_from_account INT,
    IN p_to_account INT,
    IN p_amount DECIMAL(12,2),
    OUT p_status VARCHAR(100)
)
BEGIN
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 'FAILED: Transaction rolled back due to error';
    END;
    
    START TRANSACTION;
    
    -- Deduct from source account
    UPDATE accounts 
    SET balance = balance - p_amount 
    WHERE account_id = p_from_account;
    
    -- Add to destination account
    UPDATE accounts 
    SET balance = balance + p_amount 
    WHERE account_id = p_to_account;
    
    COMMIT;
    SET p_status = 'SUCCESS: Transfer completed';
END //

DELIMITER ;

-- Test:
CALL sp_TransferFunds(1, 2, 1000, @status);
SELECT @status;

-- ==========================================
-- Question 5: Check Balance Before Transfer
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_SafeTransfer(
    IN p_from_account INT,
    IN p_to_account INT,
    IN p_amount DECIMAL(12,2),
    OUT p_status VARCHAR(100)
)
BEGIN
    DECLARE v_current_balance DECIMAL(12,2);
    
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 'FAILED: Error during transfer';
        
        -- Log failed transaction
        INSERT INTO transactions_log (from_account, to_account, amount, transaction_type, status)
        VALUES (p_from_account, p_to_account, p_amount, 'TRANSFER', 'FAILED');
    END;
    
    -- Check current balance
    SELECT balance INTO v_current_balance 
    FROM accounts 
    WHERE account_id = p_from_account;
    
    -- Validate sufficient funds
    IF v_current_balance < p_amount THEN
        SET p_status = 'FAILED: Insufficient balance';
        
        -- Log rejected transaction
        INSERT INTO transactions_log (from_account, to_account, amount, transaction_type, status)
        VALUES (p_from_account, p_to_account, p_amount, 'TRANSFER', 'REJECTED - Insufficient funds');
    ELSE
        START TRANSACTION;
        
        -- Perform transfer
        UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_from_account;
        UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_to_account;
        
        -- Log successful transaction
        INSERT INTO transactions_log (from_account, to_account, amount, transaction_type, status)
        VALUES (p_from_account, p_to_account, p_amount, 'TRANSFER', 'SUCCESS');
        
        COMMIT;
        SET p_status = 'SUCCESS: Transfer completed';
    END IF;
END //

DELIMITER ;

-- Test:
CALL sp_SafeTransfer(1, 2, 1000000, @status);  -- Should fail (insufficient)
SELECT @status;

CALL sp_SafeTransfer(1, 2, 1000, @status);  -- Should succeed
SELECT @status;

SELECT * FROM transactions_log;

-- ==========================================
-- Question 6: Concurrent Transaction Simulation
-- ==========================================

-- CONNECTION 1:
START TRANSACTION;
UPDATE accounts SET balance = balance + 1000 WHERE account_id = 1;
-- Don't commit yet!

-- CONNECTION 2 (open another MySQL session):
-- SELECT balance FROM accounts WHERE account_id = 1;
-- Depending on isolation level:
-- - READ UNCOMMITTED: Sees the +1000 (dirty read)
-- - READ COMMITTED or higher: Sees original balance

-- In CONNECTION 1 after testing:
-- ROLLBACK;  -- or COMMIT;

-- ==========================================
-- Question 7: Change Isolation Level
-- ==========================================

-- View current isolation level
SELECT @@transaction_isolation;
-- or
SHOW VARIABLES LIKE 'transaction_isolation';

-- Set to READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Set back to REPEATABLE READ (MySQL default)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Set globally (affects all new sessions)
SET GLOBAL transaction_isolation = 'REPEATABLE-READ';

-- ==========================================
-- Question 8: Multiple SAVEPOINTs
-- ==========================================

START TRANSACTION;

-- Insert Account A
INSERT INTO accounts (account_holder, balance) VALUES ('Account A', 10000);
SAVEPOINT sp1;

-- Insert Account B
INSERT INTO accounts (account_holder, balance) VALUES ('Account B', 20000);
SAVEPOINT sp2;

-- Insert Account C
INSERT INTO accounts (account_holder, balance) VALUES ('Account C', 30000);
SAVEPOINT sp3;

-- Rollback to sp2 (removes Account C only)
ROLLBACK TO SAVEPOINT sp2;

-- Commit (Account A and B are saved, C is not)
COMMIT;

-- Verify:
SELECT * FROM accounts ORDER BY account_id DESC LIMIT 5;

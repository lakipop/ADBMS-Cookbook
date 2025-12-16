-- ==========================================
-- PRACTICAL 11: Database Security - ANSWERS
-- Database: CompanyDB
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    salary DECIMAL(12,2),
    ssn VARCHAR(20),
    department VARCHAR(50),
    hire_date DATE
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    manager_id INT,
    budget DECIMAL(15,2)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100),
    department_id INT,
    budget DECIMAL(12,2),
    start_date DATE,
    end_date DATE
);

CREATE TABLE user_activity_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100),
    action VARCHAR(100),
    table_name VARCHAR(100),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employees VALUES
(1, 'Kamal', 'Perera', 'kamal@company.com', '0771234567', 85000, 'SSN-001', 'IT', '2020-01-15'),
(2, 'Nimal', 'Silva', 'nimal@company.com', '0772345678', 75000, 'SSN-002', 'HR', '2021-03-20'),
(3, 'Sunil', 'Fernando', 'sunil@company.com', '0773456789', 95000, 'SSN-003', 'Finance', '2019-06-10'),
(4, 'Amara', 'Jayawardena', 'amara@company.com', '0774567890', 65000, 'SSN-004', 'IT', '2022-02-28'),
(5, 'Kumari', 'Rathnayake', 'kumari@company.com', '0775678901', 70000, 'SSN-005', 'HR', '2021-08-15');

INSERT INTO departments VALUES
(1, 'Information Technology', 1, 500000),
(2, 'Human Resources', 2, 200000),
(3, 'Finance', 3, 300000);

-- ==========================================
-- Question 1: Create Users
-- ==========================================

-- Drop users if they exist (for clean testing)
DROP USER IF EXISTS 'hr_user'@'localhost';
DROP USER IF EXISTS 'finance_user'@'%';
DROP USER IF EXISTS 'readonly_user'@'192.168.1.%';

-- Create hr_user - localhost only
CREATE USER 'hr_user'@'localhost' IDENTIFIED BY 'HRPass123!';

-- Create finance_user - any host
CREATE USER 'finance_user'@'%' IDENTIFIED BY 'FinancePass123!';

-- Create readonly_user - specific subnet
CREATE USER 'readonly_user'@'192.168.1.%' IDENTIFIED BY 'ReadOnly123!';

-- Verify:
SELECT User, Host FROM mysql.user WHERE User IN ('hr_user', 'finance_user', 'readonly_user');

-- ==========================================
-- Question 2: Grant SELECT Privileges
-- ==========================================

-- Grant readonly_user SELECT on all tables
GRANT SELECT ON CompanyDB.* TO 'readonly_user'@'192.168.1.%';

-- Grant hr_user SELECT on employees only
GRANT SELECT ON CompanyDB.employees TO 'hr_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- ==========================================
-- Question 3: Grant Multiple Privileges
-- ==========================================

-- Grant SELECT, INSERT, UPDATE on employees (no DELETE)
GRANT SELECT, INSERT, UPDATE ON CompanyDB.employees TO 'hr_user'@'localhost';

-- Grant SELECT only on departments
GRANT SELECT ON CompanyDB.departments TO 'hr_user'@'localhost';

FLUSH PRIVILEGES;

-- Verify:
SHOW GRANTS FOR 'hr_user'@'localhost';

-- ==========================================
-- Question 4: Grant All Privileges
-- ==========================================

-- Grant ALL PRIVILEGES with GRANT OPTION
GRANT ALL PRIVILEGES ON CompanyDB.* TO 'finance_user'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- Verify:
SHOW GRANTS FOR 'finance_user'@'%';

-- ==========================================
-- Question 5: Create Security View
-- ==========================================

-- Create view hiding sensitive data
CREATE OR REPLACE VIEW vw_PublicEmployeeInfo AS
SELECT 
    employee_id,
    first_name,
    last_name,
    department
FROM employees;

-- Grant SELECT on view to readonly_user
GRANT SELECT ON CompanyDB.vw_PublicEmployeeInfo TO 'readonly_user'@'192.168.1.%';

-- Now readonly_user can only see:
-- SELECT * FROM vw_PublicEmployeeInfo;
-- Cannot see: email, phone, salary, ssn

-- ==========================================
-- Question 6: Column-Level Privileges
-- ==========================================

-- Grant UPDATE on specific columns only
GRANT UPDATE (first_name, last_name, phone, department) 
ON CompanyDB.employees 
TO 'hr_user'@'localhost';

-- hr_user can update name, phone, department
-- hr_user CANNOT update salary or ssn

-- Test (as hr_user):
-- UPDATE employees SET first_name = 'John' WHERE employee_id = 1;  -- Works
-- UPDATE employees SET salary = 100000 WHERE employee_id = 1;  -- DENIED!

-- ==========================================
-- Question 7: Revoke Privileges
-- ==========================================

-- Revoke INSERT from hr_user on employees
REVOKE INSERT ON CompanyDB.employees FROM 'hr_user'@'localhost';

-- Revoke all privileges from readonly_user
REVOKE ALL PRIVILEGES ON CompanyDB.* FROM 'readonly_user'@'192.168.1.%';

-- Also revoke the view privilege
REVOKE SELECT ON CompanyDB.vw_PublicEmployeeInfo FROM 'readonly_user'@'192.168.1.%';

FLUSH PRIVILEGES;

-- Verify:
SHOW GRANTS FOR 'hr_user'@'localhost';
SHOW GRANTS FOR 'readonly_user'@'192.168.1.%';

-- ==========================================
-- Question 8: Create Roles (MySQL 8.0+)
-- ==========================================

-- Drop roles if exist
DROP ROLE IF EXISTS 'role_viewer', 'role_editor', 'role_admin';

-- Create roles
CREATE ROLE 'role_viewer';
CREATE ROLE 'role_editor';
CREATE ROLE 'role_admin';

-- Grant privileges to roles
GRANT SELECT ON CompanyDB.* TO 'role_viewer';
GRANT SELECT, INSERT, UPDATE ON CompanyDB.* TO 'role_editor';
GRANT ALL PRIVILEGES ON CompanyDB.* TO 'role_admin';

-- Assign role_viewer to readonly_user
GRANT 'role_viewer' TO 'readonly_user'@'192.168.1.%';

-- Set default role
SET DEFAULT ROLE 'role_viewer' TO 'readonly_user'@'192.168.1.%';

-- Verify roles:
SHOW GRANTS FOR 'role_viewer';
SHOW GRANTS FOR 'role_editor';
SHOW GRANTS FOR 'role_admin';

-- ==========================================
-- Question 9: Stored Procedure for Security
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetEmployeeSalary(IN p_employee_id INT)
BEGIN
    SELECT 
        CONCAT(first_name, ' ', last_name) AS employee_name,
        salary
    FROM employees
    WHERE employee_id = p_employee_id;
END //

DELIMITER ;

-- Grant EXECUTE only (no direct table access needed)
GRANT EXECUTE ON PROCEDURE CompanyDB.sp_GetEmployeeSalary TO 'hr_user'@'localhost';

-- Now hr_user can:
-- CALL sp_GetEmployeeSalary(1);  -- Works!

-- But hr_user cannot:
-- SELECT salary FROM employees;  -- DENIED! (if we didn't grant SELECT on salary)

-- ==========================================
-- Question 10: View User Privileges
-- ==========================================

-- 1. View all users in MySQL
SELECT User, Host FROM mysql.user;

-- 2. View privileges for hr_user
SHOW GRANTS FOR 'hr_user'@'localhost';

-- 3. View privileges on employees table
SELECT * FROM information_schema.TABLE_PRIVILEGES 
WHERE TABLE_NAME = 'employees' AND TABLE_SCHEMA = 'CompanyDB';

-- Alternative:
SELECT GRANTEE, PRIVILEGE_TYPE, IS_GRANTABLE 
FROM information_schema.TABLE_PRIVILEGES 
WHERE TABLE_NAME = 'employees';

-- ==========================================
-- Question 11: Password Management
-- ==========================================

-- 1. Change password for hr_user
ALTER USER 'hr_user'@'localhost' IDENTIFIED BY 'NewHRPass123!';

-- Alternative method:
-- SET PASSWORD FOR 'hr_user'@'localhost' = 'NewHRPass123!';

-- 2. SHA2 password hashing example
SELECT SHA2('my_password', 256) AS hashed_password;

-- In a users table:
-- CREATE TABLE app_users (
--     user_id INT PRIMARY KEY AUTO_INCREMENT,
--     username VARCHAR(50) UNIQUE,
--     password_hash VARCHAR(64)
-- );

-- INSERT INTO app_users (username, password_hash)
-- VALUES ('john', SHA2('secretpassword', 256));

-- Verify login:
-- SELECT * FROM app_users 
-- WHERE username = 'john' AND password_hash = SHA2('secretpassword', 256);

-- ==========================================
-- Question 12: Audit Trigger
-- ==========================================

DELIMITER //

CREATE TRIGGER trg_AuditEmployeeInsert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO user_activity_log (username, action, table_name)
    VALUES (
        CURRENT_USER(),
        CONCAT('INSERT: employee_id=', NEW.employee_id, ', name=', NEW.first_name, ' ', NEW.last_name),
        'employees'
    );
END //

DELIMITER ;

-- Also create for UPDATE:
DELIMITER //

CREATE TRIGGER trg_AuditEmployeeUpdate
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO user_activity_log (username, action, table_name)
    VALUES (
        CURRENT_USER(),
        CONCAT('UPDATE: employee_id=', NEW.employee_id),
        'employees'
    );
END //

DELIMITER ;

-- And for DELETE:
DELIMITER //

CREATE TRIGGER trg_AuditEmployeeDelete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO user_activity_log (username, action, table_name)
    VALUES (
        CURRENT_USER(),
        CONCAT('DELETE: employee_id=', OLD.employee_id, ', name=', OLD.first_name, ' ', OLD.last_name),
        'employees'
    );
END //

DELIMITER ;

-- Test:
INSERT INTO employees (first_name, last_name, email, department)
VALUES ('Test', 'User', 'test@company.com', 'IT');

SELECT * FROM user_activity_log;

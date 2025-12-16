-- ==========================================
-- PRACTICAL 05: User Defined Functions (UDFs) - ANSWERS
-- Database: MyDatabase
-- ==========================================

-- ==========================================
-- Question 1: Create Database
-- ==========================================

CREATE DATABASE IF NOT EXISTS MyDatabase;
USE MyDatabase;

-- ==========================================
-- Question 2: Create 'customers' Table
-- ==========================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);

-- Insert sample data
INSERT INTO customers (first_name, last_name, phone, email, street, city, state, zip_code) VALUES
('Miriam', 'Baker', '555-0101', 'miriam@email.com', '123 Main St', 'Manhattan', 'New York', '10001'),
('Jeanie', 'Kirkland', '555-0102', 'jeanie@email.com', '456 Oak Ave', 'Los Angeles', 'California', '90001'),
('Marquerite', 'Dawson', '555-0103', 'marquerite@email.com', '789 Pine Rd', 'Brooklyn', 'New York', '10002'),
('Babara', 'Ochoa', '555-0104', 'babara@email.com', '321 Elm St', 'Houston', 'Texas', '75001'),
('Nova', 'Hess', '555-0105', 'nova@email.com', '654 Maple Dr', 'Queens', 'New York', '10001'),
('Carley', 'Reynolds', '555-0106', 'carley@email.com', '987 Cedar Ln', 'Miami', 'Florida', '33001'),
('Carissa', 'Foreman', '555-0107', 'carissa@email.com', '147 Birch Blvd', 'San Diego', 'California', '90002'),
('Genoveva', 'Tyler', '555-0108', 'genoveva@email.com', '258 Walnut Way', 'Bronx', 'New York', '10003'),
('Deane', 'Sears', '555-0109', 'deane@email.com', '369 Cherry Ct', 'Dallas', 'Texas', '75002'),
('Karey', 'Steele', '555-0110', 'karey@email.com', '741 Spruce St', 'Tampa', 'Florida', '33002'),
('Lena', 'Mills', '555-0111', 'lena@email.com', '852 Ash Ave', 'Harlem', 'New York', '10001');

-- ==========================================
-- Question 3: Function - Get Customer Full Name
-- Output: "Miriam Baker"
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_GetCustomerFullName(p_customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE full_name VARCHAR(100);
    
    SELECT CONCAT(first_name, ' ', last_name) INTO full_name
    FROM customers
    WHERE customer_id = p_customer_id;
    
    RETURN full_name;
END //

DELIMITER ;

-- Usage:
-- SELECT customer_id, fn_GetCustomerFullName(customer_id) AS FullName FROM customers;

-- ==========================================
-- Question 4: Create 'Employee' Table
-- ==========================================

CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Address VARCHAR(100),
    Salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES (1, 'Ramesh', 32, 'Ahmedabad', 2000.00);
INSERT INTO Employee VALUES (2, 'Khilan', 25, 'Delhi', 1500.00);
INSERT INTO Employee VALUES (3, 'Kaushik', 23, 'Kota', 2000.00);
INSERT INTO Employee VALUES (4, 'Chaitali', 25, 'Mumbai', 6500.00);
INSERT INTO Employee VALUES (5, 'Hardik', 27, 'Bhopal', 8500.00);
INSERT INTO Employee VALUES (6, 'Komal', 22, 'MP', 4500.00);

-- ==========================================
-- Question 5: Function - Average Salary
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_GetAverageSalary()
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    
    SELECT AVG(Salary) INTO avg_salary FROM Employee;
    
    RETURN avg_salary;
END //

DELIMITER ;

-- Usage: SELECT fn_GetAverageSalary();

-- ==========================================
-- Question 6: Function - Employees Above Average
-- Return ID and Name where salary >= average
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_GetAverageSalaryValue()
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE avg_sal DECIMAL(10,2);
    SELECT AVG(Salary) INTO avg_sal FROM Employee;
    RETURN avg_sal;
END //

DELIMITER ;

-- Query using the function:
-- SELECT ID, Name, Salary 
-- FROM Employee 
-- WHERE Salary >= fn_GetAverageSalaryValue();

-- Alternative: Procedure to return employees above average
DELIMITER //

CREATE PROCEDURE sp_GetEmployeesAboveAverage()
BEGIN
    DECLARE avg_sal DECIMAL(10,2);
    SELECT AVG(Salary) INTO avg_sal FROM Employee;
    
    SELECT ID, Name, Salary, avg_sal AS AverageSalary
    FROM Employee
    WHERE Salary >= avg_sal;
END //

DELIMITER ;

-- ==========================================
-- Question 7: Scalar Function - Total Price
-- Formula: quantity * unit_price * (1 - discount)
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_CalculateTotalPrice(
    p_quantity INT,
    p_unit_price DECIMAL(10,2),
    p_discount DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_quantity * p_unit_price * (1 - p_discount);
END //

DELIMITER ;

-- Usage: SELECT fn_CalculateTotalPrice(10, 100.00, 0.10); 
-- Returns: 900.00 (10 * 100 * 0.9)

-- ==========================================
-- Question 8: Function - Customers in New York
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetCustomersInNewYork()
BEGIN
    SELECT * FROM customers WHERE state = 'New York';
END //

DELIMITER ;

-- Alternative: Using a View
CREATE VIEW vw_NewYorkCustomers AS
SELECT * FROM customers WHERE state = 'New York';

-- Usage: SELECT * FROM vw_NewYorkCustomers;

-- ==========================================
-- Question 9: Table-Valued Function - Customers by Zip Code
-- Return: first_name, street, city
-- ==========================================

-- MySQL doesn't have true table-valued functions like SQL Server
-- Using a Stored Procedure instead:

DELIMITER //

CREATE PROCEDURE sp_GetCustomersByZipCode(IN p_zip_code VARCHAR(10))
BEGIN
    SELECT first_name, street, city
    FROM customers
    WHERE zip_code = p_zip_code;
END //

DELIMITER ;

-- Call: CALL sp_GetCustomersByZipCode('10001');

-- Alternative: Parameterized View using Prepared Statement
-- Or create a view and filter:
CREATE VIEW vw_CustomerAddresses AS
SELECT customer_id, first_name, street, city, zip_code FROM customers;

-- Usage: SELECT * FROM vw_CustomerAddresses WHERE zip_code = '10001';

-- ==========================================
-- Question 10: Table-Valued Function - Employees by ID
-- Return: name, salary
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetEmployeeById(IN p_id INT)
BEGIN
    SELECT Name, Salary
    FROM Employee
    WHERE ID = p_id;
END //

DELIMITER ;

-- Call: CALL sp_GetEmployeeById(1);

-- ==========================================
-- Question 11: Modified Function - Employees by Age Range
-- Return: name, salary for specific age range
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetEmployeesByAgeRange(
    IN p_min_age INT,
    IN p_max_age INT
)
BEGIN
    SELECT Name, Salary
    FROM Employee
    WHERE Age BETWEEN p_min_age AND p_max_age;
END //

DELIMITER ;

-- Call: CALL sp_GetEmployeesByAgeRange(22, 27);

-- ==========================================
-- BONUS: Inline Table-Valued Function Equivalent
-- Using Views with Parameters (Common Pattern in MySQL)
-- ==========================================

-- Create base view
CREATE VIEW vw_EmployeeDetails AS
SELECT ID, Name, Age, Salary FROM Employee;

-- Usage with filtering:
-- SELECT * FROM vw_EmployeeDetails WHERE Age BETWEEN 22 AND 27;

-- ==========================================
-- Summary of All Functions Created:
-- ==========================================
-- 1. fn_GetCustomerFullName(customer_id) - Returns full name
-- 2. fn_GetAverageSalary() - Returns average salary
-- 3. fn_GetAverageSalaryValue() - Helper for Q6
-- 4. fn_CalculateTotalPrice(qty, price, discount) - Calculates total
-- 5. sp_GetEmployeesAboveAverage() - Procedure for above avg employees
-- 6. sp_GetCustomersInNewYork() - Customers in NY
-- 7. sp_GetCustomersByZipCode(zip) - Customers by zip
-- 8. sp_GetEmployeeById(id) - Employee by ID
-- 9. sp_GetEmployeesByAgeRange(min, max) - Employees in age range

-- ==========================================
-- Question 12: Create Emp Table (DOB/Location)
-- ==========================================

CREATE TABLE Emp (
    Name VARCHAR(255),
    DOB DATE,
    Location VARCHAR(255)
);

INSERT INTO Emp VALUES ('Amit', '1970-01-08', 'Nuwara');
INSERT INTO Emp VALUES ('Sumith', '1990-11-02', 'Galle');
INSERT INTO Emp VALUES ('Sudha', '1980-11-06', 'Jaffna');

-- ==========================================
-- Question 13: Function - Get DOB
-- ==========================================

DELIMITER //

CREATE FUNCTION getDob(empName VARCHAR(255))
RETURNS DATE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE empDob DATE;
    
    SELECT DOB INTO empDob
    FROM Emp
    WHERE Name = empName;
    
    RETURN empDob;
END //

DELIMITER ;

-- ==========================================
-- Question 14: Function - Get Location
-- ==========================================

DELIMITER //

CREATE FUNCTION getLocation(empName VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE empLocation VARCHAR(255);
    
    SELECT Location INTO empLocation
    FROM Emp
    WHERE Name = empName;
    
    RETURN empLocation;
END //

DELIMITER ;

-- ==========================================
-- Question 15: Call Functions
-- ==========================================

-- Get DOB of Amit
SELECT getDob('Amit') AS DateOfBirth;
-- Expected: 1970-01-08

-- Get Location of Sumith
SELECT getLocation('Sumith') AS Location;
-- Expected: Galle

-- Use in SELECT statement
SELECT 
    Name,
    getDob(Name) AS DOB,
    getLocation(Name) AS Location
FROM Emp;

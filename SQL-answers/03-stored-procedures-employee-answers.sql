-- ==========================================
-- PRACTICAL 03: Stored Procedures (Employee) - ANSWERS
-- Database: employeeDetails
-- ==========================================

-- ==========================================
-- Question 1: Create Database
-- ==========================================

CREATE DATABASE IF NOT EXISTS employeeDetails;
USE employeeDetails;

-- ==========================================
-- Question 2: Create Table 'Emp'
-- ==========================================

CREATE TABLE Emp (
    Name VARCHAR(255),
    DOB DATE,
    Location VARCHAR(255)
);

-- ==========================================
-- Question 3: Insert Data
-- ==========================================

INSERT INTO Emp VALUES ('Amit', DATE('1970-01-08'), 'Nuwara');
INSERT INTO Emp VALUES ('Sumith', DATE('1990-11-02'), 'Galle');
INSERT INTO Emp VALUES ('Sudha', DATE('1980-11-06'), 'Jaffna');

-- ==========================================
-- Question 4: Function (getDob)
-- Get DOB by employee name
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
-- Question 5: Function (getLocation)
-- Get Location by employee name
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
-- Question 6: Call Functions
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

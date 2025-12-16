-- ==========================================
-- PRACTICAL 13: Indexing - ANSWERS
-- Database: db_SAEngineering
-- ==========================================

-- ==========================================
-- Question 1: Create Database
-- ==========================================

CREATE DATABASE IF NOT EXISTS db_SAEngineering;
USE db_SAEngineering;

-- ==========================================
-- Question 2: Create Employee Table
-- (EmployeeID not PK initially)
-- ==========================================

CREATE TABLE Employee (
    EmployeeID INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    HireDate DATE,
    DepartmentID INT
);

-- ==========================================
-- Question 3: Insert Employee Data (10 records)
-- ==========================================

INSERT INTO Employee VALUES (1, 'Kamal', 'Perera', 'kamal@email.com', '2020-01-15', 1);
INSERT INTO Employee VALUES (2, 'Nimal', 'Silva', 'nimal@email.com', '2019-03-20', 2);
INSERT INTO Employee VALUES (3, 'Sunil', 'Fernando', 'sunil@email.com', '2021-06-10', 1);
INSERT INTO Employee VALUES (4, 'Amara', 'Jayawardena', 'amara@email.com', '2018-09-05', 3);
INSERT INTO Employee VALUES (5, 'Kumari', 'Rathnayake', 'kumari@email.com', '2022-02-28', 2);
INSERT INTO Employee VALUES (6, 'Saman', 'Wickrama', 'saman@email.com', '2020-11-12', 4);
INSERT INTO Employee VALUES (7, 'Dilani', 'Gunasekara', 'dilani@email.com', '2019-08-18', 3);
INSERT INTO Employee VALUES (8, 'Ruwan', 'Bandara', 'ruwan@email.com', '2021-04-25', 5);
INSERT INTO Employee VALUES (9, 'Malini', 'Samarasinghe', 'malini@email.com', '2017-12-01', 1);
INSERT INTO Employee VALUES (10, 'Nuwan', 'Dissanayake', 'nuwan@email.com', '2023-01-10', 2);

-- ==========================================
-- Question 4: Create Clustered Index
-- (In MySQL/InnoDB, this requires making EmployeeID the PK)
-- ==========================================

-- In MySQL, the PRIMARY KEY is the clustered index
ALTER TABLE Employee ADD PRIMARY KEY (EmployeeID);

-- Note: In MySQL InnoDB, the PRIMARY KEY automatically becomes 
-- the clustered index. If no PK, InnoDB uses first UNIQUE NOT NULL 
-- index or creates a hidden row ID.

-- ==========================================
-- Question 5: Create Department Table
-- ==========================================

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);

-- ==========================================
-- Question 6: Insert Department Data (6 records)
-- ==========================================

INSERT INTO Department (DepartmentName, Location) VALUES ('Web Development', 'Colombo');
INSERT INTO Department (DepartmentName, Location) VALUES ('Mobile Development', 'Kandy');
INSERT INTO Department (DepartmentName, Location) VALUES ('Data Science', 'Galle');
INSERT INTO Department (DepartmentName, Location) VALUES ('Quality Assurance', 'Colombo');
INSERT INTO Department (DepartmentName, Location) VALUES ('DevOps', 'Jaffna');
INSERT INTO Department (DepartmentName, Location) VALUES ('UI/UX Design', 'Colombo');

-- ==========================================
-- Question 7: Create Relationship (Foreign Key)
-- One department has many employees
-- ==========================================

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);

-- ==========================================
-- Question 8: Modify/Remove Primary Key
-- ==========================================

-- First drop the foreign key constraint
ALTER TABLE Employee DROP FOREIGN KEY fk_employee_department;

-- Then drop the primary key
ALTER TABLE Employee DROP PRIMARY KEY;

-- Note: Don't actually run this if you need the PK for other operations

-- ==========================================
-- Question 9: Create Clustered Index on DepartmentID
-- (Re-add different clustered index)
-- ==========================================

-- In MySQL, we can only have one clustered index (the PK)
-- To change it, we need to:
-- 1. Drop current PK (done in Q8)
-- 2. Add new PK on different column

-- Add EmployeeID back as regular column with index
ALTER TABLE Employee ADD PRIMARY KEY (EmployeeID);

-- Create index on DepartmentID (non-clustered since PK exists)
CREATE INDEX idx_employee_dept ON Employee(DepartmentID);

-- Re-add foreign key
ALTER TABLE Employee
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);

-- ==========================================
-- Question 10: Create Project Table
-- ==========================================

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
);

-- ==========================================
-- Question 11: Insert Project Data (6 records)
-- ==========================================

INSERT INTO Project VALUES (1, 'E-Commerce Platform', '2023-01-01', '2023-06-30');
INSERT INTO Project VALUES (2, 'Mobile Banking App', '2023-02-15', '2023-08-15');
INSERT INTO Project VALUES (3, 'CRM System', '2023-03-01', '2023-09-30');
INSERT INTO Project VALUES (4, 'Inventory Management', '2023-04-01', '2023-10-31');
INSERT INTO Project VALUES (5, 'HR Portal', '2023-05-01', '2023-11-30');
INSERT INTO Project VALUES (6, 'Analytics Dashboard', '2023-06-01', '2023-12-31');

-- ==========================================
-- Question 12: Create EmployeeProjects Table
-- ==========================================

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    DepartmentID INT,
    ProjectID INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- Insert sample assignments
INSERT INTO EmployeeProjects VALUES (1, 1, 1);
INSERT INTO EmployeeProjects VALUES (2, 2, 2);
INSERT INTO EmployeeProjects VALUES (3, 1, 1);
INSERT INTO EmployeeProjects VALUES (4, 3, 3);
INSERT INTO EmployeeProjects VALUES (5, 2, 2);
INSERT INTO EmployeeProjects VALUES (1, 1, 3);

-- ==========================================
-- Question 13: Non-Clustered Index on FirstName
-- ==========================================

CREATE INDEX idx_firstname ON Employee(FirstName);

-- Usage: SELECT * FROM Employee WHERE FirstName = 'Kamal';

-- ==========================================
-- Question 14: Unique Index on Email
-- ==========================================

CREATE UNIQUE INDEX idx_unique_email ON Employee(Email);

-- This ensures no duplicate emails can be inserted

-- ==========================================
-- Question 15: Unique Index on DepartmentName + Location
-- ==========================================

CREATE UNIQUE INDEX idx_unique_dept_location 
ON Department(DepartmentName, Location);

-- This ensures unique combination of name and location

-- ==========================================
-- Question 16: Add Columns to Employee Table
-- ==========================================

ALTER TABLE Employee
ADD COLUMN ContactNumber VARCHAR(15),
ADD COLUMN City VARCHAR(50),
ADD COLUMN District VARCHAR(50),
ADD COLUMN Province VARCHAR(50);

-- ==========================================
-- Question 17: Update Employee Data with Location Details
-- ==========================================

UPDATE Employee SET ContactNumber = '0771234567', City = 'Colombo', District = 'Colombo', Province = 'Western' WHERE EmployeeID = 1;
UPDATE Employee SET ContactNumber = '0772345678', City = 'Kandy', District = 'Kandy', Province = 'Central' WHERE EmployeeID = 2;
UPDATE Employee SET ContactNumber = '0773456789', City = 'Galle', District = 'Galle', Province = 'Southern' WHERE EmployeeID = 3;
UPDATE Employee SET ContactNumber = '0774567890', City = 'Colombo', District = 'Colombo', Province = 'Western' WHERE EmployeeID = 4;
UPDATE Employee SET ContactNumber = '0775678901', City = 'Jaffna', District = 'Jaffna', Province = 'Northern' WHERE EmployeeID = 5;
UPDATE Employee SET ContactNumber = '0776789012', City = 'Colombo', District = 'Colombo', Province = 'Western' WHERE EmployeeID = 6;
UPDATE Employee SET ContactNumber = '0777890123', City = 'Kandy', District = 'Kandy', Province = 'Central' WHERE EmployeeID = 7;
UPDATE Employee SET ContactNumber = '0778901234', City = 'Galle', District = 'Galle', Province = 'Southern' WHERE EmployeeID = 8;
UPDATE Employee SET ContactNumber = '0779012345', City = 'Colombo', District = 'Colombo', Province = 'Western' WHERE EmployeeID = 9;
UPDATE Employee SET ContactNumber = '0770123456', City = 'Kandy', District = 'Kandy', Province = 'Central' WHERE EmployeeID = 10;

-- ==========================================
-- Question 18: Index - Department and City
-- Composite index for queries by dept AND city
-- ==========================================

CREATE INDEX idx_department_city ON Employee(DepartmentID, City);

-- Usage: SELECT * FROM Employee WHERE DepartmentID = 1 AND City = 'Colombo';

-- ==========================================
-- Question 19: Index - Project End Date
-- For finding employees by project end date
-- ==========================================

CREATE INDEX idx_project_enddate ON Project(EndDate);

-- Or create on EmployeeProjects with join:
CREATE INDEX idx_employeeprojects_project ON EmployeeProjects(ProjectID);

-- Usage: 
-- SELECT e.* FROM Employee e
-- JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- JOIN Project p ON ep.ProjectID = p.ProjectID
-- WHERE p.EndDate = '2023-06-30';

-- ==========================================
-- Question 20: Index - Province and Project
-- Composite index for province-based project search
-- ==========================================

CREATE INDEX idx_employee_province ON Employee(Province);

-- For combined queries, you might need:
-- Since Province is in Employee and Project is linked via EmployeeProjects,
-- create indexes on both tables

CREATE INDEX idx_emp_province_project ON Employee(Province, EmployeeID);

-- Usage:
-- SELECT e.*, p.ProjectName FROM Employee e
-- JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- JOIN Project p ON ep.ProjectID = p.ProjectID
-- WHERE e.Province = 'Western';

-- ==========================================
-- Show All Indexes
-- ==========================================

-- SHOW INDEX FROM Employee;
-- SHOW INDEX FROM Department;
-- SHOW INDEX FROM Project;
-- SHOW INDEX FROM EmployeeProjects;

-- ==========================================
-- Summary of Indexes Created:
-- ==========================================
-- 1. PRIMARY KEY on Employee(EmployeeID) - Clustered
-- 2. PRIMARY KEY on Department(DepartmentID) - Clustered, Auto Increment
-- 3. PRIMARY KEY on Project(ProjectID) - Clustered
-- 4. PRIMARY KEY on EmployeeProjects(EmployeeID, ProjectID) - Composite Clustered
-- 5. idx_employee_dept on Employee(DepartmentID) - Non-clustered
-- 6. idx_firstname on Employee(FirstName) - Non-clustered
-- 7. idx_unique_email on Employee(Email) - Unique
-- 8. idx_unique_dept_location on Department(DepartmentName, Location) - Unique Composite
-- 9. idx_department_city on Employee(DepartmentID, City) - Composite
-- 10. idx_project_enddate on Project(EndDate) - Non-clustered
-- 11. idx_employeeprojects_project on EmployeeProjects(ProjectID) - Non-clustered
-- 12. idx_employee_province on Employee(Province) - Non-clustered

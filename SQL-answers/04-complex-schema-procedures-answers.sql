-- ==========================================
-- PRACTICAL 04: Complex Schema & Procedures - ANSWERS
-- Database: myStoredDB
-- ==========================================

-- ==========================================
-- Question 1: Create Database & All Tables
-- ==========================================

CREATE DATABASE IF NOT EXISTS myStoredDB;
USE myStoredDB;

-- Login Table
CREATE TABLE Login (
    UID INT PRIMARY KEY,
    Username VARCHAR(50),
    Password VARCHAR(50)
);

-- Department Table (Auto Increment)
CREATE TABLE Department (
    DID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    description VARCHAR(100)
);

-- Role Table (Auto Increment)
CREATE TABLE Role (
    RID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    description VARCHAR(100)
);

-- Employee Table (with Foreign Keys)
CREATE TABLE Employee (
    EID VARCHAR(10) PRIMARY KEY,
    E_fname VARCHAR(50),
    E_lname VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(100),
    Age INT,
    DID INT,
    RID INT,
    UID INT,
    FOREIGN KEY (DID) REFERENCES Department(DID),
    FOREIGN KEY (RID) REFERENCES Role(RID),
    FOREIGN KEY (UID) REFERENCES Login(UID)
);

-- ==========================================
-- Question 2: Insert All Data
-- ==========================================

-- Insert Login data
INSERT INTO Login VALUES (001, 'sarath', 's12');
INSERT INTO Login VALUES (002, 'kamal', 'k12');
INSERT INTO Login VALUES (003, 'amali', 'a12');
INSERT INTO Login VALUES (004, 'shani', 's21');
INSERT INTO Login VALUES (005, 'nimesha', 'n12');

-- Insert Department data
INSERT INTO Department (name, description) VALUES ('Science', 'Science dep');
INSERT INTO Department (name, description) VALUES ('IT', 'IT dep');
INSERT INTO Department (name, description) VALUES ('Maths', 'Maths dep');
INSERT INTO Department (name, description) VALUES ('ET', 'ET dep');
INSERT INTO Department (name, description) VALUES ('BST', 'BST dep');

-- Insert Role data
INSERT INTO Role (name, description) VALUES ('QA Engineer', 'Role 1');
INSERT INTO Role (name, description) VALUES ('SE Engineer', 'Role 2');
INSERT INTO Role (name, description) VALUES ('Project Manager', 'Role 3');
INSERT INTO Role (name, description) VALUES ('Business Analyst', 'Role 4');
INSERT INTO Role (name, description) VALUES ('Technical Consultant', 'Role 5');

-- Insert Employee data
INSERT INTO Employee VALUES ('E001', 'Sarath', 'Weerasinghe', '0715267893', 'abcsarath@gmail.com', 22, 1, 1, 1);
INSERT INTO Employee VALUES ('E002', 'Kamal', 'Nadhun', '0778945613', 'abckamal@gmail.com', 58, 2, 2, 2);
INSERT INTO Employee VALUES ('E003', 'Amali', 'Sadamini', '0725468134', 'abcamali@gmail.com', 45, 3, 3, 3);
INSERT INTO Employee VALUES ('E004', 'Shani', 'Arosha', '0707775552', 'abcshani@gmail.com', 25, 4, 4, 4);
INSERT INTO Employee VALUES ('E005', 'Nimesha', 'Sewwandi', '0768882225', 'abcnimesha@gmail.com', 30, 5, 5, 5);

-- ==========================================
-- Question 3: Get All Employees
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetAllEmployees()
BEGIN
    SELECT * FROM Employee;
END //
DELIMITER ;

-- ==========================================
-- Question 4: Get Employee by ID
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetEmployeeById(IN p_EID VARCHAR(10))
BEGIN
    SELECT * FROM Employee WHERE EID = p_EID;
END //
DELIMITER ;

-- ==========================================
-- Question 5: Get All Departments
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetAllDepartments()
BEGIN
    SELECT * FROM Department;
END //
DELIMITER ;

-- ==========================================
-- Question 6: Get All Roles
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetAllRoles()
BEGIN
    SELECT * FROM Role;
END //
DELIMITER ;

-- ==========================================
-- Question 7: Get All Logins
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetAllLogins()
BEGIN
    SELECT * FROM Login;
END //
DELIMITER ;

-- ==========================================
-- Question 8: Employees Age > 30
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetEmployeesAbove30()
BEGIN
    SELECT * FROM Employee WHERE Age > 30;
END //
DELIMITER ;

-- ==========================================
-- Question 9: usp_GetLastName
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetLastName(IN p_EID VARCHAR(10), OUT p_LastName VARCHAR(50))
BEGIN
    SELECT E_lname INTO p_LastName FROM Employee WHERE EID = p_EID;
END //
DELIMITER ;

-- Call: CALL usp_GetLastName('E001', @lastName); SELECT @lastName;

-- ==========================================
-- Question 10: usp_GetFirstName
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetFirstName(IN p_EID VARCHAR(10), OUT p_FirstName VARCHAR(50))
BEGIN
    SELECT E_fname INTO p_FirstName FROM Employee WHERE EID = p_EID;
END //
DELIMITER ;

-- ==========================================
-- Question 11: Get Department Name by Employee ID
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetDepartmentByEmployee(IN p_EID VARCHAR(10))
BEGIN
    SELECT d.name AS DepartmentName
    FROM Employee e
    INNER JOIN Department d ON e.DID = d.DID
    WHERE e.EID = p_EID;
END //
DELIMITER ;

-- ==========================================
-- Question 12: Get Role Name by Employee ID
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetRoleByEmployee(IN p_EID VARCHAR(10))
BEGIN
    SELECT r.name AS RoleName
    FROM Employee e
    INNER JOIN Role r ON e.RID = r.RID
    WHERE e.EID = p_EID;
END //
DELIMITER ;

-- ==========================================
-- Question 13: Count Employees by Department
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_CountEmployeesByDepartment(IN p_DID INT, OUT p_Count INT)
BEGIN
    SELECT COUNT(*) INTO p_Count
    FROM Employee
    WHERE DID = p_DID;
END //
DELIMITER ;

-- ==========================================
-- Question 14: Get Login Details by Employee ID
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetLoginByEmployee(IN p_EID VARCHAR(10))
BEGIN
    SELECT l.*
    FROM Employee e
    INNER JOIN Login l ON e.UID = l.UID
    WHERE e.EID = p_EID;
END //
DELIMITER ;

-- ==========================================
-- PART B: Student Marks Section
-- ==========================================

-- ==========================================
-- Question 15: Create student_marks Table
-- ==========================================

CREATE TABLE student_marks (
    stud_id INT PRIMARY KEY,
    total_marks INT,
    grade VARCHAR(5)
);

INSERT INTO student_marks VALUES (1, 450, 'A');
INSERT INTO student_marks VALUES (2, 380, 'B');
INSERT INTO student_marks VALUES (3, 290, 'C');
INSERT INTO student_marks VALUES (4, 420, 'A');
INSERT INTO student_marks VALUES (5, 350, 'B');
INSERT INTO student_marks VALUES (6, 270, 'C');
INSERT INTO student_marks VALUES (7, 490, 'A');
INSERT INTO student_marks VALUES (8, 310, 'B');
INSERT INTO student_marks VALUES (9, 250, 'C');
INSERT INTO student_marks VALUES (10, 400, 'A');
INSERT INTO student_marks VALUES (11, 280, 'C');

-- ==========================================
-- Question 16: Get All studentMarks
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetAllStudentMarks()
BEGIN
    SELECT * FROM student_marks;
END //
DELIMITER ;

-- ==========================================
-- Question 17: Fetch Student by ID
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetStudentById(IN p_stud_id INT)
BEGIN
    SELECT * FROM student_marks WHERE stud_id = p_stud_id;
END //
DELIMITER ;

-- ==========================================
-- Question 18: Calculate Average (OUT Parameter)
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_GetAverageMarks(OUT p_avg DECIMAL(10,2))
BEGIN
    SELECT AVG(total_marks) INTO p_avg FROM student_marks;
END //
DELIMITER ;

-- Call: CALL usp_GetAverageMarks(@avg); SELECT @avg;

-- ==========================================
-- Question 19: Count Below Average
-- ==========================================

DELIMITER //
CREATE PROCEDURE usp_CountBelowAverage(OUT p_count INT)
BEGIN
    DECLARE avg_marks DECIMAL(10,2);
    SELECT AVG(total_marks) INTO avg_marks FROM student_marks;
    SELECT COUNT(*) INTO p_count FROM student_marks WHERE total_marks < avg_marks;
END //
DELIMITER ;

-- ==========================================
-- Question 20: Increment Function
-- ==========================================

DELIMITER //
CREATE FUNCTION fn_Increment(initial_value INT, increment_by INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN initial_value + increment_by;
END //
DELIMITER ;

-- Call: SELECT fn_Increment(10, 5); -- Returns 15

-- ==========================================
-- Question 21: spGetIsAboveAverage
-- Returns 1 if above average, 0 otherwise
-- ==========================================

DELIMITER //
CREATE PROCEDURE spGetIsAboveAverage(IN p_stud_id INT, OUT p_result INT)
BEGIN
    DECLARE avg_marks DECIMAL(10,2);
    DECLARE student_total INT;
    
    SELECT AVG(total_marks) INTO avg_marks FROM student_marks;
    SELECT total_marks INTO student_total FROM student_marks WHERE stud_id = p_stud_id;
    
    IF student_total >= avg_marks THEN
        SET p_result = 1;
    ELSE
        SET p_result = 0;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Question 22: spGetStudentResult
-- Calls spGetIsAboveAverage, outputs PASS/FAIL
-- ==========================================

DELIMITER //
CREATE PROCEDURE spGetStudentResult(IN p_stud_id INT, OUT p_result VARCHAR(10))
BEGIN
    DECLARE is_above INT;
    
    CALL spGetIsAboveAverage(p_stud_id, is_above);
    
    IF is_above = 1 THEN
        SET p_result = 'PASS';
    ELSE
        SET p_result = 'FAIL';
    END IF;
END //
DELIMITER ;

-- Call: CALL spGetStudentResult(1, @result); SELECT @result;

-- ==========================================
-- Question 23: Student Class by Marks
-- >= 400: First Class, >= 300: Second Class, < 300: Failed
-- ==========================================

DELIMITER //
CREATE PROCEDURE spGetStudentClass(IN p_stud_id INT, OUT p_class VARCHAR(20))
BEGIN
    DECLARE student_marks INT;
    
    SELECT total_marks INTO student_marks 
    FROM student_marks WHERE stud_id = p_stud_id;
    
    IF student_marks >= 400 THEN
        SET p_class = 'First Class';
    ELSEIF student_marks >= 300 THEN
        SET p_class = 'Second Class';
    ELSE
        SET p_class = 'Failed';
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Question 24: spInsertStudentDataExit (Error Handler - EXIT)
-- ==========================================

DELIMITER //
CREATE PROCEDURE spInsertStudentDataExit(
    IN p_stud_id INT,
    IN p_total_marks INT,
    IN p_grade VARCHAR(5),
    OUT p_rowCount INT
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SET p_rowCount = 0;
    END;
    
    INSERT INTO student_marks (stud_id, total_marks, grade)
    VALUES (p_stud_id, p_total_marks, p_grade);
    
    SET p_rowCount = ROW_COUNT();
END //
DELIMITER ;

-- Call with existing ID:
-- CALL spInsertStudentDataExit(1, 500, 'A', @rows);
-- SELECT @rows; -- Returns 0 (duplicate key error handled)

-- ==========================================
-- Question 25: spInsertStudentDataContinue (Error Handler - CONTINUE)
-- ==========================================

DELIMITER //
CREATE PROCEDURE spInsertStudentDataContinue(
    IN p_stud_id INT,
    IN p_total_marks INT,
    IN p_grade VARCHAR(5),
    OUT p_rowCount INT
)
BEGIN
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SET p_rowCount = -1;
    END;
    
    SET p_rowCount = 0;
    
    INSERT INTO student_marks (stud_id, total_marks, grade)
    VALUES (p_stud_id, p_total_marks, p_grade);
    
    IF p_rowCount != -1 THEN
        SET p_rowCount = ROW_COUNT();
    END IF;
END //
DELIMITER ;

-- Call with existing ID:
-- CALL spInsertStudentDataContinue(1, 500, 'A', @rows);
-- SELECT @rows; -- Returns -1 (error occurred but continued)

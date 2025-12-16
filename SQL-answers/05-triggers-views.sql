-- ==========================================
-- PRACTICAL 11: Triggers & Views - ANSWERS
-- ==========================================

-- ==========================================
-- PART A: TRIGGER QUESTIONS
-- ==========================================

-- ==========================================
-- Question 1: Auto-Add 100 Marks Trigger
-- ==========================================

CREATE DATABASE IF NOT EXISTS TriggerPractice;
USE TriggerPractice;

CREATE TABLE Student (
    Student_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Address VARCHAR(100),
    Marks INT
);

DELIMITER //

CREATE TRIGGER trg_AddBonusMarks
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    SET NEW.Marks = NEW.Marks + 100;
END //

DELIMITER ;

-- Test: INSERT INTO Student (Name, Address, Marks) VALUES ('John', 'Colombo', 50);
-- Result: Marks will be 150

-- ==========================================
-- Question 2: Auto Calculate Total & Average
-- (Assessment table trigger)
-- ==========================================

CREATE TABLE student_info (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    total_marks DECIMAL(10,2) DEFAULT 0,
    average_marks DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE assessment (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject VARCHAR(50),
    marks INT,
    FOREIGN KEY (student_id) REFERENCES student_info(student_id)
);

DELIMITER //

CREATE TRIGGER trg_UpdateTotalAverage
AFTER INSERT ON assessment
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE avg_marks DECIMAL(10,2);
    DECLARE count_subjects INT;
    
    SELECT SUM(marks), COUNT(*), AVG(marks) 
    INTO total, count_subjects, avg_marks
    FROM assessment
    WHERE student_id = NEW.student_id;
    
    UPDATE student_info
    SET total_marks = total, average_marks = avg_marks
    WHERE student_id = NEW.student_id;
END //

DELIMITER ;

-- ==========================================
-- Question 3: Calculate Total & Percentage (BEFORE INSERT)
-- ==========================================

CREATE TABLE Student_Trigger (
    Student_RollNo INT PRIMARY KEY,
    Student_FirstName VARCHAR(50),
    Student_EnglishMarks INT,
    Student_PhysicsMarks INT,
    Student_ChemistryMarks INT,
    Student_MathsMarks INT,
    Student_TotalMarks INT,
    Student_Percentage DECIMAL(5,2)
);

DELIMITER //

CREATE TRIGGER trg_CalculateTotalPercentage
BEFORE INSERT ON Student_Trigger
FOR EACH ROW
BEGIN
    SET NEW.Student_TotalMarks = NEW.Student_EnglishMarks + 
                                  NEW.Student_PhysicsMarks + 
                                  NEW.Student_ChemistryMarks + 
                                  NEW.Student_MathsMarks;
    
    SET NEW.Student_Percentage = (NEW.Student_TotalMarks / 400) * 100;
END //

DELIMITER ;

-- Test: INSERT INTO Student_Trigger (Student_RollNo, Student_FirstName, Student_EnglishMarks, Student_PhysicsMarks, Student_ChemistryMarks, Student_MathsMarks, Student_TotalMarks, Student_Percentage)
-- VALUES (1, 'John', 80, 75, 85, 90, 0, 0);
-- Result: TotalMarks = 330, Percentage = 82.50

-- ==========================================
-- Question 4: Inventory Reorder Trigger
-- ==========================================

CREATE TABLE tbl_product (
    pro_id INT PRIMARY KEY,
    pro_price DECIMAL(10,2),
    pro_sprice DECIMAL(10,2),
    pro_quantity INT,
    reorder_qty INT
);

CREATE TABLE tbl_proreorder (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pro_id INT,
    quantity INT,
    reorder_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_CheckReorder
AFTER UPDATE ON tbl_product
FOR EACH ROW
BEGIN
    IF NEW.pro_quantity <= NEW.reorder_qty THEN
        INSERT INTO tbl_proreorder (pro_id, quantity)
        VALUES (NEW.pro_id, NEW.reorder_qty);
    END IF;
END //

DELIMITER ;

-- Also for INSERT:
DELIMITER //

CREATE TRIGGER trg_CheckReorderInsert
AFTER INSERT ON tbl_product
FOR EACH ROW
BEGIN
    IF NEW.pro_quantity <= NEW.reorder_qty THEN
        INSERT INTO tbl_proreorder (pro_id, quantity)
        VALUES (NEW.pro_id, NEW.reorder_qty);
    END IF;
END //

DELIMITER ;

-- ==========================================
-- Question 5: ON DELETE CASCADE Trigger
-- (Not recommended - use FK constraints instead)
-- ==========================================

CREATE TABLE Department (
    Depid INT PRIMARY KEY,
    Depname VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    Age INT,
    Address VARCHAR(100),
    Depid INT
);

DELIMITER //

CREATE TRIGGER trg_DeleteEmployeesOnDeptDelete
BEFORE DELETE ON Department
FOR EACH ROW
BEGIN
    DELETE FROM Employee WHERE Depid = OLD.Depid;
END //

DELIMITER ;

-- Note: Better approach is using FK with ON DELETE CASCADE:
-- ALTER TABLE Employee ADD FOREIGN KEY (Depid) REFERENCES Department(Depid) ON DELETE CASCADE;

-- ==========================================
-- Question 6: Location History Trigger
-- ==========================================

CREATE TABLE Locations (
    LocationID INT PRIMARY KEY,
    LocName VARCHAR(100)
);

CREATE TABLE LocationHist (
    HistID INT PRIMARY KEY AUTO_INCREMENT,
    LocationID INT,
    OldLocName VARCHAR(100),
    NewLocName VARCHAR(100),
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_LocationHistory
AFTER UPDATE ON Locations
FOR EACH ROW
BEGIN
    INSERT INTO LocationHist (LocationID, OldLocName, NewLocName)
    VALUES (OLD.LocationID, OLD.LocName, NEW.LocName);
END //

DELIMITER ;

-- ==========================================
-- Question 7: Book Issue Trigger
-- Decrement copies when book is issued
-- ==========================================

CREATE TABLE book_det (
    bid INT PRIMARY KEY,
    btitle VARCHAR(100),
    copies INT
);

CREATE TABLE book_issue (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    bid INT,
    sid INT,
    btitle VARCHAR(100),
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_DecrementCopies
AFTER INSERT ON book_issue
FOR EACH ROW
BEGIN
    UPDATE book_det
    SET copies = copies - 1
    WHERE bid = NEW.bid;
END //

DELIMITER ;

-- ==========================================
-- PART B: VIEW QUESTIONS
-- ==========================================

-- Setup tables for views
CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(5,2)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT
);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

-- Sample data
INSERT INTO salesman VALUES (1, 'John', 'New York', 0.15);
INSERT INTO salesman VALUES (2, 'Mike', 'Los Angeles', 0.12);
INSERT INTO salesman VALUES (3, 'Sarah', 'New York', 0.14);
INSERT INTO salesman VALUES (4, 'Tom', 'Chicago', 0.11);

INSERT INTO customer VALUES (1, 'Alice', 'New York', 1, 1);
INSERT INTO customer VALUES (2, 'Bob', 'Boston', 2, 2);
INSERT INTO customer VALUES (3, 'Carol', 'New York', 1, 1);
INSERT INTO customer VALUES (4, 'Dave', 'Chicago', 3, 3);
INSERT INTO customer VALUES (5, 'Eve', 'Miami', 2, 4);

-- ==========================================
-- Question 8: View - New York Salespeople
-- ==========================================

CREATE VIEW vw_NewYorkSalesmen AS
SELECT * FROM salesman
WHERE city = 'New York';

-- ==========================================
-- Question 9: View - Salesman Details
-- ==========================================

CREATE VIEW vw_SalesmanDetails AS
SELECT salesman_id, name, city
FROM salesman;

-- ==========================================
-- Question 10: View - Customer Grade Count
-- ==========================================

CREATE VIEW vw_CustomerGradeCount AS
SELECT grade, COUNT(*) AS customer_count
FROM customer
GROUP BY grade;

-- ==========================================
-- Question 11: View - Order Statistics by Date
-- ==========================================

CREATE VIEW vw_OrderStatsByDate AS
SELECT 
    ord_date,
    COUNT(DISTINCT customer_id) AS unique_customers,
    AVG(purch_amt) AS avg_purchase,
    SUM(purch_amt) AS total_purchase
FROM orders
GROUP BY ord_date;

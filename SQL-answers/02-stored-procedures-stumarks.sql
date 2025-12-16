-- ==========================================
-- PRACTICAL 02: Stored Procedures (stuMarks) - ANSWERS
-- Database: stuMarks
-- ==========================================

-- ==========================================
-- Question 1: Create Database
-- ==========================================

CREATE DATABASE IF NOT EXISTS stuMarks;
USE stuMarks;

-- ==========================================
-- Question 2: Create Table 'student'
-- ==========================================

CREATE TABLE student (
    RegNo VARCHAR(10) PRIMARY KEY,
    stuName VARCHAR(50),
    DoB DATE,
    Gender VARCHAR(10)
);

-- ==========================================
-- Question 3: Insert Student Data
-- ==========================================

INSERT INTO student VALUES ('ICT001', 'K.M.P.Kumara', '1996-12-25', 'Male');
INSERT INTO student VALUES ('ICT002', 'G.L.Y.Lenagala', '1996-08-10', 'Female');
INSERT INTO student VALUES ('ICT003', 'B.A.Jayaranga', '1996-05-23', 'Male');
INSERT INTO student VALUES ('ICT004', 'B.L.D.Lakmal', '1996-06-15', 'Male');
INSERT INTO student VALUES ('ICT005', 'K.N.R.Nipuni', '1996-02-18', 'Female');

-- ==========================================
-- Question 4: Create Table 'marks'
-- ==========================================

CREATE TABLE marks (
    RegNo VARCHAR(10),
    ICT INT,
    Maths INT,
    Physics INT,
    FOREIGN KEY (RegNo) REFERENCES student(RegNo)
);

-- ==========================================
-- Question 5: Insert Marks Data
-- ==========================================

INSERT INTO marks VALUES ('ICT001', 80, 70, 90);
INSERT INTO marks VALUES ('ICT002', 45, 35, 55);
INSERT INTO marks VALUES ('ICT003', 25, 35, 15);
INSERT INTO marks VALUES ('ICT004', 65, 80, 50);
INSERT INTO marks VALUES ('ICT005', 15, 25, 5);

-- ==========================================
-- Question 6: Procedure (All Marks)
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetAllMarks()
BEGIN
    SELECT * FROM marks;
END //

DELIMITER ;

-- Call: CALL GetAllMarks();

-- ==========================================
-- Question 7: Procedure (Average)
-- Output: stuName, Average
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetAverageMarks()
BEGIN
    SELECT 
        s.stuName,
        (m.ICT + m.Maths + m.Physics) / 3 AS Average
    FROM student s
    INNER JOIN marks m ON s.RegNo = m.RegNo;
END //

DELIMITER ;

-- Call: CALL GetAverageMarks();

-- ==========================================
-- Question 8: Show Stored Procedure Structure
-- ==========================================

SHOW PROCEDURE STATUS WHERE Db = 'stuMarks';

-- Or to see the code:
-- SHOW CREATE PROCEDURE GetAllMarks;

-- ==========================================
-- Question 9: Procedure (Male Student Count)
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetMaleStudentCount()
BEGIN
    SELECT COUNT(*) AS MaleCount
    FROM student
    WHERE Gender = 'Male';
END //

DELIMITER ;

-- Call: CALL GetMaleStudentCount();

-- ==========================================
-- Question 10: Procedure (Details by RegNo)
-- Output: stuName, DOB, Gender
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetStudentDetails(IN p_RegNo VARCHAR(10))
BEGIN
    SELECT stuName, DoB, Gender
    FROM student
    WHERE RegNo = p_RegNo;
END //

DELIMITER ;

-- Call: CALL GetStudentDetails('ICT001');

-- ==========================================
-- Question 11: Procedure (Age Calculation)
-- Output: @age
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetStudentAge(IN p_RegNo VARCHAR(10), OUT p_Age INT)
BEGIN
    SELECT TIMESTAMPDIFF(YEAR, DoB, CURDATE()) INTO p_Age
    FROM student
    WHERE RegNo = p_RegNo;
END //

DELIMITER ;

-- Call:
-- CALL GetStudentAge('ICT001', @age);
-- SELECT @age;

-- ==========================================
-- Question 12: Procedure (Grades)
-- Logic: A>=75, B>=60, C>=40, D>=20, else F
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetStudentGrade(IN p_RegNo VARCHAR(10), OUT p_Grade CHAR(1))
BEGIN
    DECLARE avg_marks DECIMAL(10,2);
    
    SELECT (ICT + Maths + Physics) / 3 INTO avg_marks
    FROM marks
    WHERE RegNo = p_RegNo;
    
    IF avg_marks >= 75 THEN
        SET p_Grade = 'A';
    ELSEIF avg_marks >= 60 THEN
        SET p_Grade = 'B';
    ELSEIF avg_marks >= 40 THEN
        SET p_Grade = 'C';
    ELSEIF avg_marks >= 20 THEN
        SET p_Grade = 'D';
    ELSE
        SET p_Grade = 'F';
    END IF;
END //

DELIMITER ;

-- Call:
-- CALL GetStudentGrade('ICT001', @grade);
-- SELECT @grade;
-- Expected: 'A' for ICT001 (avg = 80)

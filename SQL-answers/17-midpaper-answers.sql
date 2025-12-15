-- ==========================================
-- MID EXAM PRACTICAL: IT Institute Database
-- Total Marks: 20
-- ==========================================

-- ==========================================
-- DATABASE SETUP (Suggested Schema)
-- ==========================================

CREATE DATABASE IF NOT EXISTS itinstitute;
USE itinstitute;

-- Students Table
CREATE TABLE students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

-- Courses Table
CREATE TABLE courses (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(100) NOT NULL,
    DurationMonths INT,
    Fee DECIMAL(10,2)
);

-- Enrollments Table
CREATE TABLE enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES courses(CourseID)
);

-- ==========================================
-- SAMPLE DATA
-- ==========================================

INSERT INTO students (FirstName, LastName) VALUES
('Kamal', 'Perera'),
('Nimal', 'Silva'),
('Sunil', 'Fernando'),
('Amara', 'Jayawardena'),
('Kumari', 'Rathnayake');

INSERT INTO courses (CourseName, DurationMonths, Fee) VALUES
('Web Development', 6, 50000.00),
('Mobile App Development', 8, 75000.00),
('Data Science', 12, 120000.00),
('Cyber Security', 10, 100000.00),
('Cloud Computing', 6, 60000.00);

INSERT INTO enrollments (StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, '2024-01-15'),
(1, 2, '2024-02-20'),
(2, 1, '2024-01-20'),
(2, 3, '2024-03-10'),
(2, 4, '2024-04-05'),
(3, 2, '2024-02-15'),
(3, 5, '2024-05-01'),
(4, 4, '2024-03-20'),
(4, 3, '2024-04-15'),
(5, 1, '2024-01-25');

-- ==========================================
-- Question 1: CREATE VIEW - StudentCourseDetails
-- ==========================================


CREATE VIEW StudentCourseDetails AS
SELECT 
    CONCAT(s.FirstName, ' ', s.LastName) AS `Full Name`,
    c.CourseName,
    c.Fee,
    ce.EnrollmentDate
FROM students s
JOIN enrollments ce ON s.StudentID = ce.StudentID
JOIN courses c ON ce.CourseID = c.CourseID
ORDER BY s.StudentID;

-- Test the view
SELECT * FROM StudentCourseDetails;

-- ==========================================
-- Question 2: CREATE FUNCTION - GetStudentCourseCount
-- ==========================================


DELIMITER //

CREATE FUNCTION GetStudentCourseCount(stuID INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE noCourses INT;
    
    SELECT COUNT(CourseID) INTO noCourses 
    FROM enrollments
    WHERE StudentID = stuID;
    
    RETURN noCourses;
END //

DELIMITER ;

-- Test the function with StudentID = 2
SELECT GetStudentCourseCount(2) AS TotalCourses;
-- Expected output: 3 (Student 2 - Nimal Silva enrolled in 3 courses)

-- ==========================================
-- Question 3: CREATE PROCEDURE - GetStudentCourses
-- ==========================================


DELIMITER //

CREATE PROCEDURE GetStudentCourses(IN stuID INT)
BEGIN
    SELECT 
        CONCAT(s.FirstName, ' ', s.LastName) AS fullname, 
        c.CourseName, 
        c.DurationMonths, 
        c.Fee, 
        ce.EnrollmentDate
    FROM students s
    JOIN enrollments ce ON s.StudentID = ce.StudentID
    JOIN courses c ON ce.CourseID = c.CourseID
    WHERE s.StudentID = stuID;
END //

DELIMITER ;

-- Test the procedure with StudentID = 3
CALL GetStudentCourses(3);
-- Expected: Sunil Fernando's courses (Mobile App Dev, Cloud Computing)

-- ==========================================
-- Question 4: CREATE PROCEDURE - GetCourseEnrollmentCount
-- ==========================================


DELIMITER //

CREATE PROCEDURE GetCourseEnrollmentCount(
    IN cID INT, 
    OUT totstu INT
)
BEGIN
    SELECT COUNT(*) INTO totstu 
    FROM enrollments
    WHERE CourseID = cID;
END //

DELIMITER ;

-- Test the procedure with CourseID = 4
CALL GetCourseEnrollmentCount(4, @count);
SELECT @count AS TotalStudents;
-- Expected output: 2 (Cyber Security has 2 students)

-- ==========================================
-- Question 5: CREATE COMPOSITE INDEX
-- ==========================================


CREATE INDEX idx_stuCourse ON enrollments(StudentID, CourseID);

-- Show indexes
SHOW INDEXES FROM enrollments;

-- Explain query to verify index usage
EXPLAIN SELECT *  
FROM Enrollments  
WHERE StudentID = 1;

-- Expected EXPLAIN output will show:
-- type: ref (using index)
-- possible_keys: idx_stuCourse
-- key: idx_stuCourse

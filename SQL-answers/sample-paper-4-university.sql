-- ==========================================
-- SAMPLE PAPER 4: UniversityDB - ANSWERS
-- Duration: 2 Hours | Total: 100 Marks
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    enrollment_date DATE,
    department VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE,
    course_name VARCHAR(100),
    credits INT,
    department VARCHAR(50),
    max_enrollment INT DEFAULT 50
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(2),
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE lecturers (
    lecturer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(12,2)
);

CREATE TABLE course_assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    lecturer_id INT,
    semester VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id)
);

CREATE TABLE grade_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    old_grade CHAR(2),
    new_grade CHAR(2),
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO students (first_name, last_name, email, date_of_birth, enrollment_date, department) VALUES
('Kamal', 'Perera', 'kamal@uni.edu', '2000-05-15', '2022-01-10', 'Computer Science'),
('Nimal', 'Silva', 'nimal@uni.edu', '2001-08-20', '2022-01-10', 'Computer Science'),
('Kumari', 'Fernando', 'kumari@uni.edu', '2000-12-03', '2022-01-10', 'Mathematics'),
('Amal', 'Jayawardena', 'amal@uni.edu', '2001-03-25', '2023-01-10', 'Physics');

INSERT INTO courses (course_code, course_name, credits, department, max_enrollment) VALUES
('CS101', 'Introduction to Programming', 3, 'Computer Science', 50),
('CS201', 'Data Structures', 4, 'Computer Science', 40),
('CS301', 'Database Systems', 3, 'Computer Science', 35),
('MA101', 'Calculus I', 3, 'Mathematics', 60),
('PH101', 'Physics I', 4, 'Physics', 50);

INSERT INTO lecturers (first_name, last_name, email, department, salary) VALUES
('Dr. Sunil', 'Bandara', 'sunil@uni.edu', 'Computer Science', 150000),
('Dr. Nalini', 'Wickrama', 'nalini@uni.edu', 'Mathematics', 140000),
('Dr. Ranjan', 'Peris', 'ranjan@uni.edu', 'Physics', 145000);

INSERT INTO enrollments (student_id, course_id, semester, grade, enrollment_date) VALUES
(1, 1, '2022-Sem1', 'A', '2022-01-15'),
(1, 2, '2022-Sem2', 'B+', '2022-06-15'),
(1, 3, '2023-Sem1', 'A', '2023-01-15'),
(2, 1, '2022-Sem1', 'B', '2022-01-15'),
(2, 2, '2022-Sem2', 'C+', '2022-06-15'),
(2, 3, '2023-Sem1', 'B+', '2023-01-15'),
(3, 4, '2022-Sem1', 'A', '2022-01-15'),
(3, 1, '2022-Sem2', 'B', '2022-06-15'),
(4, 5, '2023-Sem1', 'C', '2023-01-15'),
(4, 4, '2023-Sem1', 'F', '2023-01-15');

-- ==========================================
-- SECTION A: VIEWS (15 Marks)
-- ==========================================

-- Question 1 (8 Marks): vw_StudentTranscript
CREATE VIEW vw_StudentTranscript AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    c.course_code,
    c.course_name,
    c.credits,
    e.grade,
    e.semester
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.student_id, e.semester;

-- Test:
SELECT * FROM vw_StudentTranscript;


-- Question 2 (7 Marks): vw_CourseStatistics
CREATE VIEW vw_CourseStatistics AS
SELECT 
    c.course_code,
    c.course_name,
    COUNT(e.enrollment_id) AS total_enrolled,
    AVG(
        CASE e.grade
            WHEN 'A' THEN 4.0
            WHEN 'B+' THEN 3.5
            WHEN 'B' THEN 3.0
            WHEN 'C+' THEN 2.5
            WHEN 'C' THEN 2.0
            WHEN 'D' THEN 1.0
            WHEN 'F' THEN 0.0
            ELSE NULL
        END
    ) AS average_grade_point,
    ROUND(
        (SUM(CASE WHEN e.grade != 'F' AND e.grade IS NOT NULL THEN 1 ELSE 0 END) * 100.0) 
        / NULLIF(COUNT(CASE WHEN e.grade IS NOT NULL THEN 1 END), 0), 2
    ) AS pass_rate
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_name;

-- Test:
SELECT * FROM vw_CourseStatistics;

-- ==========================================
-- SECTION B: USER-DEFINED FUNCTIONS (15 Marks)
-- ==========================================

-- Question 3 (7 Marks): fn_CalculateGPA
DELIMITER //

CREATE FUNCTION fn_CalculateGPA(p_student_id INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_gpa DECIMAL(3,2);
    
    SELECT 
        COALESCE(
            SUM(c.credits * 
                CASE e.grade
                    WHEN 'A' THEN 4.0
                    WHEN 'B+' THEN 3.5
                    WHEN 'B' THEN 3.0
                    WHEN 'C+' THEN 2.5
                    WHEN 'C' THEN 2.0
                    WHEN 'D' THEN 1.0
                    WHEN 'F' THEN 0.0
                    ELSE 0
                END
            ) / NULLIF(SUM(c.credits), 0),
            0.00
        ) INTO v_gpa
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    WHERE e.student_id = p_student_id AND e.grade IS NOT NULL;
    
    RETURN v_gpa;
END //

DELIMITER ;

-- Test:
SELECT student_id, CONCAT(first_name, ' ', last_name) AS name, 
       fn_CalculateGPA(student_id) AS gpa
FROM students;


-- Question 4 (8 Marks): fn_GetStudentAge
DELIMITER //

CREATE FUNCTION fn_GetStudentAge(p_student_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_dob DATE;
    DECLARE v_age INT;
    
    SELECT date_of_birth INTO v_dob
    FROM students
    WHERE student_id = p_student_id;
    
    IF v_dob IS NULL THEN
        RETURN -1;
    END IF;
    
    SET v_age = TIMESTAMPDIFF(YEAR, v_dob, CURDATE());
    RETURN v_age;
END //

DELIMITER ;

-- Test:
SELECT student_id, first_name, fn_GetStudentAge(student_id) AS age FROM students;

-- ==========================================
-- SECTION C: STORED PROCEDURES (20 Marks)
-- ==========================================

-- Question 5 (10 Marks): sp_EnrollStudent
DELIMITER //

CREATE PROCEDURE sp_EnrollStudent(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_semester VARCHAR(20),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_current_enrollment INT;
    DECLARE v_max_enrollment INT;
    DECLARE v_existing INT;
    
    -- Check max enrollment
    SELECT max_enrollment INTO v_max_enrollment
    FROM courses WHERE course_id = p_course_id;
    
    -- Check current enrollment count
    SELECT COUNT(*) INTO v_current_enrollment
    FROM enrollments
    WHERE course_id = p_course_id AND semester = p_semester;
    
    -- Check if already enrolled
    SELECT COUNT(*) INTO v_existing
    FROM enrollments
    WHERE student_id = p_student_id 
      AND course_id = p_course_id 
      AND semester = p_semester;
    
    IF v_max_enrollment IS NULL THEN
        SET p_result = 'ERROR: Course not found';
    ELSEIF v_existing > 0 THEN
        SET p_result = 'ERROR: Student already enrolled in this course/semester';
    ELSEIF v_current_enrollment >= v_max_enrollment THEN
        SET p_result = 'ERROR: Course enrollment limit reached';
    ELSE
        INSERT INTO enrollments (student_id, course_id, semester, grade, enrollment_date)
        VALUES (p_student_id, p_course_id, p_semester, NULL, CURDATE());
        SET p_result = 'SUCCESS: Student enrolled';
    END IF;
END //

DELIMITER ;

-- Test:
CALL sp_EnrollStudent(1, 4, '2024-Sem1', @result);
SELECT @result;


-- Question 6 (10 Marks): sp_UpdateGrade
DELIMITER //

CREATE PROCEDURE sp_UpdateGrade(
    IN p_enrollment_id INT,
    IN p_new_grade CHAR(2),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_old_grade CHAR(2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Transaction failed';
    END;
    
    -- Validate grade
    IF p_new_grade NOT IN ('A', 'B+', 'B', 'C+', 'C', 'D', 'F') THEN
        SET p_result = 'ERROR: Invalid grade. Must be A, B+, B, C+, C, D, or F';
    ELSE
        START TRANSACTION;
        
        -- Get old grade
        SELECT grade INTO v_old_grade
        FROM enrollments WHERE enrollment_id = p_enrollment_id;
        
        -- Update grade
        UPDATE enrollments 
        SET grade = p_new_grade 
        WHERE enrollment_id = p_enrollment_id;
        
        -- Log change
        INSERT INTO grade_history (enrollment_id, old_grade, new_grade, changed_by)
        VALUES (p_enrollment_id, v_old_grade, p_new_grade, CURRENT_USER());
        
        COMMIT;
        SET p_result = 'SUCCESS: Grade updated';
    END IF;
END //

DELIMITER ;

-- Test:
CALL sp_UpdateGrade(1, 'A', @result);
SELECT @result;
SELECT * FROM grade_history;

-- ==========================================
-- SECTION D: TRIGGERS (20 Marks)
-- ==========================================

-- Question 7 (10 Marks): trg_LogGradeChange
DELIMITER //

CREATE TRIGGER trg_LogGradeChange
AFTER UPDATE ON enrollments
FOR EACH ROW
BEGIN
    IF OLD.grade IS DISTINCT FROM NEW.grade THEN
        INSERT INTO grade_history (enrollment_id, old_grade, new_grade, changed_by)
        VALUES (NEW.enrollment_id, OLD.grade, NEW.grade, CURRENT_USER());
    END IF;
END //

DELIMITER ;

-- Alternative for MySQL versions without IS DISTINCT FROM:
/*
CREATE TRIGGER trg_LogGradeChange
AFTER UPDATE ON enrollments
FOR EACH ROW
BEGIN
    IF (OLD.grade <> NEW.grade) OR (OLD.grade IS NULL AND NEW.grade IS NOT NULL) 
       OR (OLD.grade IS NOT NULL AND NEW.grade IS NULL) THEN
        INSERT INTO grade_history (enrollment_id, old_grade, new_grade, changed_by)
        VALUES (NEW.enrollment_id, OLD.grade, NEW.grade, CURRENT_USER());
    END IF;
END //
*/


-- Question 8 (10 Marks): trg_CheckEnrollmentLimit
DELIMITER //

CREATE TRIGGER trg_CheckEnrollmentLimit
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    DECLARE v_current INT;
    DECLARE v_max INT;
    
    SELECT max_enrollment INTO v_max
    FROM courses WHERE course_id = NEW.course_id;
    
    SELECT COUNT(*) INTO v_current
    FROM enrollments
    WHERE course_id = NEW.course_id AND semester = NEW.semester;
    
    IF v_current >= v_max THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Course enrollment limit reached';
    END IF;
END //

DELIMITER ;

-- ==========================================
-- SECTION E: EVENTS (10 Marks)
-- ==========================================

-- Enable event scheduler
SET GLOBAL event_scheduler = ON;

-- Question 9 (5 Marks): evt_NotifyLowGPA
DELIMITER //

CREATE EVENT evt_NotifyLowGPA
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 8 HOUR)
DO
BEGIN
    INSERT INTO notifications (student_id, message)
    SELECT s.student_id, 'Academic warning: Your GPA is below minimum requirement'
    FROM students s
    WHERE fn_CalculateGPA(s.student_id) < 2.0
      AND s.status = 'Active';
END //

DELIMITER ;


-- Question 10 (5 Marks): evt_ArchiveOldEnrollments
DELIMITER //

CREATE EVENT evt_ArchiveOldEnrollments
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-01-01 00:00:00'
ON COMPLETION PRESERVE
DO
BEGIN
    DELETE FROM enrollments
    WHERE enrollment_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
END //

DELIMITER ;

-- ==========================================
-- SECTION F: TRANSACTIONS & ERROR HANDLING (10 Marks)
-- ==========================================

-- Question 11 (10 Marks): sp_TransferCredits
DELIMITER //

CREATE PROCEDURE sp_TransferCredits(
    IN p_from_student_id INT,
    IN p_to_student_id INT,
    IN p_course_id INT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_enrollment_id INT;
    DECLARE v_grade CHAR(2);
    DECLARE v_semester VARCHAR(20);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Transaction failed, rolled back';
    END;
    
    START TRANSACTION;
    
    -- Find the enrollment to transfer
    SELECT enrollment_id, grade, semester 
    INTO v_enrollment_id, v_grade, v_semester
    FROM enrollments
    WHERE student_id = p_from_student_id AND course_id = p_course_id
    LIMIT 1;
    
    IF v_enrollment_id IS NULL THEN
        ROLLBACK;
        SET p_result = 'ERROR: Enrollment not found for source student';
    ELSE
        SAVEPOINT before_transfer;
        
        -- Delete from source student
        DELETE FROM enrollments WHERE enrollment_id = v_enrollment_id;
        
        -- Insert for destination student
        INSERT INTO enrollments (student_id, course_id, semester, grade, enrollment_date)
        VALUES (p_to_student_id, p_course_id, v_semester, v_grade, CURDATE());
        
        COMMIT;
        SET p_result = 'SUCCESS: Credits transferred';
    END IF;
END //

DELIMITER ;

-- Test:
CALL sp_TransferCredits(1, 2, 3, @result);
SELECT @result;

-- ==========================================
-- SECTION G: SECURITY (10 Marks)
-- ==========================================

-- Question 12 (5 Marks): Create users and grant privileges
-- Create users
CREATE USER 'registrar'@'localhost' IDENTIFIED BY 'RegistrarPass123!';
CREATE USER 'lecturer'@'%' IDENTIFIED BY 'LecturerPass123!';

-- Grant registrar privileges
GRANT SELECT, INSERT, UPDATE ON UniversityDB.students TO 'registrar'@'localhost';
GRANT SELECT, INSERT, UPDATE ON UniversityDB.enrollments TO 'registrar'@'localhost';

-- Grant lecturer privileges
GRANT SELECT ON UniversityDB.enrollments TO 'lecturer'@'%';
GRANT UPDATE (grade) ON UniversityDB.enrollments TO 'lecturer'@'%';

FLUSH PRIVILEGES;


-- Question 13 (5 Marks): Secure view and explanation

-- a) Create secure view
CREATE VIEW vw_PublicStudentInfo AS
SELECT 
    student_id,
    first_name,
    last_name,
    department,
    status
FROM students;
-- Hides: email, date_of_birth

-- b) Explanation:
/*
Views can be used for security by:

1. Hiding sensitive columns: The vw_PublicStudentInfo view shows only 
   non-sensitive columns. Users granted SELECT on this view cannot see 
   email or date_of_birth, even though these exist in the base table.

2. Row-level security: Views can include WHERE clauses to restrict 
   which rows users can see. For example:
   
   CREATE VIEW vw_MyDepartmentStudents AS
   SELECT * FROM students WHERE department = 'Computer Science';
   
   This allows department heads to see only their department's students.

3. Granting view access instead of table access:
   GRANT SELECT ON vw_PublicStudentInfo TO 'public_user'@'localhost';
   
   The user can query the view but cannot access the underlying 
   students table directly.
*/

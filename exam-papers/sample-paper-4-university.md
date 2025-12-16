# 📝 ADBMS Final Exam - Sample Paper 4

> **Duration:** 2 Hours  
> **Total Marks:** 100  
> **Database:** UniversityDB

---

## 📋 Database Schema

```sql
CREATE DATABASE UniversityDB;
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
```

---

## SECTION A: VIEWS (15 Marks)

### Question 1 (8 Marks)
Create a view named `vw_StudentTranscript` that displays:
- Student ID
- Full name (first_name + ' ' + last_name)
- Course code
- Course name
- Credits
- Grade
- Semester
- Order by student_id, semester

```sql
-- Your answer here

```

---

### Question 2 (7 Marks)
Create a view named `vw_CourseStatistics` that shows for each course:
- course_code
- course_name
- Total enrolled students
- Average grade (convert A=4, B=3, C=2, D=1, F=0)
- Pass rate (percentage of students with grade != 'F')

```sql
-- Your answer here

```

---

## SECTION B: USER-DEFINED FUNCTIONS (15 Marks)

### Question 3 (7 Marks)
Create a function `fn_CalculateGPA` that:
- Accepts student_id as parameter
- Calculates GPA using: (Sum of credits × grade_point) / Total credits
- Grade points: A=4.0, B+=3.5, B=3.0, C+=2.5, C=2.0, D=1.0, F=0
- Returns GPA as DECIMAL(3,2)

```sql
-- Your answer here

```

---

### Question 4 (8 Marks)
Create a function `fn_GetStudentAge` that:
- Accepts student_id as parameter
- Returns the student's current age in years
- Returns -1 if student not found

```sql
-- Your answer here

```

---

## SECTION C: STORED PROCEDURES (20 Marks)

### Question 5 (10 Marks)
Create a stored procedure `sp_EnrollStudent` that:
- Accepts: student_id (IN), course_id (IN), semester (IN), result (OUT)
- Checks if course has available seats
- Checks if student is not already enrolled in same course/semester
- If valid, creates enrollment with NULL grade
- Sets result to 'SUCCESS' or appropriate error message

```sql
-- Your answer here

```

---

### Question 6 (10 Marks)
Create a stored procedure `sp_UpdateGrade` that:
- Accepts: enrollment_id (IN), new_grade (IN)
- Validates grade is one of: A, B+, B, C+, C, D, F
- Updates the grade in enrollments table
- Logs the change in grade_history table
- Uses transaction to ensure both operations succeed

```sql
-- Your answer here

```

---

## SECTION D: TRIGGERS (20 Marks)

### Question 7 (10 Marks)
Create a trigger `trg_LogGradeChange` that:
- Fires AFTER UPDATE on enrollments table
- Only fires when grade actually changes
- Records old_grade, new_grade, and CURRENT_USER() in grade_history

```sql
-- Your answer here

```

---

### Question 8 (10 Marks)
Create a trigger `trg_CheckEnrollmentLimit` that:
- Fires BEFORE INSERT on enrollments
- Checks if course has reached max_enrollment
- If limit reached, raises error: "Course enrollment limit reached"

```sql
-- Your answer here

```

---

## SECTION E: EVENTS (10 Marks)

### Question 9 (5 Marks)
Create an event `evt_NotifyLowGPA` that:
- Runs every day at 8:00 AM
- Inserts notification for students with GPA < 2.0
- Message: "Academic warning: Your GPA is below minimum requirement"

```sql
-- Your answer here

```

---

### Question 10 (5 Marks)
Create an event `evt_ArchiveOldEnrollments` that:
- Runs on the first day of every month
- Deletes enrollments older than 5 years
- Keeps event definition after execution

```sql
-- Your answer here

```

---

## SECTION F: TRANSACTIONS & ERROR HANDLING (10 Marks)

### Question 11 (10 Marks)
Create a stored procedure `sp_TransferCredits` that:
- Accepts: from_student_id, to_student_id, course_id
- Transfers an enrollment from one student to another
- Uses SAVEPOINT to handle partial failures
- Includes EXIT handler for SQLEXCEPTION
- Returns appropriate success/error message

```sql
-- Your answer here

```

---

## SECTION G: SECURITY (10 Marks)

### Question 12 (5 Marks)
Write SQL commands to:
1. Create a user 'registrar'@'localhost'
2. Create a user 'lecturer'@'%'
3. Grant registrar: SELECT, INSERT, UPDATE on students and enrollments
4. Grant lecturer: SELECT on enrollments, UPDATE (grade only) on enrollments

```sql
-- Your answer here

```

---

### Question 13 (5 Marks)
a) Create a secure view `vw_PublicStudentInfo` that hides sensitive data (email, date_of_birth)
b) Explain how views can be used for security with an example

```sql
-- Your answer here (a):


-- Your answer here (b):

```

---

## ✅ Marking Scheme

| Section | Topic | Marks |
|---------|-------|-------|
| A | Views (2 questions) | 15 |
| B | Functions (2 questions) | 15 |
| C | Procedures (2 questions) | 20 |
| D | Triggers (2 questions) | 20 |
| E | Events (2 questions) | 10 |
| F | Transactions & Error Handling (1 question) | 10 |
| G | Security (2 questions) | 10 |
| **Total** | **13 Questions** | **100** |

# Mid Exam Practical: IT Institute Database

> **Category:** Mid Exam Paper  
> **Total Marks:** 20  
> **Database:** itinstitute  
> **Topics:** Views, UDFs, Stored Procedures, Indexes

---

## 📋 Database Schema (Suggested)

Based on the exam questions, the following tables are required:

### Table: `students`
| Field | Type | Description |
|-------|------|-------------|
| StudentID | INT | Primary Key |
| FirstName | VARCHAR(50) | Student's first name |
| LastName | VARCHAR(50) | Student's last name |

### Table: `courses`
| Field | Type | Description |
|-------|------|-------------|
| CourseID | INT | Primary Key |
| CourseName | VARCHAR(100) | Name of the course |
| DurationMonths | INT | Course duration in months |
| Fee | DECIMAL(10,2) | Course fee |

### Table: `enrollments`
| Field | Type | Description |
|-------|------|-------------|
| EnrollmentID | INT | Primary Key (Auto Increment) |
| StudentID | INT | Foreign Key → students |
| CourseID | INT | Foreign Key → courses |
| EnrollmentDate | DATE | Date of enrollment |

---

## 🎯 Exam Questions

### Question 1: Create View (StudentCourseDetails)
**Task:** Create a view named `StudentCourseDetails` that displays:
- Student's full name (FirstName + LastName)
- Course name
- Course fee
- Enrollment date

**A.** Copy and paste the SQL script.
**B.** Copy and paste the output of the StudentCourseDetails view.

```sql
-- Your answer here

```

---

### Question 2: Create User-Defined Function (GetStudentCourseCount)
**Task:** Create a user-defined function named `GetStudentCourseCount` that:
- Accepts a StudentID as input
- Returns the number of courses that the student has enrolled in

**A.** Copy and paste the SQL script.
**B.** Use the studentID as **2** and copy and paste the output of the GetStudentCourseCount function as TotalCourses.

```sql
-- Your answer here

```

---

### Question 3: Create Stored Procedure (GetStudentCourses)
**Task:** Create a stored procedure named `GetStudentCourses` that:
- Accepts a StudentID as an IN parameter
- Returns the following information for the given student:
  - Student full name (FirstName + LastName)
  - Course name
  - Course Duration
  - Course fee
  - Enrollment date

**A.** Copy and paste the SQL script.
**B.** Use the studentID as **3** and copy and paste the output of the GetStudentCourses stored procedure.

```sql
-- Your answer here

```

---

### Question 4: Create Stored Procedure with OUT Parameter (GetCourseEnrollmentCount)
**Task:** Create a stored procedure named `GetCourseEnrollmentCount` that:
- Accepts a CourseID as an IN parameter
- Returns the total number of students enrolled in that course as an **OUT parameter**

**A.** Copy and paste the SQL script.
**B.** Use the courseID as **4** and copy and paste the output of the GetCourseEnrollmentCount stored procedure.

```sql
-- Your answer here

```

---

### Question 5: Create Composite Index
**Task:** The IT institution has a lot of students and courses. To improve query performance, they want to optimize searches. Create a **composite index** on the Enrollments table for StudentID and CourseID, because queries often filter by both columns to find which courses a student is enrolled in.

**A.** Copy and paste the SQL script.
**B.** Run the following SQL query and copy and paste the output:
```sql
EXPLAIN SELECT *
FROM Enrollments
WHERE StudentID = 1;
```

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Q1: View - StudentCourseDetails
- [ ] Q2: Function - GetStudentCourseCount
- [ ] Q3: Procedure - GetStudentCourses (IN parameter)
- [ ] Q4: Procedure - GetCourseEnrollmentCount (IN + OUT parameters)
- [ ] Q5: Composite Index on Enrollments

# Practical: Complex Schema & Stored Procedures (myStoredDB)

> **Category:** Lab/Practical Instructions  
> **Topics:** Complex Schema Design, Stored Procedures, Error Handling, IN/OUT Parameters

---

## 📋 Database Schema (myStoredDB)

### Schema Rules
- **Employee Table:** Has fields: email, phone, name (E_fname, E_lname)
- **Login Table:** username, password. Employee has one login, specific login belongs to one employee. Username is taken from first name.
- **Department Table:** name, description. Employee has one department; department has many employees. DID is auto increment.
- **Role Table:** name, description. Employee has one role; one role can be assigned to many employees. RID is auto increment.

---

### Table: `Employee`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `EID` | varchar(10) | Employee ID (Primary Key) |
| `E_fname` | varchar(50) | First Name |
| `E_lname` | varchar(50) | Last Name |
| `phone` | varchar(15) | Phone Number |
| `email` | varchar(100) | Email Address |
| `Age` | int | Employee Age |
| `DID` | int | Department ID (Foreign Key) |
| `RID` | int | Role ID (Foreign Key) |
| `UID` | int | Login ID (Foreign Key) |

**Sample Data:**
| EID | E_fname | E_lname | phone | email | Age |
|-----|---------|---------|-------|-------|-----|
| E001 | Sarath | Weerasinghe | 0715267893 | abcsarath@gmail.com | 22 |
| E002 | Kamal | Nadhun | 0778945613 | abckamal@gmail.com | 58 |
| E003 | Amali | Sadamini | 0725468134 | abcamali@gmail.com | 45 |
| E004 | Shani | Arosha | 0707775552 | abcshani@gmail.com | 25 |
| E005 | Nimesha | Sewwandi | 0768882225 | abcnimesha@gmail.com | 30 |

---

### Table: `Login`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `UID` | int | User ID (Primary Key) |
| `Username` | varchar(50) | Username |
| `Password` | varchar(50) | Password |

**Sample Data:**
| UID | Username | Password |
|-----|----------|----------|
| 001 | sarath | s12 |
| 002 | kamal | k12 |
| 003 | amali | a12 |
| 004 | shani | s21 |
| 005 | nimesha | n12 |

---

### Table: `Department`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `DID` | int | Department ID (Primary Key, Auto Increment) |
| `name` | varchar(50) | Department Name |
| `description` | varchar(100) | Department Description |

**Sample Data:**
| DID | name | description |
|-----|------|-------------|
| 1 | Science | Science dep |
| 2 | IT | IT dep |
| 3 | Maths | Maths dep |
| 4 | ET | ET dep |
| 5 | BST | BST dep |

---

### Table: `Role`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `RID` | int | Role ID (Primary Key, Auto Increment) |
| `name` | varchar(50) | Role Name |
| `description` | varchar(100) | Role Description |

**Sample Data:**
| RID | name | description |
|-----|------|-------------|
| 1 | QA Engineer | Role 1 |
| 2 | SE Engineer | Role 2 |
| 3 | Project Manager | Role 3 |
| 4 | Business Analyst | Role 4 |
| 5 | Technical Consultant | Role 5 |

---

## 🎯 Practice Questions - Part A: Employee System

### Question 1: Create Database
**Task:** Create the database `myStoredDB` with all tables according to the schema.

```sql
-- Your answer here (Database)


-- Your answer here (Login table)


-- Your answer here (Department table)


-- Your answer here (Role table)


-- Your answer here (Employee table with foreign keys)

```

---

### Question 2: Insert All Data
**Task:** Insert sample data into all tables.

```sql
-- Your answer here

```

---

### Question 3: Get All Employees
**Task:** Create a stored procedure to get all details of all employees.

```sql
-- Your answer here

```

---

### Question 4: Get Employee by ID
**Task:** Create a stored procedure to get all details of an employee by giving employee id.

```sql
-- Your answer here

```

---

### Question 5: Get All Departments
**Task:** Create a stored procedure to get all details of all departments.

```sql
-- Your answer here

```

---

### Question 6: Get All Roles
**Task:** Create a stored procedure to get all details of all roles.

```sql
-- Your answer here

```

---

### Question 7: Get All Logins
**Task:** Create a stored procedure to get all details of all the login table.

```sql
-- Your answer here

```

---

### Question 8: Employees Age > 30
**Task:** Create a stored procedure to display all records of employee table whose ages are greater than 30.

```sql
-- Your answer here

```

---

### Question 9: usp_GetLastName
**Task:** Create a stored procedure that accepts employee ID and returns last name.

```sql
-- Your answer here

```

---

### Question 10: usp_GetFirstName
**Task:** Create a stored procedure that accepts employee ID and returns first name.

```sql
-- Your answer here

```

---

### Question 11: Get Department Name
**Task:** Create a stored procedure to get the department name of an employee when employee ID is given.

```sql
-- Your answer here

```

---

### Question 12: Get Role Name
**Task:** Create a stored procedure to get the name of the role of an employee when employee ID is given.

```sql
-- Your answer here

```

---

### Question 13: Count Employees by Department
**Task:** Given a department ID, create a stored procedure to count the number of employees for that department.

```sql
-- Your answer here

```

---

### Question 14: Get Login Details
**Task:** Create a stored procedure to get login details of a specific employee by giving employee ID.

```sql
-- Your answer here

```

---

## 📋 Table: `student_marks`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `stud_id` | int | Student ID (Primary Key) |
| `total_marks` | int | Total Marks |
| `grade` | varchar(5) | Grade |

**Sample Data:**
| stud_id | total_marks | grade |
|---------|-------------|-------|
| 1 | 450 | A |
| 2 | 380 | B |
| 3 | 290 | C |
| 4 | 420 | A |
| 5 | 350 | B |
| 6 | 270 | C |
| 7 | 490 | A |
| 8 | 310 | B |
| 9 | 250 | C |
| 10 | 400 | A |
| 11 | 280 | C |

---

## 🎯 Practice Questions - Part B: Student Marks

### Question 15: Create student_marks Table
**Task:** Create 'student_marks' table and insert provided sample data.

```sql
-- Your answer here

```

---

### Question 16: Get All studentMarks
**Task:** Create a stored procedure to get all data from 'student_marks'.

```sql
-- Your answer here

```

---

### Question 17: Fetch Student by ID
**Task:** Create a stored procedure to fetch student details by given student ID.

```sql
-- Your answer here

```

---

### Question 18: Calculate Average (OUT Parameter)
**Task:** Create a stored procedure to calculate average marks of all students and return as OUT field.

```sql
-- Your answer here

```

---

### Question 19: Count Below Average
**Task:** Create a stored procedure to find count of students having marks below the average.

```sql
-- Your answer here

```

---

### Question 20: Increment Function
**Task:** Create a function that takes an initial counter value and increments it with a given number.

```sql
-- Your answer here

```

---

### Question 21: spGetIsAboveAverage
**Task:** Create a stored procedure that returns Boolean if student marks are above average.
- Calculate AVG in local variable
- Compare with passed student ID marks
- Return 0 or 1

```sql
-- Your answer here

```

---

### Question 22: spGetStudentResult
**Task:** Create a stored procedure that:
- Inputs studentId
- Calls spGetIsAboveAverage
- Outputs PASS (1) or FAIL (0)

```sql
-- Your answer here

```

---

### Question 23: Student Class Procedure
**Task:** Create a procedure that takes studentId and returns class based on marks:

| Marks | Class |
|-------|-------|
| >= 400 | First Class |
| >= 300 and < 400 | Second Class |
| < 300 | Failed |

```sql
-- Your answer here

```

---

### Question 24: spInsertStudentDataExit (Error Handling - EXIT)
**Task:** Create a procedure to insert record with:
- **IN:** studentId, total_marks, grade
- **OUT:** rowCount
- Add Error Handler for Duplicate Key with **EXIT** action
- Call with existing ID and fetch rowCount

```sql
-- Your answer here

```

---

### Question 25: spInsertStudentDataContinue (Error Handling - CONTINUE)
**Task:** Re-create the procedure with **CONTINUE** action for error handler. Call with existing ID and fetch rowCount.

```sql
-- Your answer here

```

---

## ✅ Checklist - Part A
- [ ] Question 1: Create Database & Tables
- [ ] Question 2: Insert All Data
- [ ] Question 3: Get All Employees
- [ ] Question 4: Get Employee by ID
- [ ] Question 5: Get All Departments
- [ ] Question 6: Get All Roles
- [ ] Question 7: Get All Logins
- [ ] Question 8: Employees Age > 30
- [ ] Question 9: usp_GetLastName
- [ ] Question 10: usp_GetFirstName
- [ ] Question 11: Get Department Name
- [ ] Question 12: Get Role Name
- [ ] Question 13: Count Employees by Department
- [ ] Question 14: Get Login Details

## ✅ Checklist - Part B
- [ ] Question 15: Create student_marks Table
- [ ] Question 16: Get All studentMarks
- [ ] Question 17: Fetch Student by ID
- [ ] Question 18: Calculate Average (OUT)
- [ ] Question 19: Count Below Average
- [ ] Question 20: Increment Function
- [ ] Question 21: spGetIsAboveAverage
- [ ] Question 22: spGetStudentResult
- [ ] Question 23: Student Class Procedure
- [ ] Question 24: spInsertStudentDataExit
- [ ] Question 25: spInsertStudentDataContinue

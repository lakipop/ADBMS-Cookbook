# Practical Sheet 05: Stored Procedures (stuMarks)

> **Category:** Lab/Practical Instructions  
> **Topics:** Stored Procedures, Functions, Parameters, Age Calculation, Grade Logic

---

## 📋 Table Definitions

### Table: `student`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `RegNo` | varchar(10) | Registration Number (Primary Key) |
| `stuName` | varchar(50) | Student Name |
| `DoB` | date | Date of Birth |
| `Gender` | varchar(10) | Gender |

**Sample Data:**
| RegNo | stuName | DoB | Gender |
|-------|---------|-----|--------|
| ICT001 | K.M.P.Kumara | 1996/12/25 | Male |
| ICT002 | G.L.Y.Lenagala | 1996/08/10 | Female |
| ICT003 | B.A.Jayaranga | 1996/05/23 | Male |
| ICT004 | B.L.D.Lakmal | 1996/06/15 | Male |
| ICT005 | K.N.R.Nipuni | 1996/02/18 | Female |

---

### Table: `marks`

| Field | Data Type | Description |
|-------|-----------|-------------|
| `RegNo` | varchar(10) | Registration Number (Foreign Key) |
| `ICT` | int | ICT Marks |
| `Maths` | int | Mathematics Marks |
| `Physics` | int | Physics Marks |

**Sample Data:**
| RegNo | ICT | Maths | Physics |
|-------|-----|-------|---------|
| ICT001 | 80 | 70 | 90 |
| ICT002 | 45 | 35 | 55 |
| ICT003 | 25 | 35 | 15 |
| ICT004 | 65 | 80 | 50 |
| ICT005 | 15 | 25 | 5 |

---

## 🎯 Practice Questions

### Question 1: Create Database
**Task:** Create a sample database named `stuMarks`.

```sql
-- Your answer here

```

---

### Question 2: Create Table 'student'
**Task:** Create table `student` with fields RegNo, stuName, DoB, Gender. Use proper data types.

```sql
-- Your answer here

```

---

### Question 3: Insert Student Data
**Task:** Insert the sample data into the `student` table.

```sql
-- Your answer here

```

---

### Question 4: Create Table 'marks'
**Task:** Create table `marks` with fields RegNo, ICT, Maths, Physics. Use proper data types.

```sql
-- Your answer here

```

---

### Question 5: Insert Marks Data
**Task:** Insert the sample data into the `marks` table.

```sql
-- Your answer here

```

---

### Question 6: Procedure (All Marks)
**Task:** Write a stored procedure to get all marks details.

```sql
-- Your answer here

```

---

### Question 7: Procedure (Average)
**Task:** Create a procedure to get average marks.

**Expected Output Format:** `stuName, Average` (e.g., K.M.P.Kumara, 80.0000)

```sql
-- Your answer here

```

---

### Question 8: Show Structure
**Task:** Show stored procedure structure where "stuMarks" database.

```sql
-- Your answer here

```

---

### Question 9: Procedure (Count)
**Task:** Create a stored procedure to get **male student count** from student table.

```sql
-- Your answer here

```

---

### Question 10: Procedure (Details by RegNo)
**Task:** Create a procedure to get student name, date of birth, and gender details of a given student registration number.

**Expected Output Format:** `stuName, DOB, Gender` (e.g., K.M.P.Kumara | 1996/12/25 | Male)

```sql
-- Your answer here

```

---

### Question 11: Procedure (Age)
**Task:** Construct a stored procedure to get the **age** of a student when the registration number is given.

**Expected Output Format:** `@age` (e.g., 26)

```sql
-- Your answer here

```

---

### Question 12: Procedure (Grades)
**Task:** Calculate the student average marks of all the subjects from the 'marks' table. Create a stored procedure to print grade when the registration number is given and return the grade.

**Grade Logic:**
| Condition | Grade |
|-----------|-------|
| avg >= 75 | A |
| avg >= 60 | B |
| avg >= 40 | C |
| avg >= 20 | D |
| ELSE | F |

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Question 1: Create Database
- [ ] Question 2: Create Table 'student'
- [ ] Question 3: Insert Student Data
- [ ] Question 4: Create Table 'marks'
- [ ] Question 5: Insert Marks Data
- [ ] Question 6: Procedure (All Marks)
- [ ] Question 7: Procedure (Average)
- [ ] Question 8: Show Structure
- [ ] Question 9: Procedure (Count)
- [ ] Question 10: Procedure (Details by RegNo)
- [ ] Question 11: Procedure (Age)
- [ ] Question 12: Procedure (Grades)

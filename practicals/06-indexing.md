# Practical 06: Indexing

> **Category:** Lab/Practical Instructions  
> **Topics:** Clustered Index, Non-Clustered Index, Unique Index, Composite Index

---

## 📋 Database: `db_SAEngineering`

### Table Structures

**Employee Table:**
| Field | Type |
|-------|------|
| EmployeeID | int |
| FirstName | varchar |
| LastName | varchar |
| Email | varchar |
| HireDate | date |
| DepartmentID | int |
| ContactNumber | varchar |
| City | varchar |
| District | varchar |
| Province | varchar |

**Department Table:**
| Field | Type |
|-------|------|
| DepartmentID | int (PK, Auto Increment) |
| DepartmentName | varchar (Not Null) |
| Location | varchar |

**Project Table:**
| Field | Type |
|-------|------|
| ProjectID | int |
| ProjectName | varchar |
| StartDate | date |
| EndDate | date |

**EmployeeProjects Table:**
| Field | Type |
|-------|------|
| EmployeeID | int (FK) |
| DepartmentID | int |
| ProjectID | int (FK) |

---

## 🎯 Practice Questions

### Question 1: Create Database
**Task:** Create database `db_SAEngineering`.

```sql
-- Your answer here

```

---

### Question 2: Create Employee Table
**Task:** Create Employee table with fields: EmployeeID (integer, NOT a PK yet), FirstName, LastName, Email, HireDate, DepartmentID (no FK yet).

```sql
-- Your answer here

```

---

### Question 3: Insert Employee Data
**Task:** Insert 10 employee records.

**Sample Data:** Kamal, Nimal, Sunil, etc.

```sql
-- Your answer here

```

---

### Question 4: Create Clustered Index
**Task:** Create a clustered index on the Employee table.

```sql
-- Your answer here

```

---

### Question 5: Create Department Table
**Task:** Create Department table with DepartmentID (PK, Auto_Increment), DepartmentName (Not Null), Location.

```sql
-- Your answer here

```

---

### Question 6: Insert Department Data
**Task:** Insert 6 department records (Web Dev, Mobile Dev, etc.).

```sql
-- Your answer here

```

---

### Question 7: Create Relationship
**Task:** Modify table to represent "One department has many employees" (Add Foreign Key).

```sql
-- Your answer here

```

---

### Question 8: Modify Primary Key
**Task:** Remove existing PK from Employee table.

```sql
-- Your answer here

```

---

### Question 9: Change Clustered Index
**Task:** Create a clustered index on the DepartmentID field of the Employee table.

```sql
-- Your answer here

```

---

### Question 10: Create Project Table
**Task:** Create Project table with ProjectID, ProjectName, StartDate, EndDate.

```sql
-- Your answer here

```

---

### Question 11: Insert Project Data
**Task:** Insert 6 project records.

```sql
-- Your answer here

```

---

### Question 12: Create EmployeeProjects Table
**Task:** Create EmployeeProjects table with EmployeeID, DepartmentID, ProjectID.

```sql
-- Your answer here

```

---

### Question 13: Non-Clustered Index on FirstName
**Task:** Create a non-clustered index on the firstName column of Employee table.

```sql
-- Your answer here

```

---

### Question 14: Unique Index on Email
**Task:** Create a unique index on the email field of Employee table.

```sql
-- Your answer here

```

---

### Question 15: Unique Index on Department
**Task:** Create a unique index on DepartmentName and Location in Department table.

```sql
-- Your answer here

```

---

### Question 16: Modify Employee Table
**Task:** Add columns ContactNumber, City, District, Province to Employee table.

```sql
-- Your answer here

```

---

### Question 17: Update Employee Data
**Task:** Update employee records with contact and location details (Colombo, Galle, Kandy, etc.).

```sql
-- Your answer here

```

---

### Question 18: Index - Department and City
**Task:** Create an index to retrieve Employee details by Department and City.

```sql
-- Your answer here

```

---

### Question 19: Index - Project End Date
**Task:** Create an index to find Employees working on projects with a specific End Date.

```sql
-- Your answer here

```

---

### Question 20: Index - Province and Project
**Task:** Create an index to search Employees based on Province and Project.

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Q1: Create Database
- [ ] Q2: Create Employee Table
- [ ] Q3: Insert Employee Data
- [ ] Q4: Clustered Index
- [ ] Q5: Create Department Table
- [ ] Q6: Insert Department Data
- [ ] Q7: Create Relationship (FK)
- [ ] Q8: Modify Primary Key
- [ ] Q9: Change Clustered Index
- [ ] Q10: Create Project Table
- [ ] Q11: Insert Project Data
- [ ] Q12: Create EmployeeProjects Table
- [ ] Q13: Non-Clustered Index (FirstName)
- [ ] Q14: Unique Index (Email)
- [ ] Q15: Unique Index (Department)
- [ ] Q16: Modify Employee Table
- [ ] Q17: Update Employee Data
- [ ] Q18: Index (Dept + City)
- [ ] Q19: Index (End Date)
- [ ] Q20: Index (Province + Project)

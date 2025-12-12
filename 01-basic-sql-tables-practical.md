# Practical 01: Basic SQL & Tables

> **Category:** Lab/Practical Instructions  
> **Topics:** Database Creation, Table Creation, CRUD Operations, Joins, Views, Stored Procedures

---

## 📋 Table Definitions (Annex A)

### Table: `academic_staff`

| Field | Data Type | Constraints | Description |
|-------|-----------|-------------|-------------|
| `l_id` | char(3) | PRIMARY KEY | Unique id for the lecturer |
| `l_d_id` | char(3) | | Belonging department |
| `l_name` | varchar(30) | | Name of the lecturer |
| `l_desig` | varchar(20) | | Designation of the lecturer |
| `l_salary` | decimal(9,2) | | Salary of the lecturer |
| `l_allowance` | decimal(9,2) | | Allowance of the lecturer |

**Sample Data:**
| l_id | l_d_id | l_name | l_desig | l_salary | l_allowance |
|------|--------|--------|---------|----------|-------------|
| 101 | d01 | Kasun | Lecturer | 35000 | 15000 |
| 102 | d02 | Mahesh | Senior Lecturer | 45000 | 18000 |
| 103 | d03 | Udaya | Professor | 28000 | 62000 |
| 104 | d01 | Nadun | Senior Lecturer | 45000 | 20000 |

---

### Table: `department`

| Field | Data Type | Constraints | Description |
|-------|-----------|-------------|-------------|
| `d_id` | char(3) | PRIMARY KEY | Unique id for the department |
| `d_name` | varchar(5) | | Name of the department |
| `d_head` | char(3) | FOREIGN KEY | Name of the head of the department |

**Sample Data:**
| d_id | d_name | d_head |
|------|--------|--------|
| d01 | ICT | 104 |
| d02 | ENT | 102 |
| d03 | BT | 103 |
| d04 | PQT | 101 |

---

### Table: `project`

| Field | Data Type | Constraints | Description |
|-------|-----------|-------------|-------------|
| `pr_id` | char(4) | PRIMARY KEY | Unique id for the project |
| `pr_d_id` | char(3) | FOREIGN KEY | Name of the controlling department |
| `pr_name` | varchar(20) | | Name of the project |
| `pr_supervisor` | char(3) | FOREIGN KEY | Name of the supervisor |
| `pr_budget` | decimal(9,2) | | Budget of the project |

**Sample Data:**
| pr_id | pr_d_id | pr_name | pr_supervisor | pr_budget |
|-------|---------|---------|---------------|-----------|
| pr01 | d01 | Eagle Eye | 101 | 300000 |
| pr02 | d02 | Hill Climber | 102 | 250000 |
| pr03 | d03 | Glowing Fish | 103 | 400000 |

---

### Table: `work`

| Field | Data Type | Constraints | Description |
|-------|-----------|-------------|-------------|
| `w_pr_id` | char(4) | FOREIGN KEY | Project Id |
| `w_l_id` | char(3) | FOREIGN KEY | Lecturer Id |

**Sample Data:**
| w_pr_id | w_l_id |
|---------|--------|
| pr01 | 101 |
| pr02 | 101 |
| pr01 | 102 |
| pr01 | 104 |
| pr02 | 103 |
| pr01 | 103 |
| pr03 | 103 |

---

## 🎯 Practice Questions

### Question 1: Login
**Task:** Log in to the "MySQL Server" using given user account and password.

```sql
-- Your answer here

```

---

### Question 2: Create Database
**Task:** Create a blank database as `faculty<yourindexno>` (Ex: facultytgxxx).

```sql
-- Your answer here

```

---

### Question 3: Create Tables
**Task:** Create the tables according to the given definitions in "Annex A" above.

```sql
-- Your answer here (academic_staff table)


-- Your answer here (department table)


-- Your answer here (project table)


-- Your answer here (work table)

```

---

### Question 4: Insert Data
**Task:** Insert data to the related tables using the data given in "Annex A".

```sql
-- Your answer here (academic_staff data)


-- Your answer here (department data)


-- Your answer here (project data)


-- Your answer here (work data)

```

---

### Question 5: Modify Foreign Key
**Task:** Modify `l_d_id` field into a "Foreign Key" field in `academic_staff` table.
- **References Table:** department
- **Field:** d_id

```sql
-- Your answer here

```

---

### Question 6: Retrieve Data
**Task:** Retrieve all details from `academic_staff` table.

```sql
-- Your answer here

```

---

### Question 7: Update Data
**Task:** Update the name of the department of "BT" as "BST" in `department` table.

```sql
-- Your answer here

```

---

### Question 8: Delete Data
**Task:** Remove all the data related to "PQT" department from `department` table.

```sql
-- Your answer here

```

---

### Question 9: Select Query
**Task:** Retrieve the names and salaries of all "Senior Lectures".

```sql
-- Your answer here

```

---

### Question 10: Calculation Query
**Task:** University grant is **70%** of the total project budget. Retrieve project id, project name, project budget and the university grant for all the projects.

```sql
-- Your answer here

```

---

### Question 11: Aggregation
**Task:** Retrieve the name and the allowance of the academic staff member who is getting the **lowest allowance**.

```sql
-- Your answer here

```

---

### Question 12: Select Query
**Task:** Retrieve the names and designation of all the "Project Supervisors".

```sql
-- Your answer here

```

---

### Question 13: Join/Count
**Task:** Retrieve the number of academic staff members as "Researchers Count" who are working in the project "Eagle Eye".

```sql
-- Your answer here

```

---

### Question 14: Join/Grouping
**Task:** Retrieve the names of academic staff members who are working on **more than one project**.

```sql
-- Your answer here

```

---

### Question 15: Create View
**Task:** Create a view called `all_projects` to display project id, project name, project budget and the owning department name for all projects.

```sql
-- Your answer here

```

---

### Question 16: Create Procedure
**Task:** Create a procedure called `academic_members_for_project` to display academic staff member's id, name, designation, salary, allowance and academic staff member's department name for a particular project, when a project id is given as an input parameter.

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Question 1: Login
- [ ] Question 2: Create Database
- [ ] Question 3: Create Tables
- [ ] Question 4: Insert Data
- [ ] Question 5: Modify Foreign Key
- [ ] Question 6: Retrieve Data
- [ ] Question 7: Update Data
- [ ] Question 8: Delete Data
- [ ] Question 9: Select Query (Senior Lectures)
- [ ] Question 10: Calculation Query
- [ ] Question 11: Aggregation
- [ ] Question 12: Select Query (Supervisors)
- [ ] Question 13: Join/Count
- [ ] Question 14: Join/Grouping
- [ ] Question 15: Create View
- [ ] Question 16: Create Procedure

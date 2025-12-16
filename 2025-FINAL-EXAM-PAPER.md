# ADBMS Final Exam 2025 - Library Management System

> **Duration:** 1 Hour  
> **Total Marks:** 50  
> **Database:** library_management_system

---

## 📋 Database Schema (Provided)

### Table: `books`
| Field | Type | Description |
|-------|------|-------------|
| book_id | INT | Primary Key, Auto Increment |
| title | VARCHAR(255) | Book title |
| author | VARCHAR(150) | Author name |
| isbn | VARCHAR(20) | Unique ISBN |
| publisher | VARCHAR(150) | Publisher name |
| category | VARCHAR(100) | Book category |
| total_copies | INT | Total copies in library |
| available_copies | INT | Currently available copies |

### Table: `members`
| Field | Type | Description |
|-------|------|-------------|
| member_id | INT | Primary Key, Auto Increment |
| first_name | VARCHAR(100) | Member's first name |
| last_name | VARCHAR(100) | Member's last name |
| email | VARCHAR(150) | Unique email |
| phone | VARCHAR(20) | Phone number |
| address_line1 | VARCHAR(255) | Address line 1 |
| address_line2 | VARCHAR(255) | Address line 2 |
| join_date | DATE | Membership date |
| status | VARCHAR(20) | ACTIVE/INACTIVE |

### Table: `staff`
| Field | Type | Description |
|-------|------|-------------|
| staff_id | INT | Primary Key, Auto Increment |
| first_name | VARCHAR(100) | Staff first name |
| last_name | VARCHAR(100) | Staff last name |
| email | VARCHAR(150) | Unique email |
| role | VARCHAR(50) | Job role |

### Table: `book_transactions`
| Field | Type | Description |
|-------|------|-------------|
| transaction_id | INT | Primary Key, Auto Increment |
| book_id | INT | Foreign Key → books |
| member_id | INT | Foreign Key → members |
| issued_by_staff_id | INT | Foreign Key → staff |
| issue_date | DATE | Date book was issued |
| due_date | DATE | Return due date |
| return_date | DATE | Actual return date (NULL if not returned) |

---

## 🎯 Questions

### Question 1: Create View (10 Marks)

Create a view named `member_borrowed_books` that displays the following information:
- Member's full name (first_name + last_name)
- Member's email
- Member's phone
- Book title

The view should show all borrowed books with their member details.

```sql
-- Your answer here

```

---

### Question 2: Create User-Defined Function (10 Marks)

Create a function named `calculate_fine_for_transaction` that:
- Accepts a `transaction_id` as input parameter
- Calculates the fine based on overdue days
- Fine rate: **Rs. 100 per day** for late returns
- Returns 0 if the book was returned on time or before due date
- Fine = (return_date - due_date) × 100

```sql
-- Your answer here

```

---

### Question 3: Create Stored Procedure with OUT Parameter (10 Marks)

Create a stored procedure named `get_member_borrow_count` that:
- Accepts a `member_id` as an **IN** parameter
- Returns the count of books that the member has **NOT yet returned** as an **OUT** parameter

```sql
-- Your answer here

```

---

### Question 4: Create Index (10 Marks)

The library users often search for books by their **title**. Create an appropriate index on the suitable column to optimize these search queries.

```sql
-- Your answer here

```

---

### Question 5: Create Trigger (10 Marks)

Create a trigger named `update_available_copies_after_issue` that:
- Fires **AFTER INSERT** on the `book_transactions` table
- Automatically decrements the `available_copies` in the `books` table when a book is issued

```sql
-- Your answer here

```

---

## ✅ Marking Scheme

| Question | Topic | Marks |
|----------|-------|-------|
| Q1 | View (JOINs, CONCAT) | 10 |
| Q2 | Function (DATEDIFF, IF condition) | 10 |
| Q3 | Procedure (IN/OUT parameters) | 10 |
| Q4 | Index | 10 |
| Q5 | Trigger (AFTER INSERT, NEW) | 10 |
| **Total** | | **50** |

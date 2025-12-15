# ADBMS Final Exam - Sample Paper 2

> **Total Marks:** 60  
> **Duration:** 2 Hours  
> **Database:** LibraryDB  
> **Topics:** Views, Functions, Procedures, Triggers, Events, Indexing

---

## 📋 Database Schema

You are provided with a Library Management System database with the following tables:

### Table: `members`
| Field | Type | Description |
|-------|------|-------------|
| MemberID | INT | Primary Key |
| FirstName | VARCHAR(50) | Member's first name |
| LastName | VARCHAR(50) | Member's last name |
| Email | VARCHAR(100) | Email address |
| Phone | VARCHAR(15) | Contact number |
| MembershipDate | DATE | Date of joining |
| MemberType | VARCHAR(20) | Student/Staff/Public |

### Table: `books`
| Field | Type | Description |
|-------|------|-------------|
| BookID | INT | Primary Key |
| Title | VARCHAR(100) | Book title |
| Author | VARCHAR(100) | Author name |
| Category | VARCHAR(50) | Book category |
| ISBN | VARCHAR(20) | ISBN number |
| TotalCopies | INT | Total copies in library |
| AvailableCopies | INT | Currently available |

### Table: `borrowings`
| Field | Type | Description |
|-------|------|-------------|
| BorrowID | INT | Primary Key |
| MemberID | INT | Foreign Key → members |
| BookID | INT | Foreign Key → books |
| BorrowDate | DATE | Date borrowed |
| DueDate | DATE | Return due date |
| ReturnDate | DATE | Actual return date (NULL if not returned) |
| Fine | DECIMAL(10,2) | Late return fine |

### Table: `reservations`
| Field | Type | Description |
|-------|------|-------------|
| ReservationID | INT | Primary Key |
| MemberID | INT | Foreign Key → members |
| BookID | INT | Foreign Key → books |
| ReservationDate | DATE | Date of reservation |
| Status | VARCHAR(20) | Active/Fulfilled/Cancelled |

---

## Section A: Views (12 Marks)

### Question 1 (6 Marks)
Create a view named `vw_CurrentBorrowings` that displays:
- Member's full name (FirstName + LastName)
- Member type
- Book title
- Author
- Borrow date
- Due date

Only show books that have NOT been returned yet (ReturnDate IS NULL).

```sql
-- Your answer here

```

---

### Question 2 (6 Marks)
Create a view named `vw_BookStatistics` that shows for each book:
- Book ID
- Title
- Total times borrowed (count of borrowings)
- Total fine collected
- Available copies

Group by book and order by total times borrowed descending.

```sql
-- Your answer here

```

---

## Section B: User-Defined Functions (12 Marks)

### Question 3 (6 Marks)
Create a function named `fn_CalculateFine` that:
- Accepts a BorrowID as input
- Calculates the fine based on overdue days (Rs. 10 per day)
- Returns 0 if the book is not overdue or already returned
- Formula: Fine = (CURDATE - DueDate) × 10

```sql
-- Your answer here

```

---

### Question 4 (6 Marks)
Create a function named `fn_GetMemberBorrowCount` that:
- Accepts a MemberID and a Year (e.g., 2024) as parameters
- Returns the total number of books borrowed by that member in that year

```sql
-- Your answer here

```

---

## Section C: Stored Procedures (18 Marks)

### Question 5 (6 Marks)
Create a stored procedure named `sp_BorrowBook` that:
- Accepts MemberID and BookID as IN parameters
- Checks if AvailableCopies > 0
- If available:
  - Inserts a new borrowing record (BorrowDate = today, DueDate = today + 14 days)
  - Decrements AvailableCopies in books table
  - Returns SUCCESS message
- If not available:
  - Returns 'Book not available' message

```sql
-- Your answer here

```

---

### Question 6 (6 Marks)
Create a stored procedure named `sp_ReturnBook` that:
- Accepts BorrowID as IN parameter
- Updates the borrowing record (set ReturnDate = today)
- Calculates and updates the Fine (Rs. 10 per overdue day, 0 if on time)
- Increments AvailableCopies in books table
- Returns the fine amount as OUT parameter

```sql
-- Your answer here

```

---

### Question 7 (6 Marks)
Create a stored procedure named `sp_GetOverdueBooks` that:
- Returns all currently overdue books with:
  - Member's full name
  - Phone number
  - Book title
  - Due date
  - Days overdue
- Order by days overdue descending

```sql
-- Your answer here

```

---

## Section D: Triggers (12 Marks)

### Question 8 (6 Marks)
Create a trigger named `trg_UpdateAvailability` that:
- Fires AFTER INSERT on the `borrowings` table
- Automatically decrements the AvailableCopies in the books table for the borrowed book
- (Note: This ensures inventory is always updated)

```sql
-- Your answer here

```

---

### Question 9 (6 Marks)
Create a trigger named `trg_PreventOverBorrow` that:
- Fires BEFORE INSERT on the `borrowings` table
- Checks if the member already has 5 or more unreturned books
- If yes, raises an error and prevents the insert
- Error message: 'Member has reached maximum borrowing limit'

```sql
-- Your answer here

```

---

## Section E: Events (6 Marks)

### Question 10 (6 Marks)
Create an event named `evt_SendOverdueReminder` that:
- Runs every day at 8:00 AM
- Inserts records into an `overdue_notifications` table for all members with overdue books
- Include: MemberID, BookID, DaysOverdue, NotificationDate

```sql
-- Your answer here

```

---

## Section F: Indexing (6 Marks)

### Question 11 (3 Marks)
**Theory:** Explain the Leftmost Prefix Rule for composite indexes. Give an example showing when an index on (A, B, C) would be used and when it would NOT be used.

```
Your answer:



```

---

### Question 12 (3 Marks)
Create a unique index named `idx_unique_isbn` on the `books` table for the ISBN column.
Also, create a composite index named `idx_borrowing_search` on the `borrowings` table for `MemberID` and `BorrowDate`.

```sql
-- Your answer here

```

---

## ✅ Marking Scheme

| Section | Topic | Marks |
|---------|-------|-------|
| A | Views (Q1, Q2) | 12 |
| B | Functions (Q3, Q4) | 12 |
| C | Procedures (Q5, Q6, Q7) | 18 |
| D | Triggers (Q8, Q9) | 12 |
| E | Events (Q10) | 6 |
| F | Indexing (Q11, Q12) | 6 |
| **Total** | | **60** |

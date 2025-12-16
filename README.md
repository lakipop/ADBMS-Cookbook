# 📚 ADBMS Cookbook

A comprehensive study guide for **Advanced Database Management Systems (MySQL)** - BICT 3rd Year, Final Semester.

> Complete with theory notes, practical exercises, SQL answers, and exam papers.

---

## 📁 Repository Structure

```
ADBMS-Cookbook/
├── theory/              # Concept explanations and notes
├── practicals/          # Hands-on exercises with questions
├── SQL-answers/         # Complete SQL solutions
├── exam-papers/         # Sample and past exam papers
└── db-setups/           # Database setup scripts for practice
```

---

## 📖 Theory Notes

| # | Topic | File |
|---|-------|------|
| 1 | User-Defined Functions | [theory/01-user-defined-functions.md](theory/01-user-defined-functions.md) |
| 2 | Views | [theory/02-views.md](theory/02-views.md) |
| 3 | Stored Procedures | [theory/03-stored-procedures.md](theory/03-stored-procedures.md) |
| 4 | MySQL Events | [theory/04-events.md](theory/04-events.md) |
| 5 | Triggers | [theory/05-triggers.md](theory/05-triggers.md) |
| 6 | Indexing | [theory/06-indexing.md](theory/06-indexing.md) |
| 7 | Error Handling | [theory/07-error-handling.md](theory/07-error-handling.md) |
| 8 | Transactions | [theory/08-transactions.md](theory/08-transactions.md) |
| 9 | Security | [theory/09-security.md](theory/09-security.md) |

---

## 💻 Practicals

| # | Topic | Questions | Answers |
|---|-------|-----------|---------|
| 1 | Basic SQL & Tables | [practicals/01-basic-sql-tables.md](practicals/01-basic-sql-tables.md) | [SQL-answers/01-basic-sql-tables.sql](SQL-answers/01-basic-sql-tables.sql) |
| 2 | Stored Procedures | [practicals/02-stored-procedures-stumarks.md](practicals/02-stored-procedures-stumarks.md) | [SQL-answers/02-stored-procedures-stumarks.sql](SQL-answers/02-stored-procedures-stumarks.sql) |
| 3 | Complex Schema & Procedures | [practicals/03-complex-schema-procedures.md](practicals/03-complex-schema-procedures.md) | [SQL-answers/03-complex-schema-procedures.sql](SQL-answers/03-complex-schema-procedures.sql) |
| 4 | User-Defined Functions | [practicals/04-user-defined-functions.md](practicals/04-user-defined-functions.md) | [SQL-answers/04-user-defined-functions.sql](SQL-answers/04-user-defined-functions.sql) |
| 5 | Triggers & Views | [practicals/05-triggers-views.md](practicals/05-triggers-views.md) | [SQL-answers/05-triggers-views.sql](SQL-answers/05-triggers-views.sql) |
| 6 | Indexing | [practicals/06-indexing.md](practicals/06-indexing.md) | [SQL-answers/06-indexing.sql](SQL-answers/06-indexing.sql) |
| 7 | Views | [practicals/07-views.md](practicals/07-views.md) | [SQL-answers/07-views.sql](SQL-answers/07-views.sql) |
| 8 | Events | [practicals/08-events.md](practicals/08-events.md) | [SQL-answers/08-events.sql](SQL-answers/08-events.sql) |
| 9 | Events (Southern Tyes) | [practicals/09-events-southern-tyes.md](practicals/09-events-southern-tyes.md) | [SQL-answers/09-events-southern-tyes.sql](SQL-answers/09-events-southern-tyes.sql) |
| 10 | Transactions | [practicals/10-transactions.md](practicals/10-transactions.md) | [SQL-answers/10-transactions.sql](SQL-answers/10-transactions.sql) |
| 11 | Security | [practicals/11-security.md](practicals/11-security.md) | [SQL-answers/11-security.sql](SQL-answers/11-security.sql) |

---

## 📝 Exam Papers

### Sample Papers - 1 Hour (60 Marks)
| Paper | Scenario | Questions | Answers | DB Setup |
|-------|----------|-----------|---------|----------|
| Sample Paper 1 | Hospital Management | [exam-papers/sample-paper-1-hospital.md](exam-papers/sample-paper-1-hospital.md) | [SQL-answers/sample-paper-1-hospital.sql](SQL-answers/sample-paper-1-hospital.sql) | [db-setups/sample-paper-1-hospital-setup.sql](db-setups/sample-paper-1-hospital-setup.sql) |
| Sample Paper 2 | Library Management | [exam-papers/sample-paper-2-library.md](exam-papers/sample-paper-2-library.md) | [SQL-answers/sample-paper-2-library.sql](SQL-answers/sample-paper-2-library.sql) | [db-setups/sample-paper-2-library-setup.sql](db-setups/sample-paper-2-library-setup.sql) |

### Sample Papers - 2 Hours (100 Marks) ⭐ NEW
| Paper | Scenario | Topics | Questions | Answers |
|-------|----------|--------|-----------|---------|
| Sample Paper 3 | Online Store | All Topics | [exam-papers/sample-paper-3-onlinestore.md](exam-papers/sample-paper-3-onlinestore.md) | [SQL-answers/sample-paper-3-onlinestore.sql](SQL-answers/sample-paper-3-onlinestore.sql) |
| Sample Paper 4 | University | All Topics | [exam-papers/sample-paper-4-university.md](exam-papers/sample-paper-4-university.md) | [SQL-answers/sample-paper-4-university.sql](SQL-answers/sample-paper-4-university.sql) |

### 2025 Actual Exam Papers
| Paper | Marks | Questions | Answers |
|-------|-------|-----------|---------|
| Mid Exam 2025 | 20 | [exam-papers/2025-mid-exam.md](exam-papers/2025-mid-exam.md) | [SQL-answers/2025-mid-exam.sql](SQL-answers/2025-mid-exam.sql) |
| Final Exam 2025 | 50 | [exam-papers/2025-final-exam.md](exam-papers/2025-final-exam.md) | [SQL-answers/2025-final-exam.sql](SQL-answers/2025-final-exam.sql) |

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/ADBMS-Cookbook.git
```

### 2. Setup Database (for practice)
```bash
# For Sample Paper 1 (Hospital)
mysql -u root -p < db-setups/sample-paper-1-hospital-setup.sql

# For Sample Paper 2 (Library)
mysql -u root -p < db-setups/sample-paper-2-library-setup.sql
```

### 3. Practice
1. Open a practical file from `practicals/`
2. Try solving the questions
3. Check your answers against `SQL-answers/`

---

## 📊 Topics Covered

| Category | Topics |
|----------|--------|
| **DDL/DML** | CREATE, INSERT, UPDATE, DELETE, ALTER |
| **Views** | Simple, Join, Aggregate, WITH CHECK OPTION |
| **Procedures** | IN, OUT, INOUT parameters, Error Handling |
| **Functions** | Scalar, Deterministic, READS SQL DATA |
| **Triggers** | BEFORE/AFTER, INSERT/UPDATE/DELETE, NEW/OLD |
| **Events** | Scheduled tasks, INTERVAL, START/END |
| **Indexing** | Clustered, Non-clustered, Composite, Unique |
| **Transactions** | ACID, COMMIT, ROLLBACK, SAVEPOINT, Isolation Levels |
| **Security** | Users, GRANT, REVOKE, Roles, Encryption |

---

## 🎓 Course Information

- **Course:** Advanced Database Management Systems (ADBMS)
- **Degree:** BICT (Bachelor of Information & Communication Technology)
- **Year:** 3rd Year, Final Semester
- **Database:** MySQL 8.0+

---

## 📜 License

This repository is for educational purposes. Feel free to use and share!

---

## 🤝 Contributing

Found an error or want to add more content? Feel free to open an issue or submit a pull request!

---

**Happy Learning! 🎉**

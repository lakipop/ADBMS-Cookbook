# ADBMS Final Exam - Sample Paper 1

> **Total Marks:** 60  
> **Duration:** 2 Hours  
> **Database:** HospitalDB  
> **Topics:** Views, Functions, Procedures, Triggers, Events, Indexing

---

## 📋 Database Schema

You are provided with a Hospital Management System database with the following tables:

### Table: `doctors`
| Field | Type | Description |
|-------|------|-------------|
| DoctorID | INT | Primary Key |
| FirstName | VARCHAR(50) | Doctor's first name |
| LastName | VARCHAR(50) | Doctor's last name |
| Specialization | VARCHAR(50) | Medical specialization |
| Salary | DECIMAL(10,2) | Monthly salary |
| HireDate | DATE | Date of joining |

### Table: `patients`
| Field | Type | Description |
|-------|------|-------------|
| PatientID | INT | Primary Key |
| FirstName | VARCHAR(50) | Patient's first name |
| LastName | VARCHAR(50) | Patient's last name |
| DOB | DATE | Date of birth |
| Gender | VARCHAR(10) | Gender |
| Phone | VARCHAR(15) | Contact number |

### Table: `appointments`
| Field | Type | Description |
|-------|------|-------------|
| AppointmentID | INT | Primary Key |
| PatientID | INT | Foreign Key → patients |
| DoctorID | INT | Foreign Key → doctors |
| AppointmentDate | DATE | Date of appointment |
| AppointmentTime | TIME | Time of appointment |
| Status | VARCHAR(20) | Pending/Completed/Cancelled |
| Fee | DECIMAL(10,2) | Consultation fee |

### Table: `prescriptions`
| Field | Type | Description |
|-------|------|-------------|
| PrescriptionID | INT | Primary Key |
| AppointmentID | INT | Foreign Key → appointments |
| Medicine | VARCHAR(100) | Medicine name |
| Dosage | VARCHAR(50) | Dosage instructions |
| Duration | INT | Days |

---

## Section A: Views (12 Marks)

### Question 1 (6 Marks)
Create a view named `vw_DoctorAppointments` that displays:
- Doctor's full name (FirstName + LastName)
- Specialization
- Patient's full name
- Appointment date
- Appointment status
- Fee

Order the results by appointment date descending.

```sql
-- Your answer here

```

---

### Question 2 (6 Marks)
Create a view named `vw_DoctorEarnings` that shows:
- Doctor ID
- Doctor's full name
- Total number of completed appointments
- Total earnings (sum of fees for completed appointments)

Only include doctors who have completed at least 1 appointment. Use `WITH CHECK OPTION`.

```sql
-- Your answer here

```

---

## Section B: User-Defined Functions (12 Marks)

### Question 3 (6 Marks)
Create a function named `fn_GetPatientAge` that:
- Accepts a PatientID as input
- Returns the patient's age in years (calculated from DOB)

```sql
-- Your answer here

```

---

### Question 4 (6 Marks)
Create a function named `fn_GetDoctorAppointmentCount` that:
- Accepts a DoctorID and a Status (e.g., 'Completed', 'Pending') as parameters
- Returns the count of appointments matching that status

```sql
-- Your answer here

```

---

## Section C: Stored Procedures (18 Marks)

### Question 5 (6 Marks)
Create a stored procedure named `sp_GetPatientHistory` that:
- Accepts a PatientID as IN parameter
- Returns all appointments for that patient with:
  - Appointment date
  - Doctor's full name
  - Doctor's specialization
  - Status
  - Fee

```sql
-- Your answer here

```

---

### Question 6 (6 Marks)
Create a stored procedure named `sp_GetDoctorStats` that:
- Accepts a DoctorID as IN parameter
- Returns (as OUT parameters):
  - Total appointments count
  - Completed appointments count
  - Total earnings

```sql
-- Your answer here

```

---

### Question 7 (6 Marks)
Create a stored procedure named `sp_BookAppointment` that:
- Accepts: PatientID, DoctorID, AppointmentDate, AppointmentTime, Fee as IN parameters
- Inserts a new appointment with Status = 'Pending'
- Returns the new AppointmentID as an OUT parameter

```sql
-- Your answer here

```

---

## Section D: Triggers (12 Marks)

### Question 8 (6 Marks)
Create a trigger named `trg_SetDefaultFee` that:
- Fires BEFORE INSERT on the `appointments` table
- If the Fee is NULL or 0, sets it to a default value of 1500.00

```sql
-- Your answer here

```

---

### Question 9 (6 Marks)
Create a trigger named `trg_LogCancellation` that:
- Fires AFTER UPDATE on the `appointments` table
- When an appointment status changes to 'Cancelled', logs the details into an `appointment_cancellations` table with:
  - AppointmentID
  - PatientID
  - DoctorID
  - CancellationDate (current timestamp)

```sql
-- Your answer here

```

---

## Section E: Events (6 Marks)

### Question 10 (6 Marks)
Create an event named `evt_AutoCancelOldPending` that:
- Runs every day at midnight
- Automatically changes status to 'Cancelled' for appointments that:
  - Have status 'Pending'
  - Have appointment date older than 7 days ago

```sql
-- Your answer here

```

---

## Section F: Indexing (6 Marks - Theory + Practical)

### Question 11 (3 Marks)
**Theory:** Explain the difference between a Clustered Index and a Non-Clustered Index. Give one example of when you would use each.

```
Your answer:



```

---

### Question 12 (3 Marks)
Create a composite index named `idx_appointment_search` on the `appointments` table for columns `DoctorID`, `AppointmentDate`, and `Status` (in that order).

Write an `EXPLAIN` query to verify the index is being used when querying appointments by DoctorID.

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

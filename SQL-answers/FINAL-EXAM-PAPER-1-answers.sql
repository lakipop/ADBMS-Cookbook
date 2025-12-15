-- ==========================================
-- ADBMS FINAL EXAM - SAMPLE PAPER 1 ANSWERS
-- Total Marks: 60
-- Database: HospitalDB
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE IF NOT EXISTS HospitalDB;
USE HospitalDB;

-- Doctors Table
CREATE TABLE doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialization VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

-- Patients Table
CREATE TABLE patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(15)
);

-- Appointments Table
CREATE TABLE appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    AppointmentTime TIME,
    Status VARCHAR(20) DEFAULT 'Pending',
    Fee DECIMAL(10,2),
    FOREIGN KEY (PatientID) REFERENCES patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES doctors(DoctorID)
);

-- Prescriptions Table
CREATE TABLE prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT,
    Medicine VARCHAR(100),
    Dosage VARCHAR(50),
    Duration INT,
    FOREIGN KEY (AppointmentID) REFERENCES appointments(AppointmentID)
);

-- Cancellation Log Table (for trigger Q9)
CREATE TABLE appointment_cancellations (
    CancellationID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT,
    PatientID INT,
    DoctorID INT,
    CancellationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO doctors VALUES 
(1, 'Kamal', 'Perera', 'Cardiology', 150000, '2020-01-15'),
(2, 'Nimal', 'Silva', 'Neurology', 140000, '2019-03-20'),
(3, 'Sunil', 'Fernando', 'Orthopedics', 130000, '2021-06-10');

INSERT INTO patients VALUES
(1, 'Amara', 'Jayawardena', '1990-05-15', 'Female', '0771234567'),
(2, 'Kumari', 'Rathnayake', '1985-08-20', 'Female', '0772345678'),
(3, 'Ruwan', 'Bandara', '1978-12-10', 'Male', '0773456789');

INSERT INTO appointments VALUES
(1, 1, 1, '2024-12-01', '09:00:00', 'Completed', 2000),
(2, 2, 1, '2024-12-02', '10:00:00', 'Completed', 2000),
(3, 3, 2, '2024-12-03', '11:00:00', 'Pending', 1800),
(4, 1, 2, '2024-12-04', '14:00:00', 'Completed', 1800),
(5, 2, 3, '2024-12-05', '15:00:00', 'Cancelled', 1500);

-- ==========================================
-- SECTION A: VIEWS
-- ==========================================

-- ==========================================
-- Question 1 (6 Marks): vw_DoctorAppointments
-- ==========================================

CREATE VIEW vw_DoctorAppointments AS
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialization,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    a.AppointmentDate,
    a.Status,
    a.Fee
FROM doctors d
JOIN appointments a ON d.DoctorID = a.DoctorID
JOIN patients p ON a.PatientID = p.PatientID
ORDER BY a.AppointmentDate DESC;

-- Test: SELECT * FROM vw_DoctorAppointments;

-- ==========================================
-- Question 2 (6 Marks): vw_DoctorEarnings
-- ==========================================

CREATE VIEW vw_completedApp AS
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    COUNT(a.AppointmentID) AS noapp,
    SUM(a.Fee) AS TotalFee  -- ← Add alias for clarity
FROM doctors d 
JOIN appointments a ON d.DoctorID = a.DoctorID
WHERE a.Status = 'Completed' 
GROUP BY d.DoctorID, d.FirstName, d.LastName  -- ← Some MySQL modes need this
HAVING COUNT(a.AppointmentID) > 1;

-- Test: SELECT * FROM vw_DoctorEarnings;

-- ==========================================
-- SECTION B: USER-DEFINED FUNCTIONS
-- ==========================================

-- ==========================================
-- Question 3 (6 Marks): fn_GetPatientAge
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_GetPatientAge(p_PatientID INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE patient_age INT;
    
    SELECT TIMESTAMPDIFF(YEAR, DOB, CURDATE()) INTO patient_age
    FROM patients
    WHERE PatientID = p_PatientID;
    
    RETURN patient_age;
END //

DELIMITER ;

-- Test: SELECT fn_GetPatientAge(1) AS PatientAge;

-- ==========================================
-- Question 4 (6 Marks): fn_GetDoctorAppointmentCount
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_GetDoctorAppointmentCount(p_DoctorID INT, p_Status VARCHAR(20))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE appt_count INT;
    
    SELECT COUNT(*) INTO appt_count
    FROM appointments
    WHERE DoctorID = p_DoctorID AND Status = p_Status;
    
    RETURN appt_count;
END //

DELIMITER ;

-- Test: SELECT fn_GetDoctorAppointmentCount(1, 'Completed') AS CompletedCount;

-- ==========================================
-- SECTION C: STORED PROCEDURES
-- ==========================================

-- ==========================================
-- Question 5 (6 Marks): sp_GetPatientHistory
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetPatientHistory(IN p_PatientID INT)
BEGIN
    SELECT 
        a.AppointmentDate,
        CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
        d.Specialization,
        a.Status,
        a.Fee
    FROM appointments a
    JOIN doctors d ON a.DoctorID = d.DoctorID
    WHERE a.PatientID = p_PatientID
    ORDER BY a.AppointmentDate DESC;
END //

DELIMITER ;

-- Test: CALL sp_GetPatientHistory(1);

-- ==========================================
-- Question 6 (6 Marks): sp_GetDoctorStats
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetDoctorStats(
    IN p_DoctorID INT,
    OUT p_TotalAppointments INT,
    OUT p_CompletedAppointments INT,
    OUT p_TotalEarnings DECIMAL(10,2)
)
BEGIN
    SELECT COUNT(*) INTO p_TotalAppointments
    FROM appointments WHERE DoctorID = p_DoctorID;
    
    SELECT COUNT(*) INTO p_CompletedAppointments
    FROM appointments WHERE DoctorID = p_DoctorID AND Status = 'Completed';
    
    SELECT COALESCE(SUM(Fee), 0) INTO p_TotalEarnings
    FROM appointments WHERE DoctorID = p_DoctorID AND Status = 'Completed';
END //

DELIMITER ;

-- Test:
-- CALL sp_GetDoctorStats(1, @total, @completed, @earnings);
-- SELECT @total AS TotalAppts, @completed AS CompletedAppts, @earnings AS Earnings;

-- ==========================================
-- Question 6 (6 Marks): sp_GetDoctorStats (Without OUT)
-- ==========================================
-- If question doesn't ask for OUT, just return result set:
CREATE PROCEDURE sp_GetDoctorStats(IN docID INT)
BEGIN
    SELECT 
        COUNT(AppointmentID) AS TotalAppts,
        (SELECT COUNT(AppointmentID) FROM appointments WHERE DoctorID = docID AND Status = 'Completed') AS CompletedAppts,
        (SELECT SUM(Fee) FROM appointments WHERE DoctorID = docID AND Status = 'Completed') AS TotalEarnings
    FROM appointments 
    WHERE DoctorID = docID;
END

-- ==========================================
-- Question 7 (6 Marks): sp_BookAppointment
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_BookAppointment(
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_AppointmentDate DATE,
    IN p_AppointmentTime TIME,
    IN p_Fee DECIMAL(10,2),
    OUT p_NewAppointmentID INT
)
BEGIN
    INSERT INTO appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, Fee)
    VALUES (p_PatientID, p_DoctorID, p_AppointmentDate, p_AppointmentTime, 'Pending', p_Fee);
    
    SET p_NewAppointmentID = LAST_INSERT_ID();
END //

DELIMITER ;

-- Test:
-- CALL sp_BookAppointment(1, 2, '2024-12-20', '10:00:00', 2000, @newID);
-- SELECT @newID AS NewAppointmentID;

-- ==========================================
-- SECTION D: TRIGGERS
-- ==========================================

-- ==========================================
-- Question 8 (6 Marks): trg_SetDefaultFee
-- ==========================================

DELIMITER //

CREATE TRIGGER trg_SetDefaultFee
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    IF NEW.Fee IS NULL OR NEW.Fee = 0 THEN
        SET NEW.Fee = 1500.00;
    END IF;
END //

DELIMITER ;

-- Test: INSERT INTO appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, Fee)
--       VALUES (1, 1, '2024-12-25', '09:00:00', 'Pending', NULL);
-- Fee will be set to 1500.00

-- ==========================================
-- Question 9 (6 Marks): trg_LogCancellation
-- ==========================================

DELIMITER //

CREATE TRIGGER trg_LogCancellation
AFTER UPDATE ON appointments
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Cancelled' AND OLD.Status != 'Cancelled' THEN
        INSERT INTO appointment_cancellations (AppointmentID, PatientID, DoctorID,CancellationDate)
        VALUES (NEW.AppointmentID, NEW.PatientID, NEW.DoctorID,NOW());
    END IF;
END //

DELIMITER ;

-- Test: UPDATE appointments SET Status = 'Cancelled' WHERE AppointmentID = 3;
-- Check: SELECT * FROM appointment_cancellations;

-- ==========================================
-- SECTION E: EVENTS
-- ==========================================

-- ==========================================
-- Question 10 (6 Marks): evt_AutoCancelOldPending
-- ==========================================

-- Enable event scheduler first
SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT evt_AutoCancelOldPending
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY)
DO
BEGIN
    UPDATE appointments
    SET Status = 'Cancelled'
    WHERE Status = 'Pending'
      AND AppointmentDate < CURDATE() - INTERVAL 7 DAY;
END //

DELIMITER ;

-- Verify: SHOW EVENTS;

-- ==========================================
-- SECTION F: INDEXING
-- ==========================================

-- ==========================================
-- Question 11 (3 Marks): Theory Answer
-- ==========================================
/*
CLUSTERED INDEX vs NON-CLUSTERED INDEX:

CLUSTERED INDEX:
- Physically sorts and stores the data rows in the table based on the index key
- Only ONE clustered index per table
- In MySQL/InnoDB, the PRIMARY KEY is the clustered index
- Example: Use for columns frequently used in range queries (e.g., date ranges)

NON-CLUSTERED INDEX:
- Creates a separate structure that holds the index key and a pointer to the data
- Multiple non-clustered indexes per table allowed
- Requires additional storage space
- Example: Use for columns frequently used in WHERE clauses (e.g., email, phone)

When to use:
- Clustered: OrderDate in an Orders table (for date range queries)
- Non-Clustered: Email in a Users table (for lookup queries)
*/

-- ==========================================
-- Question 12 (3 Marks): Composite Index
-- ==========================================

CREATE INDEX idx_appointment_search 
ON appointments(DoctorID, AppointmentDate, Status);

-- Verify with EXPLAIN
EXPLAIN SELECT *
FROM appointments
WHERE DoctorID = 1;

-- Expected: type=ref, key=idx_appointment_search

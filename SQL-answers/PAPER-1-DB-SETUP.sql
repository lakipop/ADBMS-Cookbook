-- ==========================================
-- FINAL EXAM PAPER 1 - DATABASE SETUP
-- Database: HospitalDB
-- Run this file first before practicing
-- ==========================================

-- Create and use database
DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- ==========================================
-- TABLE: doctors
-- ==========================================
CREATE TABLE doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

-- ==========================================
-- TABLE: patients
-- ==========================================
CREATE TABLE patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(15)
);

-- ==========================================
-- TABLE: appointments
-- ==========================================
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

-- ==========================================
-- TABLE: prescriptions
-- ==========================================
CREATE TABLE prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT,
    Medicine VARCHAR(100),
    Dosage VARCHAR(50),
    Duration INT,
    FOREIGN KEY (AppointmentID) REFERENCES appointments(AppointmentID)
);

-- ==========================================
-- TABLE: appointment_cancellations (for trigger Q9)
-- ==========================================
CREATE TABLE appointment_cancellations (
    CancellationID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT,
    PatientID INT,
    DoctorID INT,
    CancellationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- INSERT DATA: doctors (10 records)
-- ==========================================
INSERT INTO doctors (FirstName, LastName, Specialization, Salary, HireDate) VALUES
('Kamal', 'Perera', 'Cardiology', 250000, '2018-01-15'),
('Nimal', 'Silva', 'Neurology', 230000, '2019-03-20'),
('Sunil', 'Fernando', 'Orthopedics', 220000, '2020-06-10'),
('Amara', 'Jayawardena', 'Pediatrics', 200000, '2021-02-28'),
('Kumari', 'Rathnayake', 'Dermatology', 190000, '2022-01-10'),
('Ruwan', 'Bandara', 'General Medicine', 180000, '2019-08-15'),
('Dilani', 'Gunasekara', 'Gynecology', 240000, '2017-11-20'),
('Saman', 'Wickrama', 'ENT', 195000, '2020-04-05'),
('Malini', 'Samarasinghe', 'Ophthalmology', 210000, '2018-09-12'),
('Nuwan', 'Dissanayake', 'Cardiology', 235000, '2021-07-25');

-- ==========================================
-- INSERT DATA: patients (15 records)
-- ==========================================
INSERT INTO patients (FirstName, LastName, DOB, Gender, Phone) VALUES
('Amal', 'Fonseka', '1985-05-15', 'Male', '0771234567'),
('Nimali', 'Weerasinghe', '1990-08-20', 'Female', '0772345678'),
('Pradeep', 'Ranatunga', '1978-12-10', 'Male', '0773456789'),
('Chamari', 'Athapaththu', '1995-03-25', 'Female', '0774567890'),
('Lasith', 'Malinga', '1982-07-18', 'Male', '0775678901'),
('Hashini', 'Karunaratne', '1988-11-05', 'Female', '0776789012'),
('Thilina', 'Kandamby', '1975-02-28', 'Male', '0777890123'),
('Sachini', 'Nisansala', '1992-09-14', 'Female', '0778901234'),
('Dimuth', 'Karunaratne', '1980-06-22', 'Male', '0779012345'),
('Oshadi', 'Ranasinghe', '1998-01-30', 'Female', '0770123456'),
('Kusal', 'Mendis', '1987-04-12', 'Male', '0771122334'),
('Anushka', 'Fernando', '1993-10-08', 'Female', '0772233445'),
('Charith', 'Asalanka', '1983-08-17', 'Male', '0773344556'),
('Vishmi', 'Gunaratne', '1996-12-03', 'Female', '0774455667'),
('Pathum', 'Nissanka', '1979-05-29', 'Male', '0775566778');

-- ==========================================
-- INSERT DATA: appointments (25 records)
-- ==========================================
INSERT INTO appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, Fee) VALUES
-- Completed appointments
(1, 1, '2024-11-01', '09:00:00', 'Completed', 2500),
(2, 1, '2024-11-02', '10:00:00', 'Completed', 2500),
(3, 2, '2024-11-03', '11:00:00', 'Completed', 2200),
(4, 2, '2024-11-04', '14:00:00', 'Completed', 2200),
(5, 3, '2024-11-05', '15:00:00', 'Completed', 2000),
(6, 3, '2024-11-06', '09:30:00', 'Completed', 2000),
(7, 4, '2024-11-07', '10:30:00', 'Completed', 1800),
(8, 4, '2024-11-08', '11:30:00', 'Completed', 1800),
(1, 5, '2024-11-10', '14:30:00', 'Completed', 1500),
(2, 5, '2024-11-11', '15:30:00', 'Completed', 1500),
-- Pending appointments
(9, 1, '2024-12-15', '09:00:00', 'Pending', 2500),
(10, 1, '2024-12-16', '10:00:00', 'Pending', 2500),
(11, 2, '2024-12-17', '11:00:00', 'Pending', 2200),
(12, 3, '2024-12-18', '14:00:00', 'Pending', 2000),
(13, 4, '2024-12-19', '15:00:00', 'Pending', 1800),
(14, 5, '2024-12-20', '09:30:00', 'Pending', 1500),
(15, 6, '2024-12-21', '10:30:00', 'Pending', 1600),
-- Cancelled appointments
(3, 6, '2024-11-15', '11:30:00', 'Cancelled', 1600),
(4, 7, '2024-11-16', '14:30:00', 'Cancelled', 2300),
(5, 7, '2024-11-17', '15:30:00', 'Cancelled', 2300),
-- More varied data
(6, 8, '2024-11-20', '09:00:00', 'Completed', 1700),
(7, 9, '2024-11-21', '10:00:00', 'Completed', 1900),
(8, 10, '2024-11-22', '11:00:00', 'Completed', 2400),
(9, 10, '2024-11-23', '14:00:00', 'Pending', 2400),
(10, 1, '2024-11-25', '15:00:00', 'Completed', 2500);

-- ==========================================
-- INSERT DATA: prescriptions (15 records)
-- ==========================================
INSERT INTO prescriptions (AppointmentID, Medicine, Dosage, Duration) VALUES
(1, 'Aspirin', '100mg once daily', 30),
(1, 'Metoprolol', '50mg twice daily', 30),
(2, 'Lisinopril', '10mg once daily', 60),
(3, 'Gabapentin', '300mg three times daily', 14),
(4, 'Sumatriptan', '50mg as needed', 10),
(5, 'Ibuprofen', '400mg three times daily', 7),
(5, 'Calcium supplements', '500mg daily', 90),
(6, 'Diclofenac', '50mg twice daily', 14),
(7, 'Amoxicillin', '500mg three times daily', 7),
(8, 'Cetirizine', '10mg once daily', 30),
(9, 'Vitamin D', '1000IU daily', 60),
(10, 'Hydrocortisone cream', 'Apply twice daily', 14),
(21, 'Omeprazole', '20mg before breakfast', 30),
(22, 'Eye drops', '2 drops four times daily', 7),
(23, 'Atorvastatin', '20mg at night', 90);

-- ==========================================
-- VERIFY DATA
-- ==========================================
SELECT 'doctors' AS TableName, COUNT(*) AS RecordCount FROM doctors
UNION ALL
SELECT 'patients', COUNT(*) FROM patients
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'prescriptions', COUNT(*) FROM prescriptions;

-- ==========================================
-- READY FOR PRACTICE!
-- ==========================================
SELECT '✅ HospitalDB is ready! You can now practice Paper 1 questions.' AS Message;

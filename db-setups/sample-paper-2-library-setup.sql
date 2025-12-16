-- ==========================================
-- FINAL EXAM PAPER 2 - DATABASE SETUP
-- Database: LibraryDB
-- Run this file first before practicing
-- ==========================================

-- Create and use database
DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- ==========================================
-- TABLE: members
-- ==========================================
CREATE TABLE members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    MembershipDate DATE,
    MemberType VARCHAR(20)
);

-- ==========================================
-- TABLE: books
-- ==========================================
CREATE TABLE books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100),
    Category VARCHAR(50),
    ISBN VARCHAR(20),
    TotalCopies INT DEFAULT 1,
    AvailableCopies INT DEFAULT 1
);

-- ==========================================
-- TABLE: borrowings
-- ==========================================
CREATE TABLE borrowings (
    BorrowID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    ReturnDate DATE NULL,
    Fine DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (MemberID) REFERENCES members(MemberID),
    FOREIGN KEY (BookID) REFERENCES books(BookID)
);

-- ==========================================
-- TABLE: reservations
-- ==========================================
CREATE TABLE reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    ReservationDate DATE,
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (MemberID) REFERENCES members(MemberID),
    FOREIGN KEY (BookID) REFERENCES books(BookID)
);

-- ==========================================
-- TABLE: overdue_notifications (for event Q10)
-- ==========================================
CREATE TABLE overdue_notifications (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    DaysOverdue INT,
    NotificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- INSERT DATA: members (15 records)
-- ==========================================
INSERT INTO members (FirstName, LastName, Email, Phone, MembershipDate, MemberType) VALUES
('Kamal', 'Perera', 'kamal@email.com', '0771234567', '2022-01-15', 'Student'),
('Nimal', 'Silva', 'nimal@email.com', '0772345678', '2022-03-20', 'Staff'),
('Sunil', 'Fernando', 'sunil@email.com', '0773456789', '2023-06-10', 'Public'),
('Amara', 'Jayawardena', 'amara@email.com', '0774567890', '2022-02-28', 'Student'),
('Kumari', 'Rathnayake', 'kumari@email.com', '0775678901', '2023-01-10', 'Student'),
('Ruwan', 'Bandara', 'ruwan@email.com', '0776789012', '2021-08-15', 'Staff'),
('Dilani', 'Gunasekara', 'dilani@email.com', '0777890123', '2022-11-20', 'Student'),
('Saman', 'Wickrama', 'saman@email.com', '0778901234', '2023-04-05', 'Public'),
('Malini', 'Samarasinghe', 'malini@email.com', '0779012345', '2021-09-12', 'Staff'),
('Nuwan', 'Dissanayake', 'nuwan@email.com', '0770123456', '2023-07-25', 'Student'),
('Hashini', 'Karunaratne', 'hashini@email.com', '0771122334', '2022-05-18', 'Student'),
('Thilina', 'Kandamby', 'thilina@email.com', '0772233445', '2023-02-14', 'Public'),
('Sachini', 'Nisansala', 'sachini@email.com', '0773344556', '2022-08-22', 'Student'),
('Dimuth', 'Karunaratne', 'dimuth@email.com', '0774455667', '2021-12-01', 'Staff'),
('Oshadi', 'Ranasinghe', 'oshadi@email.com', '0775566778', '2023-09-30', 'Student');

-- ==========================================
-- INSERT DATA: books (20 records)
-- ==========================================
INSERT INTO books (Title, Author, Category, ISBN, TotalCopies, AvailableCopies) VALUES
('Database Systems', 'Ramakrishnan & Gehrke', 'Computer Science', '978-0073523323', 5, 2),
('Clean Code', 'Robert C. Martin', 'Programming', '978-0132350884', 4, 1),
('Design Patterns', 'Gang of Four', 'Programming', '978-0201633610', 3, 3),
('SQL Fundamentals', 'John Smith', 'Database', '978-1234567890', 6, 4),
('Introduction to Algorithms', 'Cormen et al.', 'Computer Science', '978-0262033848', 4, 2),
('The Pragmatic Programmer', 'Hunt & Thomas', 'Programming', '978-0135957059', 3, 2),
('Operating Systems', 'Silberschatz', 'Computer Science', '978-1118063330', 5, 3),
('Computer Networks', 'Tanenbaum', 'Networking', '978-0132126953', 4, 2),
('Artificial Intelligence', 'Russell & Norvig', 'AI/ML', '978-0136042594', 3, 1),
('Machine Learning', 'Tom Mitchell', 'AI/ML', '978-0070428072', 2, 1),
('Data Structures', 'Weiss', 'Computer Science', '978-0132576277', 5, 4),
('Web Development', 'Jon Duckett', 'Web', '978-1118008188', 4, 3),
('Python Programming', 'Mark Lutz', 'Programming', '978-1449355739', 6, 4),
('Java Complete Reference', 'Herbert Schildt', 'Programming', '978-1260440232', 5, 3),
('C Programming', 'Dennis Ritchie', 'Programming', '978-0131103627', 4, 2),
('Software Engineering', 'Ian Sommerville', 'Software', '978-0133943030', 3, 2),
('Computer Architecture', 'Patterson & Hennessy', 'Hardware', '978-0128119051', 2, 1),
('Discrete Mathematics', 'Kenneth Rosen', 'Mathematics', '978-0073383095', 4, 3),
('Linear Algebra', 'Gilbert Strang', 'Mathematics', '978-0980232714', 3, 2),
('Statistics', 'Walpole', 'Mathematics', '978-0321629111', 4, 4);

-- ==========================================
-- INSERT DATA: borrowings (30 records)
-- ==========================================
INSERT INTO borrowings (MemberID, BookID, BorrowDate, DueDate, ReturnDate, Fine) VALUES
-- Returned on time
(1, 1, '2024-10-01', '2024-10-15', '2024-10-14', 0),
(2, 2, '2024-10-05', '2024-10-19', '2024-10-18', 0),
(3, 3, '2024-10-10', '2024-10-24', '2024-10-24', 0),
(4, 4, '2024-10-12', '2024-10-26', '2024-10-25', 0),
(5, 5, '2024-10-15', '2024-10-29', '2024-10-28', 0),
-- Returned with fine (late)
(1, 6, '2024-10-20', '2024-11-03', '2024-11-10', 70),
(2, 7, '2024-10-22', '2024-11-05', '2024-11-12', 70),
(3, 8, '2024-10-25', '2024-11-08', '2024-11-15', 70),
(6, 9, '2024-11-01', '2024-11-15', '2024-11-20', 50),
(7, 10, '2024-11-05', '2024-11-19', '2024-11-25', 60),
-- Currently borrowed (not returned) - ON TIME
(8, 11, '2024-12-01', '2024-12-15', NULL, 0),
(9, 12, '2024-12-02', '2024-12-16', NULL, 0),
(10, 13, '2024-12-03', '2024-12-17', NULL, 0),
(11, 14, '2024-12-05', '2024-12-19', NULL, 0),
(12, 15, '2024-12-08', '2024-12-22', NULL, 0),
-- Currently borrowed (not returned) - OVERDUE
(1, 2, '2024-11-15', '2024-11-29', NULL, 0),
(2, 1, '2024-11-18', '2024-12-02', NULL, 0),
(3, 5, '2024-11-20', '2024-12-04', NULL, 0),
(4, 8, '2024-11-22', '2024-12-06', NULL, 0),
(5, 9, '2024-11-25', '2024-12-09', NULL, 0),
-- More historical data
(6, 1, '2024-09-01', '2024-09-15', '2024-09-14', 0),
(7, 2, '2024-09-05', '2024-09-19', '2024-09-20', 10),
(8, 3, '2024-09-10', '2024-09-24', '2024-09-24', 0),
(9, 4, '2024-09-12', '2024-09-26', '2024-09-30', 40),
(10, 5, '2024-09-15', '2024-09-29', '2024-09-28', 0),
(13, 16, '2024-12-10', '2024-12-24', NULL, 0),
(14, 17, '2024-12-11', '2024-12-25', NULL, 0),
(15, 18, '2024-12-12', '2024-12-26', NULL, 0),
(1, 19, '2024-12-13', '2024-12-27', NULL, 0),
(2, 20, '2024-12-14', '2024-12-28', NULL, 0);

-- ==========================================
-- INSERT DATA: reservations (10 records)
-- ==========================================
INSERT INTO reservations (MemberID, BookID, ReservationDate, Status) VALUES
(5, 2, '2024-12-10', 'Active'),
(6, 1, '2024-12-11', 'Active'),
(7, 9, '2024-12-12', 'Active'),
(8, 10, '2024-12-13', 'Active'),
(1, 3, '2024-11-01', 'Fulfilled'),
(2, 4, '2024-11-05', 'Fulfilled'),
(3, 5, '2024-11-10', 'Fulfilled'),
(4, 6, '2024-11-15', 'Cancelled'),
(9, 7, '2024-11-20', 'Cancelled'),
(10, 8, '2024-12-01', 'Active');

-- ==========================================
-- VERIFY DATA
-- ==========================================
SELECT 'members' AS TableName, COUNT(*) AS RecordCount FROM members
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'borrowings', COUNT(*) FROM borrowings
UNION ALL
SELECT 'reservations', COUNT(*) FROM reservations;

-- ==========================================
-- USEFUL QUERIES FOR TESTING
-- ==========================================

-- Show currently borrowed books (not returned)
-- SELECT * FROM borrowings WHERE ReturnDate IS NULL;

-- Show overdue books
-- SELECT * FROM borrowings WHERE ReturnDate IS NULL AND DueDate < CURDATE();

-- Show book availability
-- SELECT BookID, Title, TotalCopies, AvailableCopies FROM books;

-- ==========================================
-- READY FOR PRACTICE!
-- ==========================================
SELECT '✅ LibraryDB is ready! You can now practice Paper 2 questions.' AS Message;

-- ==========================================
-- ADBMS FINAL EXAM 2025 - ANSWERS
-- Database: library_management_system
-- Total: 50 Marks
-- ==========================================

-- ==========================================
-- DATABASE SETUP (Provided in Exam)
-- ==========================================

CREATE DATABASE library_management_system;
USE library_management_system;

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publisher VARCHAR(150),
    category VARCHAR(100),
    total_copies INT NOT NULL,
    available_copies INT NOT NULL
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    join_date DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    role VARCHAR(50)
);

CREATE TABLE book_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issued_by_staff_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_by_staff_id) REFERENCES staff(staff_id)
);

-- Sample Data
INSERT INTO books (title, author, isbn, publisher, category, total_copies, available_copies) VALUES
('Introduction to Algorithms', 'Thomas H. Cormen', '9780262033848', 'MIT Press', 'Computer Science', 5, 5),
('Clean Code', 'Robert C. Martin', '9780132350884', 'Prentice Hall', 'Software Engineering', 3, 3),
('Artificial Intelligence: A Modern Approach', 'Stuart Russell', '9780136042594', 'Pearson', 'AI', 4, 4),
('Database System Concepts', 'Abraham Silberschatz', '9780078022159', 'McGraw-Hill', 'Databases', 6, 6),
('Python Crash Course', 'Eric Matthes', '9781593279288', 'No Starch Press', 'Programming', 5, 5),
('Computer Networks', 'Andrew S. Tanenbaum', '9780132126953', 'Pearson', 'Networking', 2, 2);

INSERT INTO members (first_name, last_name, email, phone, address_line1, address_line2) VALUES
('Kamal', 'Perera', 'kamal.perera@gmail.com', '0712345678', 'No 12, Main Street', 'Colombo 03'),
('Nadeesha', 'Senanayake', 'nadeesha.s@gmail.com', '0771234567', '45/2, Lake Road', 'Galle'),
('Sivakumar', 'Rajendran', 'siva.r@gmail.com', '0723456789', '12, First Lane', 'Jaffna'),
('Anita', 'Kanagasabai', 'anita.k@gmail.com', '0752345678', '78, Beach Road', 'Trincomalee'),
('Mohammed', 'Hussain', 'mohammed.h@gmail.com', '0763456789', '23, Market Street', 'Kandy'),
('Aisha', 'Fathima', 'aisha.f@gmail.com', '0719876543', '89, Lakeview Road', 'Colombo 07'),
('Rohan', 'Wijesinghe', 'rohan.w@gmail.com', '0711122334', '56, Hill Street', 'Matara'),
('Tharuka', 'Fernando', 'tharuka.f@gmail.com', '0772233445', '34, Garden Road', 'Negombo'),
('Aravindan', 'Subramaniam', 'aravindan.s@gmail.com', '0725566778', '90, Temple Road', 'Jaffna'),
('Zahra', 'Rashid', 'zahra.r@gmail.com', '0769988776', '12, Palm Street', 'Colombo 05');

INSERT INTO staff (first_name, last_name, email, role) VALUES
('Ranjith', 'Fernando', 'ranjith.f@gmail.com', 'Librarian'),
('Tharshini', 'Vijayakumar', 'tharshini.v@gmail.com', 'Assistant Librarian'),
('Imran', 'Shaik', 'imran.s@gmail.com', 'Assistant Librarian');

INSERT INTO book_transactions (book_id, member_id, issued_by_staff_id, issue_date, due_date, return_date) VALUES
(1, 1, 1, '2025-11-01', '2025-11-15', '2025-11-12'),
(2, 2, 2, '2025-11-05', '2025-11-19', NULL),
(3, 3, 1, '2025-11-03', '2025-11-17', '2025-11-20'),
(4, 4, 2, '2025-11-07', '2025-11-21', NULL),
(5, 5, 1, '2025-11-10', '2025-11-24', NULL),
(6, 6, 3, '2025-11-12', '2025-11-26', '2025-11-28'),
(1, 7, 2, '2025-11-15', '2025-11-29', NULL),
(2, 8, 1, '2025-11-18', '2025-12-02', NULL),
(3, 9, 3, '2025-11-20', '2025-12-04', '2025-12-06'),
(4, 10, 2, '2025-11-22', '2025-12-06', NULL),
(5, 1, 1, '2025-11-25', '2025-12-09', NULL),
(6, 2, 3, '2025-11-28', '2025-12-12', '2025-12-11');

-- ==========================================
-- Question 1 (10 Marks): CREATE VIEW
-- ==========================================

CREATE VIEW member_borrowed_books AS
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS fullname,
    m.email AS email, 
    m.phone AS phone,
    b.title AS booktitle
FROM members m 
JOIN book_transactions bt ON m.member_id = bt.member_id
JOIN books b ON b.book_id = bt.book_id;

-- Test:
-- SELECT * FROM member_borrowed_books;

-- ==========================================
-- Question 2 (10 Marks): CREATE FUNCTION
-- ==========================================

DELIMITER //

CREATE FUNCTION calculate_fine_for_transaction(tID INT) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE fine DECIMAL(10,2);
    DECLARE difference INT;
    
    SELECT DATEDIFF(return_date, due_date) INTO difference
    FROM book_transactions
    WHERE transaction_id = tID;
    
    IF difference > 0 THEN
        SET fine = difference * 100;
    ELSE
        SET fine = 0;
    END IF;
    
    RETURN fine;
END //

DELIMITER ;

-- Test:
-- SELECT calculate_fine_for_transaction(3) AS Fine;
-- Transaction 3: returned 3 days late = Rs. 300

-- SELECT calculate_fine_for_transaction(1) AS Fine;
-- Transaction 1: returned early = Rs. 0

-- ==========================================
-- Question 3 (10 Marks): CREATE PROCEDURE (IN + OUT)
-- ==========================================

DELIMITER //

CREATE PROCEDURE get_member_borrow_count(
    IN mID INT, 
    OUT bCount INT
)
BEGIN
    SELECT COUNT(member_id) INTO bCount 
    FROM book_transactions
    WHERE member_id = mID AND return_date IS NULL;
END //

DELIMITER ;

-- Test:
-- CALL get_member_borrow_count(2, @count);
-- SELECT @count AS NotReturnedBooks;
-- Member 2 has 2 unreturned books

-- ==========================================
-- Question 4 (10 Marks): CREATE INDEX
-- ==========================================

-- Simple index on title (for search optimization)
CREATE INDEX idx_title ON books(title);

-- Alternative using ALTER TABLE:
-- ALTER TABLE books ADD INDEX idx_title (title);

-- Verify:
-- SHOW INDEX FROM books;

-- ==========================================
-- Question 5 (10 Marks): CREATE TRIGGER
-- ==========================================

DELIMITER //

CREATE TRIGGER update_available_copies_after_issue
AFTER INSERT ON book_transactions
FOR EACH ROW
BEGIN 
    UPDATE books 
    SET available_copies = available_copies - 1
    WHERE book_id = NEW.book_id;
END //

DELIMITER ;

-- Test:
-- INSERT INTO book_transactions (book_id, member_id, issued_by_staff_id, issue_date, due_date)
-- VALUES (1, 3, 1, '2025-12-16', '2025-12-30');
-- Check: SELECT available_copies FROM books WHERE book_id = 1;
-- Should be decremented by 1

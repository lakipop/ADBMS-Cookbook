-- ==========================================
-- ADBMS FINAL EXAM - SAMPLE PAPER 2 ANSWERS
-- Total Marks: 60
-- Database: LibraryDB
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Members Table
CREATE TABLE members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    MembershipDate DATE,
    MemberType VARCHAR(20)
);

-- Books Table
CREATE TABLE books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Category VARCHAR(50),
    ISBN VARCHAR(20),
    TotalCopies INT,
    AvailableCopies INT
);

-- Borrowings Table
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

-- Reservations Table
CREATE TABLE reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    ReservationDate DATE,
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (MemberID) REFERENCES members(MemberID),
    FOREIGN KEY (BookID) REFERENCES books(BookID)
);

-- Overdue Notifications Table (for Event Q10)
CREATE TABLE overdue_notifications (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    DaysOverdue INT,
    NotificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO members VALUES
(1, 'Kamal', 'Perera', 'kamal@email.com', '0771234567', '2023-01-15', 'Student'),
(2, 'Nimal', 'Silva', 'nimal@email.com', '0772345678', '2023-03-20', 'Staff'),
(3, 'Sunil', 'Fernando', 'sunil@email.com', '0773456789', '2024-06-10', 'Public');

INSERT INTO books VALUES
(1, 'Database Systems', 'Ramakrishnan', 'Computer Science', '978-0073523323', 5, 3),
(2, 'Clean Code', 'Robert Martin', 'Programming', '978-0132350884', 3, 1),
(3, 'Design Patterns', 'Gang of Four', 'Programming', '978-0201633610', 4, 4),
(4, 'SQL Fundamentals', 'John Smith', 'Database', '978-1234567890', 6, 2);

INSERT INTO borrowings VALUES
(1, 1, 1, '2024-12-01', '2024-12-15', NULL, 0),
(2, 1, 2, '2024-11-15', '2024-11-29', '2024-12-05', 60),
(3, 2, 1, '2024-12-05', '2024-12-19', NULL, 0),
(4, 3, 4, '2024-11-20', '2024-12-04', NULL, 0);

-- ==========================================
-- SECTION A: VIEWS
-- ==========================================

-- ==========================================
-- Question 1 (6 Marks): vw_CurrentBorrowings
-- ==========================================

CREATE VIEW vw_CurrentBorrowings AS
SELECT 
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    m.MemberType,
    b.Title,
    b.Author,
    br.BorrowDate,
    br.DueDate
FROM members m
JOIN borrowings br ON m.MemberID = br.MemberID
JOIN books b ON br.BookID = b.BookID
WHERE br.ReturnDate IS NULL;

-- Test: SELECT * FROM vw_CurrentBorrowings;

-- ==========================================
-- Question 2 (6 Marks): vw_BookStatistics
-- ==========================================

CREATE VIEW vw_BookStatistics AS
SELECT 
    b.BookID,
    b.Title,
    COUNT(br.BorrowID) AS TotalTimesBorrowed,
    COALESCE(SUM(br.Fine), 0) AS TotalFineCollected,
    b.AvailableCopies
FROM books b
LEFT JOIN borrowings br ON b.BookID = br.BookID
GROUP BY b.BookID, b.Title, b.AvailableCopies
ORDER BY TotalTimesBorrowed DESC;

-- Test: SELECT * FROM vw_BookStatistics;

-- ==========================================
-- SECTION B: USER-DEFINED FUNCTIONS
-- ==========================================

-- ==========================================
-- Question 3 (6 Marks): fn_CalculateFine
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_CalculateFine(p_BorrowID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE calculated_fine DECIMAL(10,2);
    DECLARE v_DueDate DATE;
    DECLARE v_ReturnDate DATE;
    DECLARE overdue_days INT;
    
    SELECT DueDate, ReturnDate INTO v_DueDate, v_ReturnDate
    FROM borrowings
    WHERE BorrowID = p_BorrowID;
    
    -- If already returned, calculate based on return date
    IF v_ReturnDate IS NOT NULL THEN
        SET overdue_days = DATEDIFF(v_ReturnDate, v_DueDate);
    ELSE
        -- If not returned, calculate based on current date
        SET overdue_days = DATEDIFF(CURDATE(), v_DueDate);
    END IF;
    
    -- Fine only if overdue
    IF overdue_days > 0 THEN
        SET calculated_fine = overdue_days * 10;
    ELSE
        SET calculated_fine = 0;
    END IF;
    
    RETURN calculated_fine;
END //

DELIMITER ;

--simple version
DELIMITER //

CREATE FUNCTION fn_CalculateFine(p_BorrowID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_DueDate DATE;
    DECLARE fine DECIMAL(10,2);
    
    -- Get due date
    SELECT DueDate INTO v_DueDate
    FROM borrowings WHERE BorrowID = p_BorrowID;
    
    -- Check if overdue
    IF CURDATE() > v_DueDate THEN
        SET fine = DATEDIFF(CURDATE(), v_DueDate) * 10;
    ELSE
        SET fine = 0;
    END IF;
    
    RETURN fine;
END //

DELIMITER ;
-- Test: SELECT fn_CalculateFine(4) AS Fine;

-- ==========================================
-- Question 4 (6 Marks): fn_GetMemberBorrowCount
-- ==========================================

DELIMITER //

CREATE FUNCTION fn_GetMemberBorrowCount(p_MemberID INT, p_Year INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE borrow_count INT;
    
    SELECT COUNT(*) INTO borrow_count
    FROM borrowings
    WHERE MemberID = p_MemberID
      AND YEAR(BorrowDate) = p_Year;
    
    RETURN borrow_count;
END //

DELIMITER ;

-- Test: SELECT fn_GetMemberBorrowCount(1, 2024) AS BorrowCount;

-- ==========================================
-- SECTION C: STORED PROCEDURES
-- ==========================================

-- ==========================================
-- Question 5 (6 Marks): sp_BorrowBook
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_BorrowBook(
    IN p_MemberID INT,
    IN p_BookID INT
)
BEGIN
    DECLARE v_Available INT;
    
    SELECT AvailableCopies INTO v_Available
    FROM books WHERE BookID = p_BookID;
    
    IF v_Available > 0 THEN
        -- Insert borrowing record
        INSERT INTO borrowings (MemberID, BookID, BorrowDate, DueDate)
        VALUES (p_MemberID, p_BookID, CURDATE(), CURDATE() + INTERVAL 14 DAY);
        
        -- Decrement available copies
        UPDATE books SET AvailableCopies = AvailableCopies - 1
        WHERE BookID = p_BookID;
        
        SELECT 'SUCCESS: Book borrowed successfully' AS Message;
    ELSE
        SELECT 'Book not available' AS Message;
    END IF;
END //

DELIMITER ;

-- Test: CALL sp_BorrowBook(2, 3);

-- ==========================================
-- Question 6 (6 Marks): sp_ReturnBook
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_ReturnBook(
    IN p_BorrowID INT,
    OUT p_Fine DECIMAL(10,2)
)
BEGIN
    DECLARE v_DueDate DATE;
    DECLARE v_BookID INT;
    DECLARE overdue_days INT;
    
    -- Get due date and book ID
    SELECT DueDate, BookID INTO v_DueDate, v_BookID
    FROM borrowings WHERE BorrowID = p_BorrowID;
    
    -- Calculate overdue days
    SET overdue_days = DATEDIFF(CURDATE(), v_DueDate);
    
    -- Calculate fine (Rs. 10 per day if overdue)
    IF overdue_days > 0 THEN
        SET p_Fine = overdue_days * 10;
    ELSE
        SET p_Fine = 0;
    END IF;
    
    -- Update borrowing record
    UPDATE borrowings 
    SET ReturnDate = CURDATE(), Fine = p_Fine
    WHERE BorrowID = p_BorrowID;
    
    -- Increment available copies
    UPDATE books SET AvailableCopies = AvailableCopies + 1
    WHERE BookID = v_BookID;
END //

DELIMITER ;

-- Test:
-- CALL sp_ReturnBook(1, @fine);
-- SELECT @fine AS FineAmount;

-- ==========================================
-- Question 7 (6 Marks): sp_GetOverdueBooks
-- ==========================================

DELIMITER //

CREATE PROCEDURE sp_GetOverdueBooks()
BEGIN
    SELECT 
        CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
        m.Phone,
        b.Title,
        br.DueDate,
        DATEDIFF(CURDATE(), br.DueDate) AS DaysOverdue
    FROM borrowings br
    JOIN members m ON br.MemberID = m.MemberID
    JOIN books b ON br.BookID = b.BookID
    WHERE br.ReturnDate IS NULL
      AND br.DueDate < CURDATE()
    ORDER BY DaysOverdue DESC;
END //

DELIMITER ;

-- Test: CALL sp_GetOverdueBooks();

-- ==========================================
-- SECTION D: TRIGGERS
-- ==========================================

-- ==========================================
-- Question 8 (6 Marks): trg_UpdateAvailability
-- ==========================================

DELIMITER //

CREATE TRIGGER trg_UpdateAvailability
AFTER INSERT ON borrowings
FOR EACH ROW
BEGIN
    UPDATE books 
    SET AvailableCopies = AvailableCopies - 1
    WHERE BookID = NEW.BookID;
END //

DELIMITER ;

-- Note: If using sp_BorrowBook which already decrements, 
-- you may want to remove the decrement from the SP to avoid double decrement

-- ==========================================
-- Question 9 (6 Marks): trg_PreventOverBorrow
-- ==========================================

DELIMITER //

CREATE TRIGGER trg_PreventOverBorrow
BEFORE INSERT ON borrowings
FOR EACH ROW
BEGIN
    DECLARE current_borrowed INT;
    
    SELECT COUNT(*) INTO current_borrowed
    FROM borrowings
    WHERE MemberID = NEW.MemberID AND ReturnDate IS NULL;
    
    IF current_borrowed >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Member has reached maximum borrowing limit';
    END IF;
END //

DELIMITER ;

-- Test: Will raise error if member already has 5 unreturned books

-- ==========================================
-- SECTION E: EVENTS
-- ==========================================

-- ==========================================
-- Question 10 (6 Marks): evt_SendOverdueReminder
-- ==========================================

SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT evt_SendOverdueReminder
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 8 HOUR)
DO
BEGIN
    INSERT INTO overdue_notifications (MemberID, BookID, DaysOverdue)
    SELECT 
        br.MemberID,
        br.BookID,
        DATEDIFF(CURDATE(), br.DueDate)
    FROM borrowings br
    WHERE br.ReturnDate IS NULL
      AND br.DueDate < CURDATE();
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
LEFTMOST PREFIX RULE:

For a composite index on columns (A, B, C), the index can be used for 
queries that filter by:
- A only ✓
- A and B ✓
- A, B, and C ✓

The index CANNOT be used efficiently for:
- B only ✗
- C only ✗
- B and C (without A) ✗

EXAMPLE:
Index: CREATE INDEX idx_abc ON table1(A, B, C);

WILL USE INDEX:
- WHERE A = 1
- WHERE A = 1 AND B = 2
- WHERE A = 1 AND B = 2 AND C = 3

WILL NOT USE INDEX:
- WHERE B = 2 (A is missing)
- WHERE C = 3 (A and B are missing)
- WHERE B = 2 AND C = 3 (A is missing)

This is because the index is organized by A first, then B within A, 
then C within A,B. Skipping the leftmost column breaks the sort order.
*/

-- ==========================================
-- Question 12 (3 Marks): Index Creation
-- ==========================================

-- Unique index on ISBN
CREATE UNIQUE INDEX idx_unique_isbn ON books(ISBN);

-- Composite index on MemberID and BorrowDate
CREATE INDEX idx_borrowing_search ON borrowings(MemberID, BorrowDate);

-- Verify indexes
SHOW INDEX FROM books;
SHOW INDEX FROM borrowings;

-- Test with EXPLAIN
EXPLAIN SELECT * FROM borrowings WHERE MemberID = 1;

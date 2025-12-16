-- ==========================================
-- PRACTICAL 15: MySQL Events - ANSWERS
-- 10 Questions at Different Levels
-- ==========================================

-- ==========================================
-- SETUP: Create Database and Tables
-- ==========================================

CREATE DATABASE IF NOT EXISTS EventsPractice;
USE EventsPractice;

-- Backup log table
CREATE TABLE backup_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    backup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    message VARCHAR(100)
);

-- Heartbeat table
CREATE TABLE heartbeat (
    id INT PRIMARY KEY AUTO_INCREMENT,
    beat_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Activity log table
CREATE TABLE activity_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    activity VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    total_amount DECIMAL(10,2),
    order_date DATE
);

-- Weekly reports table
CREATE TABLE weekly_reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    week_ending DATE,
    total_orders INT,
    total_revenue DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Promotions table
CREATE TABLE promotions (
    promo_id INT PRIMARY KEY,
    promo_name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    active INT DEFAULT 0
);

-- Orders archive table
CREATE TABLE orders_archive (
    order_id INT,
    customer_name VARCHAR(50),
    total_amount DECIMAL(10,2),
    order_date DATE,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- Question 1: Enable Event Scheduler
-- ==========================================

-- a) Check if event scheduler is running
SHOW VARIABLES LIKE 'event_scheduler';

-- b) Enable the event scheduler
SET GLOBAL event_scheduler = ON;

-- Verify it's ON
SHOW VARIABLES LIKE 'event_scheduler';

-- c) Check current user's EVENT privileges
SHOW GRANTS FOR CURRENT_USER();

-- ==========================================
-- Question 2: One-Time Event
-- Runs once, 1 minute from now
-- ==========================================

DELIMITER //

CREATE EVENT evt_one_time_backup
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO
BEGIN
    INSERT INTO backup_log (message)
    VALUES ('One-time backup completed');
END //

DELIMITER ;

-- ==========================================
-- Question 3: Simple Recurring Event
-- Runs every 1 minute
-- ==========================================

DELIMITER //

CREATE EVENT evt_every_minute
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO heartbeat (beat_time) VALUES (NOW());
END //

DELIMITER ;

-- ==========================================
-- Question 4: Daily Cleanup Event
-- Runs every day at midnight
-- ==========================================

DELIMITER //

CREATE EVENT evt_daily_cleanup
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY)
DO
BEGIN
    DELETE FROM activity_log
    WHERE created_at < NOW() - INTERVAL 30 DAY;
END //

DELIMITER ;

-- ==========================================
-- Question 5: Weekly Report Event
-- Runs every Sunday at 11:00 PM
-- ==========================================

DELIMITER //

CREATE EVENT evt_weekly_summary
ON SCHEDULE EVERY 1 WEEK
STARTS (TIMESTAMP(CURRENT_DATE + INTERVAL (6 - WEEKDAY(CURRENT_DATE)) DAY, '23:00:00'))
DO
BEGIN
    INSERT INTO weekly_reports (week_ending, total_orders, total_revenue)
    SELECT 
        CURDATE(),
        COUNT(*),
        COALESCE(SUM(total_amount), 0)
    FROM orders
    WHERE order_date >= CURDATE() - INTERVAL 7 DAY;
END //

DELIMITER ;

-- ==========================================
-- Question 6: Event with Start and End Time
-- Runs hourly for 7 days
-- ==========================================

DELIMITER //

CREATE EVENT evt_promo_period
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 7 DAY
DO
BEGIN
    UPDATE promotions
    SET active = 1
    WHERE CURDATE() BETWEEN start_date AND end_date;
    
    UPDATE promotions
    SET active = 0
    WHERE CURDATE() NOT BETWEEN start_date AND end_date;
END //

DELIMITER ;

-- ==========================================
-- Question 7: Show and Manage Events
-- ==========================================

-- a) Show all events in current database
SHOW EVENTS FROM EventsPractice;

-- b) Show events matching pattern
SHOW EVENTS FROM EventsPractice LIKE 'evt_%';

-- c) Disable an event
ALTER EVENT evt_every_minute DISABLE;

-- d) Enable it back
ALTER EVENT evt_every_minute ENABLE;

-- ==========================================
-- Question 8: Alter Event Schedule
-- ==========================================

-- a) Change to run every 12 hours
-- b) Add a comment
ALTER EVENT evt_daily_cleanup
ON SCHEDULE EVERY 12 HOUR
COMMENT 'Cleanup old activity logs';

-- Verify the change
SHOW CREATE EVENT evt_daily_cleanup;

-- ==========================================
-- Question 9: ON COMPLETION PRESERVE
-- Monthly archive event
-- ==========================================

DELIMITER //

CREATE EVENT evt_monthly_archive
ON SCHEDULE EVERY 1 MONTH
STARTS (TIMESTAMP(DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')) + INTERVAL 1 MONTH + INTERVAL 2 HOUR)
ON COMPLETION PRESERVE
DO
BEGIN
    -- Archive previous month's orders
    INSERT INTO orders_archive (order_id, customer_name, total_amount, order_date)
    SELECT order_id, customer_name, total_amount, order_date
    FROM orders
    WHERE MONTH(order_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
      AND YEAR(order_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH);
    
    -- Optional: Delete archived records from main table
    -- DELETE FROM orders
    -- WHERE MONTH(order_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);
END //

DELIMITER ;

-- ==========================================
-- Question 10: Drop Events
-- ==========================================

-- a) Drop specific event
DROP EVENT IF EXISTS evt_one_time_backup;

-- b) Drop multiple events (need to do one by one in MySQL)
DROP EVENT IF EXISTS evt_test_1;
DROP EVENT IF EXISTS evt_test_2;
DROP EVENT IF EXISTS evt_test_3;

-- Verify events are dropped
SHOW EVENTS FROM EventsPractice;

-- ==========================================
-- Useful Commands Summary
-- ==========================================

-- Show all events
-- SHOW EVENTS;

-- Show event details
-- SHOW CREATE EVENT event_name;

-- Enable/Disable event scheduler globally
-- SET GLOBAL event_scheduler = ON;
-- SET GLOBAL event_scheduler = OFF;

-- Enable/Disable specific event
-- ALTER EVENT event_name ENABLE;
-- ALTER EVENT event_name DISABLE;

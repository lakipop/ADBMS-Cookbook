-- ==========================================
-- PRACTICAL 16: MySQL Events - Southern Tyes
-- Index: TG-2021-1010
-- ==========================================

-- ==========================================
-- Question 1: Low Stock Alert Event
-- ==========================================

-- Step 1: Create the tstok table
CREATE TABLE `southern tyes`.`tstok` (
  `Tier_type` VARCHAR(255) NOT NULL,
  `Total_Quntity` INT NULL,
  `last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Tier_type`)
)
ENGINE = InnoDB;

-- Step 2: Create stock alert table
CREATE TABLE `southern tyes`.`stock_alet` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `tire type` VARCHAR(255),
  `quntity` INT,
  `alert_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Use the database
USE `southern tyes`;

-- Step 4: Check event scheduler status
SHOW VARIABLES LIKE 'event_scheduler';

-- Step 5: Enable event scheduler
SET GLOBAL event_scheduler = ON;

-- Step 6: Verify it's enabled
SHOW VARIABLES LIKE 'event_scheduler';

-- Step 7: Check user privileges
SHOW GRANTS FOR CURRENT_USER();

-- Step 8: Create the low stock alert event
CREATE EVENT log_low_stock 
ON SCHEDULE EVERY 30 SECOND
STARTS CURRENT_TIMESTAMP
DO
    INSERT INTO `southern tyes`.`stock_alet` (`tire type`, `quntity`)
    SELECT `Tier_type`, `Total_Quntity` 
    FROM `southern tyes`.`tstok` 
    WHERE `Total_Quntity` < 30;

-- Step 9: Verify the event was created
SHOW EVENTS FROM `southern tyes`;

-- ==========================================
-- Insert sample data to test
-- ==========================================

INSERT INTO `southern tyes`.`tstok` (`Tier_type`, `Total_Quntity`) VALUES
('195/65R15', 25),    -- Low stock - will trigger alert
('205/55R16', 50),    -- OK
('215/60R16', 15),    -- Low stock - will trigger alert
('225/45R17', 100),   -- OK
('235/40R18', 28);    -- Low stock - will trigger alert

-- ==========================================
-- Question 2: Auto-Cancel Pending Orders Event
-- ==========================================

-- Step 1: Create the online orders table
CREATE TABLE `southern tyes`.`online orders` (
  `Order_ID` INT NOT NULL AUTO_INCREMENT,
  `Customer Name` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `order_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Order_ID`)
);

-- Step 2: Create the auto-cancel event
CREATE EVENT cancel_uncomformd_orders
ON SCHEDULE EVERY 10 SECOND
STARTS CURRENT_TIMESTAMP
DO 
    UPDATE `southern tyes`.`online orders` 
    SET `status` = 'Cancel' 
    WHERE `status` = 'Pending' 
      AND `order_time` < NOW() - INTERVAL 2 MINUTE;

-- Step 3: Verify the event was created
SHOW EVENTS FROM `southern tyes`;

-- ==========================================
-- Insert sample data to test
-- ==========================================

-- Insert a pending order (will be cancelled after 2 minutes)
INSERT INTO `southern tyes`.`online orders` (`Customer Name`, `status`) 
VALUES ('John Silva', 'Pending');

-- Insert an older pending order (should be cancelled immediately)
INSERT INTO `southern tyes`.`online orders` (`Customer Name`, `status`, `order_time`) 
VALUES ('Kamal Perera', 'Pending', NOW() - INTERVAL 5 MINUTE);

-- Insert a completed order (should NOT be affected)
INSERT INTO `southern tyes`.`online orders` (`Customer Name`, `status`) 
VALUES ('Nimal Fernando', 'Completed');

-- ==========================================
-- Verify Results
-- ==========================================

-- Check stock alerts
SELECT * FROM `southern tyes`.`stock_alet`;

-- Check orders status
SELECT * FROM `southern tyes`.`online orders`;

-- ==========================================
-- Cleanup (Optional)
-- ==========================================

-- Disable events
-- ALTER EVENT log_low_stock DISABLE;
-- ALTER EVENT cancel_uncomformd_orders DISABLE;

-- Drop events
-- DROP EVENT IF EXISTS log_low_stock;
-- DROP EVENT IF EXISTS cancel_uncomformd_orders;

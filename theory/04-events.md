# 📖 MySQL Events - Theory Notes

> **Topics:** Scheduled Tasks, Event Scheduler, ONE-TIME vs RECURRING Events

---

## 🤔 What is an Event?

A MySQL **Event** is a scheduled task that runs automatically at specific times - like a cron job inside the database.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Alarm Clock = Wakes you up at scheduled time              │
│   MySQL Event = Runs SQL at scheduled time                  │
│                                                             │
│   "Every day at 8 AM, clean old records"                    │
└─────────────────────────────────────────────────────────────┘
```

### Real-World Use Cases:
- 🗑️ Delete old logs daily
- 📊 Generate reports weekly
- 💰 Calculate interest monthly
- 🔔 Send reminder notifications
- 🔄 Archive old data periodically

---

## ⚡ Enabling Event Scheduler

Before creating events, enable the scheduler:

```sql
-- Check current status
SHOW VARIABLES LIKE 'event_scheduler';

-- Enable scheduler
SET GLOBAL event_scheduler = ON;

-- Or in my.cnf/my.ini:
-- [mysqld]
-- event_scheduler=ON
```

---

## 📝 Types of Events

### 1. One-Time Event
Runs **once** at a specific time, then disappears.

```sql
CREATE EVENT evt_OneTime
ON SCHEDULE AT '2025-12-31 23:59:59'
DO
BEGIN
    INSERT INTO logs (message, created_at)
    VALUES ('Happy New Year!', NOW());
END;
```

### 2. Recurring Event
Runs **repeatedly** at intervals.

```sql
CREATE EVENT evt_Daily
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM sessions WHERE created_at < NOW() - INTERVAL 7 DAY;
END;
```

---

## 🔨 Creating Events - Syntax

### Basic Syntax
```sql
CREATE EVENT event_name
ON SCHEDULE schedule
DO
    event_body;
```

### Full Syntax
```sql
CREATE EVENT [IF NOT EXISTS] event_name
ON SCHEDULE schedule
[ON COMPLETION [NOT] PRESERVE]
[ENABLE | DISABLE]
[COMMENT 'description']
DO
    event_body;
```

---

## ⏰ Schedule Options

### One-Time (AT)
```sql
-- At specific datetime
AT '2025-12-31 23:59:59'

-- After interval from now
AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR

-- Today at specific time
AT TIMESTAMP(CURRENT_DATE) + INTERVAL 8 HOUR
```

### Recurring (EVERY)
```sql
-- Every hour
EVERY 1 HOUR

-- Every day
EVERY 1 DAY

-- Every week
EVERY 1 WEEK

-- Every month
EVERY 1 MONTH
```

### With STARTS and ENDS
```sql
-- Start tomorrow, run every day, end in 30 days
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
ENDS CURRENT_TIMESTAMP + INTERVAL 30 DAY
```

---

## 📊 INTERVAL Units

| Unit | Example |
|------|---------|
| `SECOND` | `INTERVAL 30 SECOND` |
| `MINUTE` | `INTERVAL 5 MINUTE` |
| `HOUR` | `INTERVAL 2 HOUR` |
| `DAY` | `INTERVAL 1 DAY` |
| `WEEK` | `INTERVAL 1 WEEK` |
| `MONTH` | `INTERVAL 1 MONTH` |
| `YEAR` | `INTERVAL 1 YEAR` |

---

## 🔧 Event Options

### ON COMPLETION PRESERVE
By default, events are deleted after execution (for one-time) or after ENDS (for recurring).

```sql
-- Keep event definition after completion
ON COMPLETION PRESERVE

-- Delete event after completion (default)
ON COMPLETION NOT PRESERVE
```

### ENABLE / DISABLE
```sql
-- Create but don't run yet
CREATE EVENT evt_name
ON SCHEDULE EVERY 1 DAY
DISABLE
DO ...;

-- Enable later
ALTER EVENT evt_name ENABLE;
```

---

## 📝 Complete Examples

### Example 1: Daily Cleanup
```sql
DELIMITER //

CREATE EVENT evt_DailyCleanup
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 2 HOUR)  -- 2 AM daily
COMMENT 'Remove old sessions daily'
DO
BEGIN
    DELETE FROM sessions 
    WHERE last_activity < NOW() - INTERVAL 30 DAY;
END //

DELIMITER ;
```

### Example 2: Weekly Report
```sql
DELIMITER //

CREATE EVENT evt_WeeklyBackup
ON SCHEDULE EVERY 1 WEEK
STARTS '2025-12-22 00:00:00'  -- Next Sunday midnight
DO
BEGIN
    INSERT INTO weekly_stats (week_start, total_orders, total_revenue)
    SELECT 
        DATE_SUB(CURDATE(), INTERVAL 7 DAY),
        COUNT(*),
        SUM(amount)
    FROM orders
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);
END //

DELIMITER ;
```

### Example 3: One-Time Reminder
```sql
CREATE EVENT evt_BirthdayReminder
ON SCHEDULE AT '2025-12-25 09:00:00'
ON COMPLETION PRESERVE  -- Keep after execution
DO
    INSERT INTO notifications (user_id, message)
    VALUES (1, 'Merry Christmas!');
```

### Example 4: Auto-Cancel Pending Orders
```sql
DELIMITER //

CREATE EVENT evt_CancelOldOrders
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE orders
    SET status = 'Cancelled'
    WHERE status = 'Pending'
      AND created_at < NOW() - INTERVAL 24 HOUR;
END //

DELIMITER ;
```

---

## 🔄 Managing Events

### View All Events
```sql
SHOW EVENTS;
SHOW EVENTS FROM database_name;
```

### View Event Definition
```sql
SHOW CREATE EVENT event_name;
```

### Modify Event
```sql
-- Change schedule
ALTER EVENT event_name
ON SCHEDULE EVERY 2 HOUR;

-- Enable/Disable
ALTER EVENT event_name ENABLE;
ALTER EVENT event_name DISABLE;

-- Rename
ALTER EVENT old_name RENAME TO new_name;
```

### Delete Event
```sql
DROP EVENT IF EXISTS event_name;
```

---

## ⚠️ Important Notes

1. **Scheduler must be ON** - Events won't run otherwise
2. **Server restart** - Events may need re-enabling
3. **Privileges** - Need EVENT privilege to create
4. **Time zone** - Uses server time zone
5. **Missed events** - Won't run if server was down

---

## 📝 Common Exam Questions

### Q1: What is a MySQL Event?
**Answer:** An event is a scheduled task that runs SQL statements automatically at specified times, similar to a cron job in the database.

### Q2: How do you enable the event scheduler?
**Answer:** `SET GLOBAL event_scheduler = ON;`

### Q3: Difference between AT and EVERY?
**Answer:**
- **AT:** One-time execution at specific datetime
- **EVERY:** Recurring execution at intervals

### Q4: What does ON COMPLETION PRESERVE do?
**Answer:** Keeps the event definition after it completes. Without it, one-time events are deleted after execution.

### Q5: Create an event that runs every day at 8 AM
**Answer:**
```sql
CREATE EVENT evt_Morning
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 8 HOUR)
DO
    -- your SQL here;
```

---

## ✅ Quick Reference

```sql
-- Enable scheduler
SET GLOBAL event_scheduler = ON;

-- One-time event
CREATE EVENT evt_name
ON SCHEDULE AT '2025-12-31 23:59:59'
DO statement;

-- Recurring event
CREATE EVENT evt_name
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO statement;

-- View events
SHOW EVENTS;

-- Modify event
ALTER EVENT evt_name DISABLE;
ALTER EVENT evt_name ENABLE;

-- Delete event
DROP EVENT IF EXISTS evt_name;
```

# Practical: MySQL Events (10 Questions)

> **Category:** Lab/Practical Instructions  
> **Topics:** Event Scheduler, Scheduled Tasks, Event Management, Automation

---

## 📋 Prerequisites

Before starting, ensure the event scheduler is enabled:
```sql
-- Check status
SHOW VARIABLES LIKE 'event_scheduler';

-- Enable if OFF
SET GLOBAL event_scheduler = ON;
```

---

## 🎯 Practice Questions

### Level 1: Basic Events

---

### Question 1: Enable Event Scheduler
**Task:** 
a) Check if the event scheduler is running
b) Enable the event scheduler if it's OFF
c) Verify your current user has EVENT privileges

```sql
-- Your answer here

```

---

### Question 2: One-Time Event
**Task:** Create an event called `evt_one_time_backup` that runs ONCE, 1 minute from now, and inserts a record into a backup_log table with current timestamp.

```sql
-- Your answer here

```

---

### Question 3: Simple Recurring Event
**Task:** Create an event called `evt_every_minute` that runs every 1 minute and inserts the current timestamp into a `heartbeat` table.

```sql
-- Your answer here

```

---

### Level 2: Scheduled Events

---

### Question 4: Daily Cleanup Event
**Task:** Create an event called `evt_daily_cleanup` that runs every day at midnight (00:00:00) and deletes records older than 30 days from an `activity_log` table.

```sql
-- Your answer here

```

---

### Question 5: Weekly Report Event
**Task:** Create an event called `evt_weekly_summary` that runs every Sunday at 11:00 PM and inserts a weekly summary (total orders, total revenue) into a `weekly_reports` table.

```sql
-- Your answer here

```

---

### Question 6: Event with Start and End Time
**Task:** Create an event called `evt_promo_period` that runs every hour, starts now, and ends after 7 days. It should update a `promotions` table to set active = 1 for current promotions.

```sql
-- Your answer here

```

---

### Level 3: Event Management

---

### Question 7: Show and Manage Events
**Task:** 
a) Show all events in the current database
b) Show events matching a pattern 'evt_%'
c) Disable an event called `evt_every_minute`
d) Enable it back

```sql
-- Your answer here

```

---

### Question 8: Alter Event Schedule
**Task:** Modify the event `evt_daily_cleanup` to:
a) Run every 12 hours instead of daily
b) Add a comment "Cleanup old activity logs"

```sql
-- Your answer here

```

---

### Level 4: Advanced Events

---

### Question 9: Event with ON COMPLETION PRESERVE
**Task:** Create an event called `evt_monthly_archive` that:
- Runs on the 1st of every month at 2:00 AM
- Archives data from `orders` to `orders_archive` for previous month
- Preserves the event after completion (doesn't auto-drop)

```sql
-- Your answer here

```

---

### Question 10: Drop Events
**Task:** 
a) Drop the event `evt_one_time_backup`
b) Drop all events that start with 'evt_test_' (if they exist)

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Q1: Enable/Check Event Scheduler
- [ ] Q2: One-Time Event
- [ ] Q3: Simple Recurring Event (every minute)
- [ ] Q4: Daily Cleanup Event
- [ ] Q5: Weekly Report Event
- [ ] Q6: Event with Start/End Time
- [ ] Q7: Show/Disable/Enable Events
- [ ] Q8: Alter Event Schedule
- [ ] Q9: ON COMPLETION PRESERVE
- [ ] Q10: Drop Events

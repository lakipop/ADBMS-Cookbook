# MySQL Events - Theory

> **Category:** Lecture Slides (Theory)  
> **Topics:** Scheduled Events, Event Scheduler, Automation

---

## 📚 What are MySQL Events?

**Definition:** MySQL events (scheduled events) are tasks executed according to a specified schedule.

- Similar to **cron jobs** on Linux or **task schedulers** on Windows
- Automates recurring tasks within the MySQL server
- Known as **"temporal triggers"** - triggered by time, not table changes
- Uses an **event scheduler thread** to monitor and execute events

**Example:** Optimizing all tables in a database at 1:00 AM every Sunday.

---

## 🔄 Event Lifecycle

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Creation   │ ──► │ Activation  │ ──► │ Modification│
│ CREATE EVENT│     │   ENABLE    │     │ ALTER EVENT │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                    ┌─────────────┐     ┌──────▼──────┐
                    │  Removal    │ ◄── │Deactivation │
                    │ DROP EVENT  │     │   DISABLE   │
                    └─────────────┘     └─────────────┘
```

| Stage | Description |
|-------|-------------|
| **Creation** | Use `CREATE EVENT` statement |
| **Activation** | Enabled by default, or use `ALTER EVENT ... ENABLE` |
| **Modification** | Use `ALTER EVENT` to change schedule/SQL |
| **Deactivation** | Stop using `ALTER EVENT ... DISABLE` |
| **Removal** | Remove using `DROP EVENT` |

---

## ⚙️ Event Scheduler Management

```sql
-- Check scheduler status
SHOW PROCESSLIST;

-- Enable scheduler
SET GLOBAL event_scheduler = ON;

-- Disable scheduler
SET GLOBAL event_scheduler = OFF;
```

---

## 🎯 Use Cases

| Use Case | Description |
|----------|-------------|
| **Data Backup** | Automate regular backups for safety |
| **Data Purging** | Remove outdated data, optimize performance |
| **Reporting** | Generate periodic reports during off-peak hours |
| **Maintenance** | Automate index rebuilding or table optimization |

---

## 📝 Syntax

### Create Event
```sql
CREATE EVENT [IF NOT EXISTS] event_name
ON SCHEDULE schedule
DO event_body;
```

### Alter Event
```sql
ALTER EVENT [IF EXISTS] event_name
ON SCHEDULE schedule
[ON COMPLETION [NOT] PRESERVE]
[COMMENT 'comment']
[ENABLE | DISABLE]
DO event_body;
```

### Drop Event
```sql
DROP EVENT [IF EXISTS] event_name;
```

### Show Events
```sql
SHOW EVENTS [FROM db_name] [LIKE 'pattern' | WHERE expr];
```

---

## 📅 Schedule Examples

```sql
-- Run once at specific time
ON SCHEDULE AT '2024-01-01 00:00:00'

-- Run every day
ON SCHEDULE EVERY 1 DAY

-- Run every Sunday at 1 AM
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-07 01:00:00'

-- Run every hour for one month
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 MONTH
```

---

## 🎯 Practice Questions

### Q1: What is a MySQL Event?
```
Answer:

```

### Q2: Events vs Triggers difference?
```
Answer:

```

### Q3: How to enable event scheduler?
```
Answer:

```

### Q4: List 3 use cases for events
```
Answer:

```

---

## ✅ Checklist
- [ ] Understand event definition
- [ ] Know event lifecycle stages
- [ ] Manage event scheduler (ON/OFF)
- [ ] Know CREATE/ALTER/DROP syntax
- [ ] Understand schedule options
- [ ] Know use cases

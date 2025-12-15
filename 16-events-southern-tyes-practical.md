# Practical: MySQL Events - Southern Tyes (TG-2021-1010)

> **Category:** Lab/Practical Instructions  
> **Topics:** Event Scheduler, Stock Alerts, Order Management, Real-World Scenarios

---

## 📋 Database: Southern Tyes

A tire shop management system with stock monitoring and order automation.

---

## 🎯 Practice Questions

### Question 1: Low Stock Alert Event

**Scenario:** Southern Tyes wants to automatically monitor tire stock levels every 30 seconds. When any tire type has quantity below 30, it should be logged to a stock alert table.

**Tables Required:**
- `tstok` - Stores tire stock (Tier_type, Total_Quntity, last_update)
- `stock_alet` - Stores low stock alerts (tire type, quantity)

**Tasks:**
1. Create the `tstok` table with Tier_type as PRIMARY KEY
2. Enable the event scheduler
3. Verify event scheduler status and user privileges
4. Create an event `log_low_stock` that runs every 30 seconds and logs low stock items

```sql
-- Your answer here

```

---

### Question 2: Auto-Cancel Pending Orders Event

**Scenario:** Online orders that remain in "Pending" status for more than 2 minutes should be automatically cancelled.

**Table Required:**
- `online orders` - Stores online orders (Order_ID, Customer Name, status, order_time)

**Tasks:**
1. Create the `online orders` table with auto-increment Order_ID
2. Create an event `cancel_uncomformd_orders` that runs every 10 seconds
3. The event should update status to 'Cancel' for orders that are 'Pending' and older than 2 minutes
4. Show all events to verify

```sql
-- Your answer here

```

---

## ✅ Checklist
- [ ] Q1: Create tstok table
- [ ] Q1: Enable event scheduler
- [ ] Q1: Create log_low_stock event
- [ ] Q2: Create online orders table
- [ ] Q2: Create cancel_uncomformd_orders event
- [ ] Q2: Verify events with SHOW EVENTS

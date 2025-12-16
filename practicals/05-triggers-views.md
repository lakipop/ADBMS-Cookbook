# Practical 07: Triggers & Views

> **Category:** Lab/Practical Instructions  
> **Topics:** Triggers (BEFORE/AFTER), Views, Audit Trails

---

## 🎯 Part A: Trigger Questions

### Question 1: Auto-Add Marks Trigger

**Table:** `Student` (Student_id, Name, Address, Marks)

**Task:** Create a trigger to add 100 marks to the Marks column whenever a new student is inserted.

```sql
-- Your answer here

```

---

### Question 2: Auto-Calculate Total & Average

**Database:** `Student_marks` (from LMS - assessment table)

**Task:** Write a trigger that automatically calculates and updates the total and average marks for a student each time a new record is inserted into the assessment table.

```sql
-- Your answer here

```

---

### Question 3: Calculate Total & Percentage

**Table:** `Student_Trigger`
| Field | Description |
|-------|-------------|
| Student_RollNo | Roll Number |
| Student_FirstName | First Name |
| Student_EnglishMarks | English Marks |
| Student_PhysicsMarks | Physics Marks |
| Student_ChemistryMarks | Chemistry Marks |
| Student_MathsMarks | Maths Marks |
| Student_TotalMarks | Total Marks |
| Student_Percentage | Percentage |

**Task:** Create a trigger to calculate and insert student total marks and percentage **BEFORE** inserting data into the Student_Trigger table.

```sql
-- Your answer here

```

---

### Question 4: Inventory Reorder Trigger

**Tables:**
- `tbl_product` (pro_id, pro_price, pro_sprice, pro_quantity, reorder_qty)
- `tbl_proreorder` (id, pro_id, quantity)

**Task:** Write a trigger where if a product's current quantity equals the reorder quantity, it is marked as a reorder product and added to the reorder table.

```sql
-- Your answer here

```

---

### Question 5: Referential Integrity Trigger (ON DELETE CASCADE)

**Tables:**
- `Employee` (name, Age, Address, Depid)
- `Department` (Depid, Depname)

**Task:** Write a trigger to implement ON DELETE CASCADE (delete employees when their department is deleted).

> ⚠️ **Note:** This is NOT the recommended approach. Use Foreign Key constraints instead.

```sql
-- Your answer here

```

---

### Question 6: Location History Trigger

**Tables:**
- `Locations` (LocationID, LocName)
- `LocationHist` (LocationID, ModifiedDate)

**Task:** Create a trigger to maintain location history on UPDATE events.

```sql
-- Your answer here

```

---

### Question 7: Book Issue Trigger

**Tables:**
- `book_det` (bid, btitle, copies)
- `book_issue` (bid, sid, btitle)

**Task:** When data is inserted into `book_issue`, a trigger should automatically decrement the `copies` attribute in `book_det` by 1.

```sql
-- Your answer here

```

---

## 🎯 Part B: View Questions

### Table: `salesman`
| Field | Type |
|-------|------|
| salesman_id | int |
| name | varchar |
| city | varchar |
| commission | decimal |

### Table: `customer`
| Field | Type |
|-------|------|
| customer_id | int |
| cust_name | varchar |
| city | varchar |
| grade | int |
| salesman_id | int |

### Table: `orders`
| Field | Type |
|-------|------|
| ord_no | int |
| purch_amt | decimal |
| ord_date | date |
| customer_id | int |
| salesman_id | int |

---

### Question 8: View - New York Salespeople

**Task:** Create a view for salespeople who belong to the city of "New York".

```sql
-- Your answer here

```

---

### Question 9: View - Salesman Details

**Task:** Create a view for all salespersons returning salesperson ID, name, and city.

```sql
-- Your answer here

```

---

### Question 10: View - Customer Grade Count

**Task:** Create a view that counts the number of customers in each grade.

```sql
-- Your answer here

```

---

### Question 11: View - Order Statistics by Date

**Task:** Create a view to count unique customers, compute average, and total purchase amount of orders by each date.

```sql
-- Your answer here

```

---

## ✅ Checklist - Triggers
- [ ] Question 1: Auto-Add Marks
- [ ] Question 2: Auto-Calculate Total & Average
- [ ] Question 3: Calculate Total & Percentage
- [ ] Question 4: Inventory Reorder
- [ ] Question 5: ON DELETE CASCADE
- [ ] Question 6: Location History
- [ ] Question 7: Book Issue

## ✅ Checklist - Views
- [ ] Question 8: New York Salespeople
- [ ] Question 9: Salesman Details
- [ ] Question 10: Customer Grade Count
- [ ] Question 11: Order Statistics by Date

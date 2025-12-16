# 📖 Database Security - Theory Notes

> **Topics:** User Management, Privileges, GRANT/REVOKE, Roles, Data Encryption

---

## 🤔 What is Database Security?

**Database Security** involves protecting the database from unauthorized access, misuse, and threats while ensuring data integrity and availability.

```
┌─────────────────────────────────────────────────────────────┐
│                     Think of it like this:                   │
│                                                             │
│   Database = Bank Vault                                     │
│   Security = Locks, Guards, Access Cards, Cameras           │
│                                                             │
│   Who can enter? What can they access? What can they do?    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 Security Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                           │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: Authentication    │  Who are you?                 │
│  Layer 2: Authorization     │  What can you do?             │
│  Layer 3: Encryption        │  Protect data in transit/rest │
│  Layer 4: Auditing          │  Track who did what           │
└─────────────────────────────────────────────────────────────┘
```

---

## 👤 User Management

### Create User
```sql
CREATE USER 'username'@'host' IDENTIFIED BY 'password';

-- Examples:
CREATE USER 'john'@'localhost' IDENTIFIED BY 'secret123';
CREATE USER 'admin'@'%' IDENTIFIED BY 'adminpass';  -- % = any host
CREATE USER 'app'@'192.168.1.%' IDENTIFIED BY 'apppass';  -- Subnet
```

### View Users
```sql
SELECT User, Host FROM mysql.user;
```

### Change Password
```sql
ALTER USER 'username'@'host' IDENTIFIED BY 'new_password';

-- Or for current user:
SET PASSWORD = 'new_password';
```

### Delete User
```sql
DROP USER 'username'@'host';
DROP USER IF EXISTS 'username'@'host';
```

---

## 🎫 Privileges (Permissions)

Privileges control what users can do.

### Types of Privileges:

| Level | Applies To |
|-------|------------|
| **Global** | All databases |
| **Database** | Specific database |
| **Table** | Specific table |
| **Column** | Specific columns |
| **Routine** | Procedures/Functions |

### Common Privileges:

| Privilege | Description |
|-----------|-------------|
| `SELECT` | Read data |
| `INSERT` | Add new rows |
| `UPDATE` | Modify existing rows |
| `DELETE` | Remove rows |
| `CREATE` | Create tables/databases |
| `DROP` | Delete tables/databases |
| `INDEX` | Create/drop indexes |
| `ALTER` | Modify table structure |
| `EXECUTE` | Run stored procedures |
| `GRANT OPTION` | Grant privileges to others |
| `ALL PRIVILEGES` | All available privileges |

---

## 🔨 GRANT - Give Permissions

### Syntax:
```sql
GRANT privilege_list ON object TO 'user'@'host';
```

### Examples:

```sql
-- Grant SELECT on specific table
GRANT SELECT ON library.books TO 'reader'@'localhost';

-- Grant multiple privileges
GRANT SELECT, INSERT, UPDATE ON library.* TO 'librarian'@'localhost';

-- Grant all privileges on database
GRANT ALL PRIVILEGES ON library.* TO 'admin'@'localhost';

-- Grant with option to pass privileges to others
GRANT SELECT ON library.books TO 'senior'@'localhost' WITH GRANT OPTION;

-- Grant on specific columns
GRANT SELECT (name, email) ON library.members TO 'viewer'@'localhost';

-- Grant execute on procedure
GRANT EXECUTE ON PROCEDURE library.sp_AddBook TO 'operator'@'localhost';
```

### Apply Changes:
```sql
FLUSH PRIVILEGES;
```

---

## ❌ REVOKE - Remove Permissions

### Syntax:
```sql
REVOKE privilege_list ON object FROM 'user'@'host';
```

### Examples:

```sql
-- Revoke specific privilege
REVOKE INSERT ON library.books FROM 'reader'@'localhost';

-- Revoke all privileges
REVOKE ALL PRIVILEGES ON library.* FROM 'user'@'localhost';

-- Revoke grant option
REVOKE GRANT OPTION ON library.* FROM 'user'@'localhost';
```

---

## 📋 View Privileges

```sql
-- View current user's privileges
SHOW GRANTS;

-- View specific user's privileges
SHOW GRANTS FOR 'username'@'host';

-- View all privileges on a table
SELECT * FROM information_schema.TABLE_PRIVILEGES 
WHERE TABLE_NAME = 'books';
```

---

## 👥 Roles (MySQL 8.0+)

Roles are named collections of privileges - assign to multiple users easily.

### Create Role
```sql
CREATE ROLE 'role_name';
```

### Grant Privileges to Role
```sql
GRANT SELECT, INSERT ON library.* TO 'reader_role';
GRANT ALL PRIVILEGES ON library.* TO 'admin_role';
```

### Assign Role to User
```sql
GRANT 'reader_role' TO 'john'@'localhost';
GRANT 'admin_role' TO 'admin'@'localhost';
```

### Activate Role
```sql
SET DEFAULT ROLE 'role_name' TO 'user'@'host';
-- Or for current session:
SET ROLE 'role_name';
```

### View Roles
```sql
SELECT * FROM mysql.role_edges;
SHOW GRANTS FOR 'role_name';
```

### Example: Complete Role Setup
```sql
-- Create roles
CREATE ROLE 'app_read', 'app_write', 'app_admin';

-- Grant privileges to roles
GRANT SELECT ON myapp.* TO 'app_read';
GRANT INSERT, UPDATE, DELETE ON myapp.* TO 'app_write';
GRANT ALL PRIVILEGES ON myapp.* TO 'app_admin';

-- Create users
CREATE USER 'viewer'@'localhost' IDENTIFIED BY 'pass1';
CREATE USER 'editor'@'localhost' IDENTIFIED BY 'pass2';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'pass3';

-- Assign roles
GRANT 'app_read' TO 'viewer'@'localhost';
GRANT 'app_read', 'app_write' TO 'editor'@'localhost';
GRANT 'app_admin' TO 'admin'@'localhost';

-- Set default roles
SET DEFAULT ROLE ALL TO 'viewer'@'localhost', 'editor'@'localhost', 'admin'@'localhost';
```

---

## 🔒 Views for Security

Use views to restrict data access:

```sql
-- Create view showing only non-sensitive data
CREATE VIEW vw_PublicEmployees AS
SELECT employee_id, name, department
FROM employees;  -- Hides salary, SSN, etc.

-- Grant access to view only
GRANT SELECT ON hr_db.vw_PublicEmployees TO 'public_user'@'localhost';

-- User can only see limited columns!
```

---

## 🗝️ Stored Procedures for Security

Execute procedures without direct table access:

```sql
-- Create procedure
CREATE PROCEDURE sp_GetEmployeeByID(IN emp_id INT)
BEGIN
    SELECT name, department FROM employees WHERE id = emp_id;
END;

-- Grant only EXECUTE permission
GRANT EXECUTE ON PROCEDURE hr_db.sp_GetEmployeeByID TO 'app_user'@'localhost';

-- User can run procedure but can't directly SELECT from table!
```

---

## 🔐 Data Encryption

### Types of Encryption:

| Type | Description |
|------|-------------|
| **At Rest** | Data stored on disk |
| **In Transit** | Data moving over network |
| **Column Level** | Specific sensitive columns |

### Password Hashing:
```sql
-- Never store plain passwords!
INSERT INTO users (username, password_hash)
VALUES ('john', SHA2('my_password', 256));

-- Verify password
SELECT * FROM users 
WHERE username = 'john' AND password_hash = SHA2('my_password', 256);
```

### Encryption Functions:
```sql
-- AES Encryption
SET @encrypted = AES_ENCRYPT('sensitive_data', 'secret_key');
SET @decrypted = AES_DECRYPT(@encrypted, 'secret_key');

-- SHA2 Hashing (one-way)
SELECT SHA2('password', 256);
```

---

## 📋 Security Best Practices

| Practice | Description |
|----------|-------------|
| Principle of Least Privilege | Give minimum required access |
| Use Roles | Group permissions, easier management |
| Strong Passwords | Enforce complexity rules |
| Regular Audits | Review who has access |
| Remove Unused Accounts | Delete old users |
| Use Views | Hide sensitive columns |
| Use Procedures | Control data access |
| Encrypt Sensitive Data | Passwords, SSN, etc. |
| Limit Remote Access | Restrict host patterns |
| Regular Updates | Patch security vulnerabilities |

---

## 📝 Common Exam Questions

### Q1: What is the difference between GRANT and REVOKE?
**Answer:**
- **GRANT:** Gives privileges to a user
- **REVOKE:** Removes privileges from a user

### Q2: How do you create a user in MySQL?
**Answer:**
```sql
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
```

### Q3: What does `WITH GRANT OPTION` do?
**Answer:** Allows the user to grant the same privileges to other users.

### Q4: How can Views improve security?
**Answer:** Views can hide sensitive columns and filter data, showing users only what they need to see.

### Q5: What is the Principle of Least Privilege?
**Answer:** Users should only have the minimum privileges necessary to perform their job - no more, no less.

### Q6: What are Roles in MySQL?
**Answer:** Roles are named collections of privileges that can be assigned to multiple users, making permission management easier.

---

## ✅ Quick Reference

```sql
-- Create user
CREATE USER 'user'@'host' IDENTIFIED BY 'password';

-- Grant privileges
GRANT SELECT, INSERT ON database.table TO 'user'@'host';
GRANT ALL PRIVILEGES ON database.* TO 'user'@'host';

-- Revoke privileges
REVOKE SELECT ON database.table FROM 'user'@'host';

-- View privileges
SHOW GRANTS FOR 'user'@'host';

-- Create role
CREATE ROLE 'role_name';
GRANT SELECT ON db.* TO 'role_name';
GRANT 'role_name' TO 'user'@'host';

-- Delete user
DROP USER 'user'@'host';

-- Apply changes
FLUSH PRIVILEGES;

-- Password encryption
SHA2('password', 256)
AES_ENCRYPT('data', 'key')
AES_DECRYPT(encrypted_data, 'key')
```

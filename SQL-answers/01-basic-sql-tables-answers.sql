-- ==========================================
-- PRACTICAL 01: Basic SQL & Tables - ANSWERS
-- Database: ADBMS_practicals
-- ==========================================

-- ==========================================
-- SETUP: Create and use database
-- ==========================================

CREATE DATABASE IF NOT EXISTS ADBMS_practicals;
USE ADBMS_practicals;

-- ==========================================
-- Question 3: Create Tables (Annex A)
-- ==========================================

-- Table: department (create first due to FK references)
CREATE TABLE department (
    d_id CHAR(3) PRIMARY KEY,
    d_name VARCHAR(5),
    d_head CHAR(3)
);

-- Table: academic_staff
CREATE TABLE academic_staff (
    l_id CHAR(3) PRIMARY KEY,
    l_d_id CHAR(3),
    l_name VARCHAR(30),
    l_desig VARCHAR(20),
    l_salary DECIMAL(9,2),
    l_allowance DECIMAL(9,2)
);

-- Table: project
CREATE TABLE project (
    pr_id CHAR(4) PRIMARY KEY,
    pr_d_id CHAR(3),
    pr_name VARCHAR(20),
    pr_supervisor CHAR(3),
    pr_budget DECIMAL(9,2),
    FOREIGN KEY (pr_d_id) REFERENCES department(d_id),
    FOREIGN KEY (pr_supervisor) REFERENCES academic_staff(l_id)
);

-- Table: work
CREATE TABLE work (
    w_pr_id CHAR(4),
    w_l_id CHAR(3),
    PRIMARY KEY (w_pr_id, w_l_id),
    FOREIGN KEY (w_pr_id) REFERENCES project(pr_id),
    FOREIGN KEY (w_l_id) REFERENCES academic_staff(l_id)
);

-- ==========================================
-- Question 4: Insert Data
-- ==========================================

-- Insert into academic_staff
INSERT INTO academic_staff VALUES ('101', 'd01', 'Kasun', 'Lecturer', 35000, 15000);
INSERT INTO academic_staff VALUES ('102', 'd02', 'Mahesh', 'Senior Lecturer', 45000, 18000);
INSERT INTO academic_staff VALUES ('103', 'd03', 'Udaya', 'Professor', 28000, 62000);
INSERT INTO academic_staff VALUES ('104', 'd01', 'Nadun', 'Senior Lecturer', 45000, 20000);

-- Insert into department
INSERT INTO department VALUES ('d01', 'ICT', '104');
INSERT INTO department VALUES ('d02', 'ENT', '102');
INSERT INTO department VALUES ('d03', 'BT', '103');
INSERT INTO department VALUES ('d04', 'PQT', '101');

-- Insert into project
INSERT INTO project VALUES ('pr01', 'd01', 'Eagle Eye', '101', 300000);
INSERT INTO project VALUES ('pr02', 'd02', 'Hill Climber', '102', 250000);
INSERT INTO project VALUES ('pr03', 'd03', 'Glowing Fish', '103', 400000);

-- Insert into work
INSERT INTO work VALUES ('pr01', '101');
INSERT INTO work VALUES ('pr02', '101');
INSERT INTO work VALUES ('pr01', '102');
INSERT INTO work VALUES ('pr01', '104');
INSERT INTO work VALUES ('pr02', '103');
INSERT INTO work VALUES ('pr01', '103');
INSERT INTO work VALUES ('pr03', '103');

-- ==========================================
-- Question 5: Modify Foreign Key
-- Add l_d_id as Foreign Key in academic_staff
-- ==========================================

ALTER TABLE academic_staff
ADD CONSTRAINT fk_department
FOREIGN KEY (l_d_id) REFERENCES department(d_id);

-- ==========================================
-- Question 6: Retrieve All Data
-- ==========================================

SELECT * FROM academic_staff;

-- ==========================================
-- Question 7: Update Data
-- Update BT to BST
-- ==========================================

UPDATE department
SET d_name = 'BST'
WHERE d_name = 'BT';

-- ==========================================
-- Question 8: Delete Data
-- Remove PQT department
-- ==========================================

DELETE FROM department
WHERE d_name = 'PQT';

-- ==========================================
-- Question 9: Select Query
-- Names and salaries of Senior Lectures
-- ==========================================

SELECT l_name, l_salary
FROM academic_staff
WHERE l_desig = 'Senior Lecturer';

-- ==========================================
-- Question 10: Calculation Query
-- University grant is 70% of budget
-- ==========================================

SELECT 
    pr_id,
    pr_name,
    pr_budget,
    (pr_budget * 0.70) AS university_grant
FROM project;

-- ==========================================
-- Question 11: Aggregation
-- Staff with lowest allowance
-- ==========================================

SELECT l_name, l_allowance
FROM academic_staff
WHERE l_allowance = (SELECT MIN(l_allowance) FROM academic_staff);

-- ==========================================
-- Question 12: Select Query
-- Names and designation of Project Supervisors
-- ==========================================

SELECT DISTINCT a.l_name, a.l_desig
FROM academic_staff a
INNER JOIN project p ON a.l_id = p.pr_supervisor;

-- ==========================================
-- Question 13: Join/Count
-- Researchers count for "Eagle Eye" project
-- ==========================================

SELECT COUNT(*) AS 'Researchers Count'
FROM work w
INNER JOIN project p ON w.w_pr_id = p.pr_id
WHERE p.pr_name = 'Eagle Eye';

-- ==========================================
-- Question 14: Join/Grouping
-- Staff working on more than one project
-- ==========================================

SELECT a.l_name
FROM academic_staff a
INNER JOIN work w ON a.l_id = w.w_l_id
GROUP BY a.l_id, a.l_name
HAVING COUNT(w.w_pr_id) > 1;

-- ==========================================
-- Question 15: Create View
-- all_projects view
-- ==========================================

CREATE VIEW all_projects AS
SELECT 
    p.pr_id,
    p.pr_name,
    p.pr_budget,
    d.d_name AS department_name
FROM project p
INNER JOIN department d ON p.pr_d_id = d.d_id;

-- Test the view
SELECT * FROM all_projects;

-- ==========================================
-- Question 16: Create Procedure
-- academic_members_for_project
-- ==========================================

DELIMITER //

CREATE PROCEDURE academic_members_for_project(IN project_id CHAR(4))
BEGIN
    SELECT 
        a.l_id,
        a.l_name,
        a.l_desig,
        a.l_salary,
        a.l_allowance,
        d.d_name AS department_name
    FROM academic_staff a
    INNER JOIN work w ON a.l_id = w.w_l_id
    INNER JOIN department d ON a.l_d_id = d.d_id
    WHERE w.w_pr_id = project_id;
END //

DELIMITER ;

-- Test the procedure
CALL academic_members_for_project('pr01');

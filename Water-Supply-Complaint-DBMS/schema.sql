-- ============================================================
-- Water Supply Complaint Management System
-- Database Schema (MySQL)
-- ============================================================
-- This file creates all tables with proper constraints,
-- views, and indexes for the complaint management system.
-- ============================================================

-- Create and use the database
CREATE DATABASE IF NOT EXISTS water_supply_db;
USE water_supply_db;

-- ============================================================
-- TABLE 1: Region
-- Stores geographic regions/zones for complaint assignment
-- ============================================================
CREATE TABLE Region (
    Region_ID   INT             PRIMARY KEY AUTO_INCREMENT,
    Region_Name VARCHAR(100)    NOT NULL UNIQUE
);

-- ============================================================
-- TABLE 2: Department
-- Stores departments responsible for handling complaints
-- ============================================================
CREATE TABLE Department (
    Dept_ID     INT             PRIMARY KEY AUTO_INCREMENT,
    Dept_Name   VARCHAR(100)    NOT NULL UNIQUE
);

-- ============================================================
-- TABLE 3: SLA (Service Level Agreement)
-- Defines priority levels and resolution time limits
-- ============================================================
CREATE TABLE SLA (
    SLA_ID      INT             PRIMARY KEY AUTO_INCREMENT,
    Time_Limit  INT             NOT NULL COMMENT 'Resolution time limit in hours',
    Priority    VARCHAR(20)     NOT NULL CHECK (Priority IN ('Low', 'Medium', 'High', 'Critical'))
);

-- ============================================================
-- TABLE 4: User
-- Stores information about citizens who file complaints
-- ============================================================
CREATE TABLE User (
    User_ID     INT             PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100)    NOT NULL,
    Phone       VARCHAR(15)     NOT NULL UNIQUE,
    Address     VARCHAR(255)    NOT NULL
);

-- ============================================================
-- TABLE 5: Complaint
-- Central table storing all water supply complaints
-- Links to User, Region, Department, and SLA tables
-- ============================================================
CREATE TABLE Complaint (
    Complaint_ID    INT             PRIMARY KEY AUTO_INCREMENT,
    User_ID         INT             NOT NULL,
    Region_ID       INT             NOT NULL,
    Dept_ID         INT             NOT NULL,
    SLA_ID          INT             NOT NULL,
    Description     VARCHAR(500)    NOT NULL,
    Status          VARCHAR(20)     NOT NULL DEFAULT 'Pending'
                                    CHECK (Status IN ('Pending', 'In Progress', 'Resolved', 'Closed')),
    Date            DATE            NOT NULL DEFAULT (CURRENT_DATE),

    -- Foreign Key Constraints
    CONSTRAINT fk_complaint_user
        FOREIGN KEY (User_ID)   REFERENCES User(User_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_complaint_region
        FOREIGN KEY (Region_ID) REFERENCES Region(Region_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_complaint_dept
        FOREIGN KEY (Dept_ID)   REFERENCES Department(Dept_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_complaint_sla
        FOREIGN KEY (SLA_ID)    REFERENCES SLA(SLA_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- INDEXES for Performance Optimization
-- ============================================================

-- Index on Status for faster filtering of pending/resolved complaints
CREATE INDEX idx_complaint_status ON Complaint(Status);

-- Index on Date for faster date-range queries
CREATE INDEX idx_complaint_date ON Complaint(Date);

-- Index on Region_ID for region-based reporting
CREATE INDEX idx_complaint_region ON Complaint(Region_ID);

-- Composite index for common query: complaints by user and status
CREATE INDEX idx_complaint_user_status ON Complaint(User_ID, Status);

-- ============================================================
-- VIEWS
-- ============================================================

-- View 1: Pending Complaints with full details
CREATE VIEW vw_pending_complaints AS
SELECT
    c.Complaint_ID,
    u.Name          AS Complainant,
    u.Phone,
    r.Region_Name,
    d.Dept_Name     AS Department,
    c.Description,
    s.Priority,
    s.Time_Limit    AS SLA_Hours,
    c.Date          AS Filed_Date
FROM Complaint c
JOIN User u         ON c.User_ID   = u.User_ID
JOIN Region r       ON c.Region_ID = r.Region_ID
JOIN Department d   ON c.Dept_ID   = d.Dept_ID
JOIN SLA s          ON c.SLA_ID    = s.SLA_ID
WHERE c.Status = 'Pending';

-- View 2: Region-wise Complaint Summary
CREATE VIEW vw_region_summary AS
SELECT
    r.Region_Name,
    COUNT(c.Complaint_ID)                                           AS Total_Complaints,
    SUM(CASE WHEN c.Status = 'Resolved' THEN 1 ELSE 0 END)        AS Resolved,
    SUM(CASE WHEN c.Status = 'Pending' THEN 1 ELSE 0 END)         AS Pending,
    SUM(CASE WHEN c.Status = 'In Progress' THEN 1 ELSE 0 END)     AS In_Progress
FROM Region r
LEFT JOIN Complaint c ON r.Region_ID = c.Region_ID
GROUP BY r.Region_Name;

-- View 3: High Priority Complaints (SLA Monitoring)
CREATE VIEW vw_high_priority AS
SELECT
    c.Complaint_ID,
    u.Name          AS Complainant,
    r.Region_Name,
    d.Dept_Name     AS Department,
    s.Priority,
    s.Time_Limit    AS SLA_Hours,
    c.Status,
    c.Date          AS Filed_Date,
    DATEDIFF(CURDATE(), c.Date) AS Days_Open
FROM Complaint c
JOIN User u         ON c.User_ID   = u.User_ID
JOIN Region r       ON c.Region_ID = r.Region_ID
JOIN Department d   ON c.Dept_ID   = d.Dept_ID
JOIN SLA s          ON c.SLA_ID    = s.SLA_ID
WHERE s.Priority IN ('High', 'Critical')
  AND c.Status NOT IN ('Resolved', 'Closed');

-- ============================================================
-- END OF SCHEMA
-- ============================================================

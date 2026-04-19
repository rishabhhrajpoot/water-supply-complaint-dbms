-- ============================================================
-- Water Supply Complaint Management System
-- Sample Data (MySQL)
-- ============================================================
-- Run this file AFTER schema.sql
-- Contains realistic sample data in Indian context
-- ============================================================

USE water_supply_db;

-- ============================================================
-- REGIONS (6 records)
-- ============================================================
INSERT INTO Region (Region_ID, Region_Name) VALUES
(1, 'North Delhi'),
(2, 'South Delhi'),
(3, 'East Delhi'),
(4, 'West Delhi'),
(5, 'Central Delhi'),
(6, 'Dwarka');

-- ============================================================
-- DEPARTMENTS (5 records)
-- ============================================================
INSERT INTO Department (Dept_ID, Dept_Name) VALUES
(1, 'Pipeline Maintenance'),
(2, 'Water Quality Testing'),
(3, 'Billing and Metering'),
(4, 'Tanker Supply'),
(5, 'New Connection');

-- ============================================================
-- SLA - Service Level Agreements (5 records)
-- ============================================================
INSERT INTO SLA (SLA_ID, Time_Limit, Priority) VALUES
(1, 6,   'Critical'),   -- Must resolve within 6 hours
(2, 12,  'High'),        -- Must resolve within 12 hours
(3, 24,  'Medium'),      -- Must resolve within 24 hours
(4, 48,  'Low'),         -- Must resolve within 48 hours
(5, 72,  'Low');          -- Must resolve within 72 hours

-- ============================================================
-- USERS (8 records)
-- ============================================================
INSERT INTO User (User_ID, Name, Phone, Address) VALUES
(1, 'Rajesh Kumar',      '9876543210', '45, Sector 12, Rohini, North Delhi'),
(2, 'Priya Sharma',      '9988776655', '12, Green Park, South Delhi'),
(3, 'Amit Verma',        '8899001122', 'B-34, Laxmi Nagar, East Delhi'),
(4, 'Sunita Devi',       '7766554433', '78, Rajouri Garden, West Delhi'),
(5, 'Mohammed Irfan',    '9090909090', 'A-22, Karol Bagh, Central Delhi'),
(6, 'Kavita Mehra',      '8585858585', 'C-5, Sector 7, Dwarka'),
(7, 'Vikram Singh',      '9191919191', '102, Pitampura, North Delhi'),
(8, 'Ananya Gupta',      '7070707070', '56, Hauz Khas, South Delhi');

-- ============================================================
-- COMPLAINTS (10 records)
-- ============================================================
INSERT INTO Complaint (Complaint_ID, User_ID, Region_ID, Dept_ID, SLA_ID, Description, Status, Date) VALUES
(1001, 1, 1, 1, 2, 'Major pipeline burst near Sector 12 main road causing water flooding on streets.',
    'Pending', '2026-04-10'),

(1002, 2, 2, 2, 3, 'Water has yellowish colour and foul smell since the last 3 days in Green Park area.',
    'In Progress', '2026-04-08'),

(1003, 3, 3, 1, 1, 'Complete water supply cut-off in Laxmi Nagar Block B since yesterday morning.',
    'Pending', '2026-04-12'),

(1004, 4, 4, 3, 4, 'Water meter showing incorrect readings, bill amount is unusually high this month.',
    'Resolved', '2026-04-01'),

(1005, 5, 5, 4, 2, 'No water supply for 2 days in Karol Bagh, need immediate tanker supply.',
    'Pending', '2026-04-11'),

(1006, 6, 6, 5, 4, 'Applied for new water connection 2 weeks ago, still no update on application status.',
    'In Progress', '2026-03-28'),

(1007, 7, 1, 1, 3, 'Low water pressure in Pitampura area during morning hours (6 AM - 9 AM).',
    'Pending', '2026-04-13'),

(1008, 8, 2, 2, 1, 'Contaminated water supply reported in Hauz Khas, multiple residents falling sick.',
    'In Progress', '2026-04-14'),

(1009, 1, 1, 4, 2, 'Scheduled tanker did not arrive at Sector 12, Rohini on the assigned date.',
    'Resolved', '2026-04-05'),

(1010, 3, 3, 1, 1, 'Sewage water mixing with drinking water pipeline near Laxmi Nagar market.',
    'Pending', '2026-04-15');

-- ============================================================
-- END OF SAMPLE DATA
-- ============================================================

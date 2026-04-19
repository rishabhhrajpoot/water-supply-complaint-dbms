-- ============================================================
-- Water Supply Complaint Management System
-- SQL Queries (MySQL)
-- ============================================================
-- Run this file AFTER schema.sql and sample_data.sql
-- Contains: SELECT, JOIN, GROUP BY, WHERE, Subqueries
-- ============================================================

USE water_supply_db;


-- ************************************************************
-- SECTION 1: BASIC SELECT QUERIES
-- ************************************************************

-- Q1. Display all registered users
SELECT * FROM User;

-- Q2. Display all complaints sorted by date (most recent first)
SELECT * FROM Complaint ORDER BY Date DESC;

-- Q3. Display all regions
SELECT * FROM Region;

-- Q4. Display all departments
SELECT * FROM Department;

-- Q5. Display all SLA levels with their priority and time limits
SELECT SLA_ID, Priority, Time_Limit AS Resolution_Hours
FROM SLA
ORDER BY Time_Limit;


-- ************************************************************
-- SECTION 2: WHERE CLAUSE QUERIES (Filtering)
-- ************************************************************

-- Q6. Fetch all PENDING complaints
SELECT Complaint_ID, Description, Status, Date
FROM Complaint
WHERE Status = 'Pending';

-- Q7. Fetch all complaints filed after April 10, 2026
SELECT Complaint_ID, Description, Date
FROM Complaint
WHERE Date > '2026-04-10';

-- Q8. Fetch users whose name starts with 'A'
SELECT User_ID, Name, Phone
FROM User
WHERE Name LIKE 'A%';

-- Q9. Fetch complaints that are NOT resolved or closed
SELECT Complaint_ID, Description, Status, Date
FROM Complaint
WHERE Status NOT IN ('Resolved', 'Closed');

-- Q10. Fetch all HIGH or CRITICAL priority SLAs
SELECT * FROM SLA
WHERE Priority IN ('High', 'Critical');


-- ************************************************************
-- SECTION 3: JOIN QUERIES
-- ************************************************************

-- Q11. Complaint details with User name and phone
--      (INNER JOIN: Complaint + User)
SELECT
    c.Complaint_ID,
    u.Name          AS Complainant,
    u.Phone,
    c.Description,
    c.Status,
    c.Date
FROM Complaint c
INNER JOIN User u ON c.User_ID = u.User_ID;

-- Q12. Complaint details with Region name
--      (INNER JOIN: Complaint + Region)
SELECT
    c.Complaint_ID,
    c.Description,
    r.Region_Name,
    c.Status,
    c.Date
FROM Complaint c
INNER JOIN Region r ON c.Region_ID = r.Region_ID;

-- Q13. Full complaint report with all related information
--      (Multiple JOINs: Complaint + User + Region + Department + SLA)
SELECT
    c.Complaint_ID,
    u.Name          AS Complainant,
    u.Phone,
    r.Region_Name   AS Region,
    d.Dept_Name     AS Department,
    s.Priority,
    s.Time_Limit    AS SLA_Hours,
    c.Description,
    c.Status,
    c.Date          AS Filed_Date
FROM Complaint c
INNER JOIN User u       ON c.User_ID   = u.User_ID
INNER JOIN Region r     ON c.Region_ID = r.Region_ID
INNER JOIN Department d ON c.Dept_ID   = d.Dept_ID
INNER JOIN SLA s        ON c.SLA_ID    = s.SLA_ID
ORDER BY c.Date DESC;

-- Q14. Show regions that have NO complaints (LEFT JOIN)
SELECT
    r.Region_ID,
    r.Region_Name
FROM Region r
LEFT JOIN Complaint c ON r.Region_ID = c.Region_ID
WHERE c.Complaint_ID IS NULL;

-- Q15. Show all pending HIGH/CRITICAL priority complaints
--      with user and department details
SELECT
    c.Complaint_ID,
    u.Name          AS Complainant,
    d.Dept_Name     AS Department,
    s.Priority,
    c.Description,
    c.Date
FROM Complaint c
JOIN User u         ON c.User_ID = u.User_ID
JOIN Department d   ON c.Dept_ID = d.Dept_ID
JOIN SLA s          ON c.SLA_ID  = s.SLA_ID
WHERE c.Status = 'Pending'
  AND s.Priority IN ('High', 'Critical');


-- ************************************************************
-- SECTION 4: GROUP BY & AGGREGATE QUERIES
-- ************************************************************

-- Q16. Count of complaints per status
SELECT
    Status,
    COUNT(*) AS Total
FROM Complaint
GROUP BY Status
ORDER BY Total DESC;

-- Q17. Count of complaints per region
SELECT
    r.Region_Name,
    COUNT(c.Complaint_ID) AS Total_Complaints
FROM Region r
LEFT JOIN Complaint c ON r.Region_ID = c.Region_ID
GROUP BY r.Region_Name
ORDER BY Total_Complaints DESC;

-- Q18. Count of complaints handled by each department
SELECT
    d.Dept_Name       AS Department,
    COUNT(c.Complaint_ID) AS Complaints_Handled
FROM Department d
LEFT JOIN Complaint c ON d.Dept_ID = c.Dept_ID
GROUP BY d.Dept_Name
ORDER BY Complaints_Handled DESC;

-- Q19. Average number of days complaints have been open (by status)
SELECT
    Status,
    ROUND(AVG(DATEDIFF(CURDATE(), Date)), 1) AS Avg_Days_Open
FROM Complaint
WHERE Status NOT IN ('Resolved', 'Closed')
GROUP BY Status;

-- Q20. Region with the highest number of pending complaints
SELECT
    r.Region_Name,
    COUNT(c.Complaint_ID) AS Pending_Count
FROM Complaint c
JOIN Region r ON c.Region_ID = r.Region_ID
WHERE c.Status = 'Pending'
GROUP BY r.Region_Name
ORDER BY Pending_Count DESC
LIMIT 1;


-- ************************************************************
-- SECTION 5: SUBQUERIES
-- ************************************************************

-- Q21. Users who have filed more than one complaint
SELECT Name, Phone
FROM User
WHERE User_ID IN (
    SELECT User_ID
    FROM Complaint
    GROUP BY User_ID
    HAVING COUNT(*) > 1
);

-- Q22. Complaints with the highest priority SLA
SELECT Complaint_ID, Description, Status, Date
FROM Complaint
WHERE SLA_ID IN (
    SELECT SLA_ID FROM SLA WHERE Priority = 'Critical'
);

-- Q23. Region(s) with the most complaints
SELECT Region_Name
FROM Region
WHERE Region_ID = (
    SELECT Region_ID
    FROM Complaint
    GROUP BY Region_ID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);


-- ************************************************************
-- SECTION 6: VIEWS (pre-created in schema.sql)
-- ************************************************************

-- Q24. View all pending complaints (using the view)
SELECT * FROM vw_pending_complaints;

-- Q25. View region-wise complaint summary
SELECT * FROM vw_region_summary;

-- Q26. View high priority open complaints (SLA monitoring)
SELECT * FROM vw_high_priority;


-- ************************************************************
-- SECTION 7: UPDATE & DELETE EXAMPLES
-- ************************************************************

-- Q27. Mark a complaint as 'Resolved'
-- UPDATE Complaint SET Status = 'Resolved' WHERE Complaint_ID = 1001;

-- Q28. Delete a closed complaint
-- DELETE FROM Complaint WHERE Complaint_ID = 1004 AND Status = 'Closed';

-- NOTE: The above UPDATE/DELETE statements are commented out
--       to prevent accidental data modification. Uncomment to use.


-- ============================================================
-- END OF QUERIES
-- ============================================================

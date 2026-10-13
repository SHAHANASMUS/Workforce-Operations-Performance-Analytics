-- ============================================================
-- WORKFORCE & OPERATIONS PERFORMANCE ANALYTICS
-- SQL Analysis
-- ============================================================


-- ============================================================
-- 1. WORKFORCE BY DEPARTMENT
-- ============================================================

SELECT
    Department,
    COUNT(DISTINCT Employee_ID) AS Employee_Count
FROM employees
GROUP BY Department
ORDER BY Employee_Count DESC;


-- ============================================================
-- 2. WORKFORCE BY JOB ROLE
-- ============================================================

SELECT
    Job_Role,
    COUNT(DISTINCT Employee_ID) AS Employee_Count
FROM employees
GROUP BY Job_Role
ORDER BY Employee_Count DESC;


-- ============================================================
-- 3. PERFORMANCE BY DEPARTMENT
-- ============================================================

SELECT
    e.Department,
    ROUND(AVG(m.Performance_Rating), 2) AS Avg_Performance,
    ROUND(AVG(m.Employee_Satisfaction), 2) AS Avg_Satisfaction,
    ROUND(AVG(m.Engagement_Index), 2) AS Avg_Engagement
FROM employees e
JOIN monthly_performance m
    ON e.Employee_ID = m.Employee_ID
GROUP BY e.Department
ORDER BY Avg_Performance DESC;


-- ============================================================
-- 4. PERFORMANCE BY JOB LEVEL
-- ============================================================

SELECT
    e.Job_Level,
    ROUND(AVG(m.Performance_Rating), 2) AS Avg_Performance,
    ROUND(AVG(m.Employee_Satisfaction), 2) AS Avg_Satisfaction
FROM employees e
JOIN monthly_performance m
    ON e.Employee_ID = m.Employee_ID
GROUP BY e.Job_Level
ORDER BY Avg_Performance DESC;


-- ============================================================
-- 5. TENURE VS PERFORMANCE
-- ============================================================

SELECT
    CASE
        WHEN m.Monthly_Tenure < 12 THEN '<1 Year'
        WHEN m.Monthly_Tenure < 36 THEN '1-3 Years'
        WHEN m.Monthly_Tenure < 60 THEN '3-5 Years'
        ELSE '5+ Years'
    END AS Tenure_Group,
    ROUND(AVG(m.Performance_Rating), 2) AS Avg_Performance,
    ROUND(AVG(m.Employee_Satisfaction), 2) AS Avg_Satisfaction
FROM monthly_performance m
GROUP BY Tenure_Group
ORDER BY Avg_Performance DESC;


-- ============================================================
-- 6. OVERTIME VS PERFORMANCE
-- ============================================================

SELECT
    CASE
        WHEN Overtime_Hours = 0 THEN '0 Hours'
        WHEN Overtime_Hours < 10 THEN '1-9 Hours'
        WHEN Overtime_Hours < 20 THEN '10-19 Hours'
        ELSE '20+ Hours'
    END AS Overtime_Group,
    COUNT(*) AS Records,
    ROUND(AVG(Performance_Rating), 2) AS Avg_Performance,
    ROUND(AVG(Employee_Satisfaction), 2) AS Avg_Satisfaction
FROM monthly_performance
GROUP BY Overtime_Group
ORDER BY Avg_Performance DESC;


-- ============================================================
-- 7. TRAINING VS PERFORMANCE
-- ============================================================

SELECT
    CASE
        WHEN Training_Hours < 6 THEN '<6 Hours'
        WHEN Training_Hours < 11 THEN '6-10 Hours'
        WHEN Training_Hours < 20 THEN '11-19 Hours'
        ELSE '20+ Hours'
    END AS Training_Group,
    COUNT(*) AS Records,
    ROUND(AVG(Performance_Rating), 2) AS Avg_Performance
FROM monthly_performance
GROUP BY Training_Group
ORDER BY Avg_Performance DESC;


-- ============================================================
-- 8. EXIT RATE BY DEPARTMENT
-- ============================================================

SELECT
    Department,
    COUNT(DISTINCT Employee_ID) AS Total_Employees,
    COUNT(DISTINCT CASE
        WHEN Exit_Date IS NOT NULL THEN Employee_ID
    END) AS Exited_Employees,
    ROUND(
        100.0 *
        COUNT(DISTINCT CASE
            WHEN Exit_Date IS NOT NULL THEN Employee_ID
        END)
        / COUNT(DISTINCT Employee_ID),
        2
    ) AS Exit_Rate_Percent
FROM employees
GROUP BY Department
ORDER BY Exit_Rate_Percent DESC;


-- ============================================================
-- 9. ACTIVE VS EXITED EMPLOYEE PROFILE
-- ============================================================

SELECT
    CASE
        WHEN e.Exit_Date IS NULL THEN 'Active'
        ELSE 'Exited'
    END AS Employee_Status,
    COUNT(DISTINCT e.Employee_ID) AS Employee_Count,
    ROUND(AVG(m.Performance_Rating), 2) AS Avg_Performance,
    ROUND(AVG(m.Employee_Satisfaction), 2) AS Avg_Satisfaction,
    ROUND(AVG(m.Engagement_Index), 2) AS Avg_Engagement,
    ROUND(AVG(m.Overtime_Hours), 2) AS Avg_Overtime
FROM employees e
JOIN monthly_performance m
    ON e.Employee_ID = m.Employee_ID
GROUP BY Employee_Status;


-- ============================================================
-- 10. BUSINESS PERFORMANCE BY DEPARTMENT
-- ============================================================

SELECT
    Department,
    ROUND(SUM(Sales_Actual), 2) AS Total_Sales_Actual,
    ROUND(SUM(Sales_Target), 2) AS Total_Sales_Target,
    ROUND(
        100.0 * SUM(Sales_Actual) / SUM(Sales_Target),
        2
    ) AS Sales_Achievement_Percent,
    ROUND(AVG(Customer_Satisfaction), 2) AS Avg_Customer_Satisfaction,
    ROUND(AVG(On_Time_Delivery), 2) AS Avg_On_Time_Delivery
FROM business_outcomes
GROUP BY Department
ORDER BY Sales_Achievement_Percent DESC;


-- ============================================================
-- 11. STORE-LEVEL BUSINESS PERFORMANCE
-- ============================================================

SELECT
    Store_ID,
    ROUND(SUM(Sales_Actual), 2) AS Total_Sales,
    ROUND(SUM(Sales_Target), 2) AS Total_Target,
    ROUND(
        100.0 * SUM(Sales_Actual) / SUM(Sales_Target),
        2
    ) AS Sales_Achievement_Percent,
    ROUND(AVG(Customer_Satisfaction), 2) AS Avg_Customer_Satisfaction,
    ROUND(AVG(On_Time_Delivery), 2) AS Avg_On_Time_Delivery
FROM business_outcomes
GROUP BY Store_ID
ORDER BY Sales_Achievement_Percent DESC;


-- ============================================================
-- 12. MONTHLY BUSINESS TREND
-- ============================================================

SELECT
    Year_Month,
    ROUND(SUM(Sales_Actual), 2) AS Total_Sales_Actual,
    ROUND(SUM(Sales_Target), 2) AS Total_Sales_Target,
    ROUND(
        100.0 * SUM(Sales_Actual) / SUM(Sales_Target),
        2
    ) AS Sales_Achievement_Percent,
    ROUND(AVG(Customer_Satisfaction), 2) AS Avg_Customer_Satisfaction,
    ROUND(AVG(On_Time_Delivery), 2) AS Avg_On_Time_Delivery
FROM business_outcomes
GROUP BY Year_Month
ORDER BY Year_Month;
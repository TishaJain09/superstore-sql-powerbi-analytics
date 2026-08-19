-- ============================================================
-- FILE: 06_Phase5_RFM_Cohort_Advanced.sql
-- PHASE 5: RFM Analysis, Cohort Analysis, Views, Stored Procedures
-- ============================================================

USE superstore_db;

-- ============================================================
-- Q1: RFM ANALYSIS (Customer Segmentation)
-- RFM = Recency, Frequency, Monetary
--   Recency  = last order ko kitne din ho gaye (kam better hai)
--   Frequency = kitni baar order kiya (zyada better hai)
--   Monetary  = total kitna spend kiya (zyada better hai)
-- Business use: pata chalta hai kaunse customers "loyal/high-value"
-- hain aur kaunse "churn" (chhod) ho rahe hain
-- ============================================================
WITH customer_rfm AS (
    SELECT
        Customer_Name,
        -- Recency: aakhri order se lekar dataset ki sabse recent date tak kitne din
        DATEDIFF((SELECT MAX(Order_Date) FROM orders), MAX(Order_Date)) AS Recency,
        -- Frequency: kitne alag orders diye
        COUNT(DISTINCT Order_ID) AS Frequency,
        -- Monetary: total kitna spend kiya
        SUM(Sales) AS Monetary
    FROM orders
    GROUP BY Customer_Name
)
SELECT
    Customer_Name, Recency, Frequency, Monetary,
    CASE
        WHEN Recency <= 30 THEN 'Active'
        WHEN Recency <= 90 THEN 'At Risk'
        ELSE 'Churned'
    END AS Recency_Segment,
    CASE
        WHEN Monetary >= 5000 THEN 'High Value'
        WHEN Monetary >= 1500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Value_Segment
FROM customer_rfm
ORDER BY Monetary DESC;


-- ============================================================
-- Q2: COHORT ANALYSIS (Retention over time)
-- Cohort = customers ko unke "PEHLE purchase month" ke hisab se
-- group karna, phir dekhna wo aage ke mahino me wapas aaye ya nahi
-- Business use: "naye customers kitne mahino tak tikte hain" pata chalta hai
-- ============================================================
WITH first_purchase AS (
    -- Har customer ka pehla order kis mahine me tha
    SELECT Customer_Name, MIN(DATE_FORMAT(Order_Date, '%Y-%m')) AS Cohort_Month
    FROM orders
    GROUP BY Customer_Name
),
customer_orders AS (
    -- Har order ke saath uska cohort month bhi jodo
    SELECT
        o.Customer_Name,
        DATE_FORMAT(o.Order_Date, '%Y-%m') AS Order_Month,
        fp.Cohort_Month
    FROM orders o
    JOIN first_purchase fp ON o.Customer_Name = fp.Customer_Name
)
SELECT
    Cohort_Month,
    -- Kitne mahine baad ye order hua (0 = pehla mahina, 1 = agla mahina...)
    TIMESTAMPDIFF(MONTH,
        STR_TO_DATE(CONCAT(Cohort_Month, '-01'), '%Y-%m-%d'),
        STR_TO_DATE(CONCAT(Order_Month, '-01'), '%Y-%m-%d')
    ) AS Months_Since_First_Purchase,
    COUNT(DISTINCT Customer_Name) AS Active_Customers
FROM customer_orders
GROUP BY Cohort_Month, Months_Since_First_Purchase
ORDER BY Cohort_Month, Months_Since_First_Purchase;


-- ============================================================
-- Q3: VIEW banana (reusable saved query)
-- VIEW = ek query ko permanently save kar dena ek "virtual table"
-- ki tarah - baar baar poori query likhne ki zaroorat nahi,
-- bas view ka naam SELECT karo
-- ============================================================
CREATE OR REPLACE VIEW customer_rfm_view AS
SELECT
    Customer_Name,
    DATEDIFF((SELECT MAX(Order_Date) FROM orders), MAX(Order_Date)) AS Recency,
    COUNT(DISTINCT Order_ID) AS Frequency,
    SUM(Sales) AS Monetary
FROM orders
GROUP BY Customer_Name;

-- Ab is view ko NORMAL TABLE ki tarah use kar sakte ho:
SELECT * FROM customer_rfm_view WHERE Monetary > 3000 ORDER BY Monetary DESC;


-- ============================================================
-- Q4: STORED PROCEDURE banana (reusable saved "function with input")
-- Procedure = ek chhota "program" jo INPUT (parameter) leta hai
-- aur us hisab se result deta hai - jaise ek reusable tool
-- ============================================================
DELIMITER //

CREATE PROCEDURE GetRegionSales(IN region_name VARCHAR(20))
BEGIN
    SELECT Category, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
    FROM orders
    WHERE Region = region_name
    GROUP BY Category;
END //

DELIMITER ;

-- Ab procedure ko CALL karo, jo bhi region chahiye wo daalo:
CALL GetRegionSales('East');
CALL GetRegionSales('West');


-- ============================================================
-- Q5: Query Optimization - EXPLAIN
-- EXPLAIN se pata chalta hai MySQL query ko andar se kaise
-- chalata hai (kitni rows scan karta hai, index use hota hai ya nahi)
-- Interview me isko samajhna "advanced" candidate dikhata hai
-- ============================================================
EXPLAIN SELECT * FROM orders WHERE Region = 'East';

-- Agar 'Region' pe baar baar filter lagate ho, ek INDEX bana sakte ho
-- taaki query fast chale (bade data me ye bahut fark dalta hai)
CREATE INDEX idx_region ON orders(Region);

-- Ab dobara EXPLAIN chalao aur dekho 'rows' aur 'key' column me fark aaya
EXPLAIN SELECT * FROM orders WHERE Region = 'East';

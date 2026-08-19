-- ============================================================
-- FILE: 04_Phase3_Intermediate_Queries.sql
-- PHASE 3: JOINs, Subqueries, CASE, HAVING vs WHERE
-- ============================================================

USE superstore_db;

-- ---------------------------------------------------------
-- SETUP: 2 chhoti tables bana rahe hain JOIN practice ke liye
-- Real companies me data ek table me nahi hota, alag-alag
-- tables me hota hai (Orders, Employees, Returns waghera)
-- ---------------------------------------------------------

-- Table 1: Har Region ka Manager kaun hai
CREATE TABLE IF NOT EXISTS regional_managers (
    Region        VARCHAR(20) PRIMARY KEY,
    Manager_Name  VARCHAR(50)
);

INSERT INTO regional_managers (Region, Manager_Name) VALUES
    ('East', 'Anil Kapoor'),
    ('West', 'Sarah Mitchell'),
    ('Central', 'Rajesh Nair'),
    ('South', 'Priya Menon');

-- Table 2: Kaunse orders return hue (sirf ~15% orders return maan rahe hain)
CREATE TABLE IF NOT EXISTS returns (
    Order_ID   VARCHAR(20) PRIMARY KEY,
    Returned   VARCHAR(5)
);

INSERT INTO returns (Order_ID, Returned)
SELECT DISTINCT Order_ID, 'Yes'
FROM orders
WHERE RAND() < 0.15;

-- ============================================================
-- Q1: Har order ke saath uske Region ka Manager Name bhi dikhao
-- INNER JOIN = dono tables me sirf MATCHING rows dikhata hai
-- Syntax: JOIN table2 ON table1.column = table2.column
-- ============================================================
SELECT o.Order_ID, o.Region, o.Sales, rm.Manager_Name
FROM orders o
INNER JOIN regional_managers rm ON o.Region = rm.Region
LIMIT 20;
-- 'o' aur 'rm' = table ke chhote naam (alias), likhna aasaan banane ke liye


-- ============================================================
-- Q2: Har order ke saath dikhao ki wo Return hua ya nahi
-- LEFT JOIN = LEFT table (orders) ki SAARI rows dikhata hai,
-- chahe RIGHT table (returns) me match mile ya na mile
-- (agar match nahi mila toh us column me NULL aayega)
-- ============================================================
SELECT o.Order_ID, o.Product_Name, o.Sales,
       COALESCE(r.Returned, 'No') AS Is_Returned
       -- COALESCE = agar value NULL hai toh 'No' dikhao, warna asli value
FROM orders o
LEFT JOIN returns r ON o.Order_ID = r.Order_ID
LIMIT 20;


-- ============================================================
-- Q3: Kaunse Customers hain jinki Total Sales, overall
-- average customer se zyada hai? (High-value customers)
-- SUBQUERY = query ke andar ek aur query (pehle andar wali chalti hai)
-- ============================================================
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_Name
HAVING SUM(Sales) > (
    -- Ye andar wali query pehle chalegi: average nikalegi
    SELECT AVG(Total_Sales) FROM (
        SELECT SUM(Sales) AS Total_Sales
        FROM orders
        GROUP BY Customer_Name
    ) AS customer_totals
)
ORDER BY Total_Sales DESC;


-- ============================================================
-- Q4: Har order ko 'High', 'Medium', 'Low' value me classify karo
-- CASE = IF-ELSE jaisa logic SQL me
-- ============================================================
SELECT Order_ID, Sales,
    CASE
        WHEN Sales >= 500 THEN 'High Value'
        WHEN Sales >= 100 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Category
FROM orders
LIMIT 20;


-- ============================================================
-- Q5: Kaunsi Categories ki Total Sales 50000 se zyada hai?
-- WHERE vs HAVING ka fark:
--   WHERE = GROUP BY se PEHLE row-level filter karta hai
--   HAVING = GROUP BY ke BAAD, group ke result pe filter karta hai
--   (isliye SUM/AVG/COUNT jaisi aggregate cheez pe HAVING use hota hai)
-- ============================================================
SELECT Category, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Category
HAVING SUM(Sales) > 50000
ORDER BY Total_Sales DESC;

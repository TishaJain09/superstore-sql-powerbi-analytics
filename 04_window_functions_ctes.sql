-- ============================================================
-- FILE: 05_Phase4_Window_Functions_CTEs.sql
-- PHASE 4: Window Functions & CTEs (Interview ka favorite topic)
-- ============================================================

USE superstore_db;

-- ============================================================
-- WINDOW FUNCTION KYA HAI? (Pehle samjho, phir queries dekho)
--
-- Normal GROUP BY: rows ko GROUP karke sirf SUMMARY dikhata hai
-- (individual rows KHO jaati hain)
--
-- Window Function: HAR ROW ko as-it-is rakhte hue, uske saath
-- ek EXTRA calculated column jod deta hai (jaise "iska rank
-- kya hai" ya "running total kitna hai")
--
-- Syntax pattern: FUNCTION() OVER (PARTITION BY ... ORDER BY ...)
--   PARTITION BY = data ko kis basis pe groups me baanto
--                  (GROUP BY jaisa hi hai, but rows nahi khoti)
--   ORDER BY     = us group ke andar kis order me calculate karo
-- ============================================================


-- ============================================================
-- Q1: Har Category ke andar, products ko Profit ke hisab se RANK do
-- RANK() = 1,2,2,4 (agar 2 same values hain toh dono ko same
--          rank milta hai, lekin agla number skip ho jaata hai)
-- DENSE_RANK() = 1,2,2,3 (skip nahi karta)
-- ============================================================
SELECT
    Category,
    Product_Name,
    Profit,
    RANK() OVER (PARTITION BY Category ORDER BY Profit DESC) AS Profit_Rank,
    DENSE_RANK() OVER (PARTITION BY Category ORDER BY Profit DESC) AS Dense_Profit_Rank
FROM orders
ORDER BY Category, Profit_Rank
LIMIT 30;


-- ============================================================
-- Q2: Har Category ka TOP 3 sabse profitable product nikalo
-- ROW_NUMBER() = 1,2,3,4... (hamesha unique number deta hai,
--                ties ke case me bhi, kabhi repeat nahi hota)
-- Yaha CTE use kiya hai (WITH ... AS) taaki result ko naam
-- de ke usme WHERE laga sakein (window function pe seedha
-- WHERE nahi laga sakte, isliye CTE zaroori hai)
-- ============================================================
WITH ranked_products AS (
    SELECT
        Category,
        Product_Name,
        Profit,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Profit DESC) AS rn
    FROM orders
)
SELECT Category, Product_Name, Profit
FROM ranked_products
WHERE rn <= 3;


-- ============================================================
-- Q3: Month-over-Month Sales Growth % nikalo
-- LAG() = PICHLI row ki value nikal ke deta hai (yaha pichle mahine ki sales)
-- Pehle CTE se monthly sales nikalte hain, phir LAG use karte hain
-- ============================================================
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
        SUM(Sales) AS Total_Sales
    FROM orders
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
)
SELECT
    Month,
    Total_Sales,
    LAG(Total_Sales) OVER (ORDER BY Month) AS Previous_Month_Sales,
    ROUND(
        (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Month))
        / LAG(Total_Sales) OVER (ORDER BY Month) * 100, 2
    ) AS Growth_Percent
FROM monthly_sales
ORDER BY Month;


-- ============================================================
-- Q4: Running Total (cumulative sales, date ke order me badhte hue)
-- SUM() OVER (ORDER BY ...) = har row tak ka total jod ke deta hai
-- (ye finance me bahut common hai - "aaj tak total kitna hua")
-- ============================================================
WITH daily_sales AS (
    SELECT Order_Date, SUM(Sales) AS Daily_Sales
    FROM orders
    GROUP BY Order_Date
)
SELECT
    Order_Date,
    Daily_Sales,
    SUM(Daily_Sales) OVER (ORDER BY Order_Date) AS Running_Total
FROM daily_sales
ORDER BY Order_Date
LIMIT 30;


-- ============================================================
-- Q5: 7-Day Moving Average of Sales (trend smooth karne ke liye)
-- ROWS BETWEEN 6 PRECEDING AND CURRENT ROW = current row +
-- pichli 6 rows = total 7 rows ka average
-- ============================================================
WITH daily_sales AS (
    SELECT Order_Date, SUM(Sales) AS Daily_Sales
    FROM orders
    GROUP BY Order_Date
)
SELECT
    Order_Date,
    Daily_Sales,
    ROUND(AVG(Daily_Sales) OVER (
        ORDER BY Order_Date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS Moving_Avg_7Day
FROM daily_sales
ORDER BY Order_Date
LIMIT 30;


-- ============================================================
-- Q6: Pichhle Phase ka "Above Average Customer" sawaal,
-- ab CTE se likha hua - dekho kitna CLEAN aur readable hai
-- subquery wale version ke comparison me
-- ============================================================
WITH customer_totals AS (
    SELECT Customer_Name, SUM(Sales) AS Total_Sales
    FROM orders
    GROUP BY Customer_Name
),
avg_sales AS (
    SELECT AVG(Total_Sales) AS Avg_Total FROM customer_totals
)
SELECT ct.Customer_Name, ct.Total_Sales
FROM customer_totals ct, avg_sales a
WHERE ct.Total_Sales > a.Avg_Total
ORDER BY ct.Total_Sales DESC;

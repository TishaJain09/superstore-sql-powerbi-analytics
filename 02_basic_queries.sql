-- ============================================================
-- FILE: 03_Phase2_Basic_Queries.sql
-- PHASE 2: Basic SQL - SELECT, WHERE, GROUP BY, ORDER BY, Aggregates
-- ============================================================

USE superstore_db;

-- Q1: Total Sales aur Total Profit kitna hua ab tak?
-- SUM() = sabhi rows ke values ko add karta hai
SELECT SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM orders;

-- Q2: Region-wise total sales kitni hui?
-- GROUP BY = data ko groups me baant kar har group ka result dikhata hai
SELECT Region, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Q3: Top 10 sabse zyada profit wale orders kaunse hain?
-- ORDER BY ... DESC = sabse bade se chhote order me sort karta hai
-- LIMIT = sirf itni rows dikhao
SELECT Order_ID, Product_Name, Profit
FROM orders
ORDER BY Profit DESC
LIMIT 10;

-- Q4: Har Category me kitne orders hue?
-- COUNT() = kitni rows hain wo ginta hai
SELECT Category, COUNT(*) AS Total_Orders
FROM orders
GROUP BY Category;

-- Q5: Har Customer Segment ka average discount kitna hai?
-- AVG() = average (aukat) nikalta hai
SELECT Segment, AVG(Discount) AS Avg_Discount
FROM orders
GROUP BY Segment;

-- Q6: Kaunse orders me loss hua (Profit negative hai)?
-- WHERE = condition lagakar sirf matching rows dikhata hai
SELECT Order_ID, Product_Name, Sales, Profit
FROM orders
WHERE Profit < 0
ORDER BY Profit ASC
LIMIT 10;

-- Q7: Furniture category me kaunsi-kaunsi unique Sub-Categories hain?
-- DISTINCT = duplicate values hata kar sirf unique values dikhata hai
SELECT DISTINCT Sub_Category
FROM orders
WHERE Category = 'Furniture';

-- Q8: South region me un orders ki list do jisme Quantity 5 se zyada thi
-- AND = do conditions ek saath lagane ke liye
SELECT Order_ID, City, Quantity, Sales
FROM orders
WHERE Region = 'South' AND Quantity > 5
ORDER BY Sales DESC;

-- ============================================================
-- FILE: 02_Create_Superstore_Tables.sql
-- PURPOSE: Database aur table banana Superstore dataset ke liye
-- HOW TO RUN: Poori file select karo, phir Ctrl+Shift+Enter dabao
--             (ya top ka double-lightning icon dabao)
-- ============================================================


-- STEP 1: Naya database banao
-- 'CREATE DATABASE' ek naya "container" banata hai jisme
-- hum apne saare tables rakhenge (jaise ek naya project folder)
CREATE DATABASE IF NOT EXISTS superstore_db;

-- STEP 2: Batao ki hum isi database ke andar kaam karenge
-- Jab tak 'USE' nahi chalayenge, MySQL ko nahi pata hoga
-- ki humari agli queries kis database pe apply honi hain
USE superstore_db;


-- STEP 3: Table banao
-- 'CREATE TABLE' se hum table ka structure define karte hain -
-- yani kaunse columns honge aur har column me kis type ka
-- data store hoga (data type)

CREATE TABLE orders (

    -- Row_ID: Har row ka unique number, 1 se start hota hai
    -- INT use kiya kyunki ye poora number hai, decimal nahi
    -- PRIMARY KEY matlab: is column ki value kabhi repeat nahi hogi,
    -- ye har row ko uniquely identify karta hai
    Row_ID              INT PRIMARY KEY,

    -- Order_ID: Jaise "CA-2017-152156" - letters + numbers mix
    -- VARCHAR(20) use kiya kyunki ye text hai aur length kam hai
    -- 20 ka matlab hai max 20 characters allowed
    Order_ID            VARCHAR(20),

    -- Order_Date: Sirf date chahiye (time nahi), isliye DATE type
    Order_Date           DATE,

    -- Ship_Date: Order ship hone ki date
    Ship_Date            DATE,

    -- Ship_Mode: Jaise "Standard Class", "Second Class" - chota text
    Ship_Mode            VARCHAR(20),

    -- Customer_ID: Jaise "CG-12520" - short code
    Customer_ID          VARCHAR(20),

    -- Customer_Name: Naam, length vary karti hai isliye VARCHAR
    Customer_Name        VARCHAR(100),

    -- Segment: "Consumer", "Corporate", "Home Office" - short category
    Segment              VARCHAR(20),

    -- Country, City, State: Sab text hain, VARCHAR use karenge
    Country              VARCHAR(50),
    City                 VARCHAR(50),
    State                VARCHAR(50),

    -- Postal_Code: Ye number jaisa dikhta hai lekin ismein
    -- calculation nahi karni (jaise "07016" me leading zero
    -- important hai), isliye VARCHAR use karte hain, INT nahi
    Postal_Code           VARCHAR(10),

    -- Region: "East", "West", "Central", "South"
    Region               VARCHAR(20),

    -- Product_ID: Jaise "FUR-BO-10001798"
    Product_ID           VARCHAR(30),

    -- Category: "Furniture", "Office Supplies", "Technology"
    Category             VARCHAR(30),

    -- Sub_Category: "Chairs", "Phones", "Binders" etc.
    Sub_Category          VARCHAR(30),

    -- Product_Name: Lamba naam ho sakta hai, isliye zyada length di
    Product_Name          VARCHAR(200),

    -- Sales: Ye MONEY hai, isliye DECIMAL use kiya (INT ya FLOAT nahi)
    -- DECIMAL(10,2) matlab: total 10 digits allowed, jisme 2 digits
    -- decimal ke baad honge -> max value: 99999999.99
    -- Money ke liye hamesha DECIMAL use karo, FLOAT nahi
    -- (FLOAT me rounding errors aa sakti hain, jo finance me risky hai)
    Sales                DECIMAL(10,2),

    -- Quantity: Kitne items order kiye - poora number
    Quantity             INT,

    -- Discount: Jaise 0.20 (20%) - chota decimal number
    -- DECIMAL(4,2) -> max value 99.99, yahan 0.00 se 1.00 tak hoga
    Discount             DECIMAL(4,2),

    -- Profit: Ye bhi money hai (negative bhi ho sakta hai, loss ke case me)
    -- DECIMAL isliye kyunki exact paisa calculation chahiye
    Profit               DECIMAL(10,2)

);


-- STEP 4: Verify karo ki table sahi bana ya nahi
-- 'DESCRIBE' command table ka structure dikhata hai
-- (columns, data types, sab kuch)
DESCRIBE orders;


-- ============================================================
-- AGLA STEP: Ab 'Table Data Import Wizard' use karke
-- Superstore.csv ka data is 'orders' table me import karo
-- (Setup guide ke Section G me steps diye hain)
--
-- Import ke baad ye query chalake check karo data aaya ya nahi:
-- SELECT * FROM orders LIMIT 10;
-- ============================================================

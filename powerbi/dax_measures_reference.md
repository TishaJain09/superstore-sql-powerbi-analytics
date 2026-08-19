# Phase 6: Power BI DAX Measures Reference

## DAX Measure Kaise Banate Hain (Har Baar Yehi Steps)
1. Power BI me right side "Data" panel me apni table (jaise `orders`) pe right-click karo
2. "New Measure" click karo
3. Formula bar khulegi, neeche di gayi koi bhi measure copy-paste karo
4. Enter dabao — measure ban jaayegi, "Data" panel me table ke andar dikhegi (calculator icon ke saath)

---

## Basic KPI Measures

```dax
Total Sales = SUM(orders[Sales])
```
**Kya karta hai:** Sales column ka simple total. Ye hi humari Phase 2 wali `SUM(Sales)` query ka Power BI version hai.

```dax
Total Profit = SUM(orders[Profit])
```
Same logic, Profit column pe.

```dax
Total Orders = DISTINCTCOUNT(orders[Order_ID])
```
**Kya karta hai:** Unique Order_ID kitne hain ginta hai (Phase 2 ka `COUNT(DISTINCT Order_ID)` yaad hai?).

```dax
Profit Margin % = DIVIDE([Total Profit], [Total Sales], 0)
```
**Kya karta hai:** Profit ko Sales se divide karke % nikalta hai. `DIVIDE()` isliye use kiya (simple `/` ki jagah) kyuki agar Sales 0 ho toh error na aaye — teesra argument `0` bolta hai "agar divide by zero ho toh 0 dikha do, error mat do."

```dax
Average Order Value = DIVIDE([Total Sales], [Total Orders], 0)
```
**Kya karta hai:** Har order ki average value — business metric jo batata hai "ek customer average kitna kharch karta hai per order."

---

## Time Intelligence Measures (YoY, YTD)

Ye kaam karne ke liye Power BI ko ek proper "Date Table" chahiye:
1. Power BI me "Modeling" tab \u2192 "New Table" \u2192 ye formula daalo:
```dax
DateTable = CALENDAR(DATE(2022,1,1), DATE(2025,12,31))
```
2. Iss DateTable ko `orders[Order_Date]` ke saath relationship banao (Model view me drag-drop karke connect karo)

Phir ye measures banao:

```dax
YTD Sales = TOTALYTD([Total Sales], DateTable[Date])
```
**Kya karta hai:** "Year-To-Date" — is saal ki shuruwaat se ab tak ka total sales.

```dax
Previous Year Sales = CALCULATE([Total Sales], SAMEPERIODLASTYEAR(DateTable[Date]))
```
**Kya karta hai:** Pichle saal ka sales, isi period ke liye (Phase 4 ke `LAG()` jaisa hi concept, bas Power BI ka tarika).

```dax
YoY Growth % = DIVIDE([Total Sales] - [Previous Year Sales], [Previous Year Sales], 0)
```
**Kya karta hai:** Growth % nikalta hai — bilkul Phase 4 wale MoM growth query jaisa logic.

---

## Customer Segmentation Measure (RFM se connect)

Agar `customer_rfm_view` table load ki hai:

```dax
High Value Customers = CALCULATE(
    DISTINCTCOUNT(customer_rfm_view[Customer_Name]),
    customer_rfm_view[Monetary] >= 5000
)
```
**Kya karta hai:** High-value customers ki ginti — Phase 5 ke RFM CASE statement ka Power BI version.

---

## Important DAX Concepts (Interview ke liye)

| Function | Kaam |
|---|---|
| `SUM()` | Column ka total |
| `CALCULATE()` | Kisi measure ko naye filter ke saath dobara calculate karna (DAX ka sabse powerful function) |
| `DIVIDE()` | Safe division (0 se divide hone pe error nahi aata) |
| `SAMEPERIODLASTYEAR()` | Pichle saal ka wahi period nikalna |
| `TOTALYTD()` | Year-to-date total |
| `DISTINCTCOUNT()` | Unique values ginta hai |

**CALCULATE() sabse important hai — isko samjho:** `CALCULATE(measure, condition)` ka matlab hai "is measure ko normal se calculate karo, lekin is extra condition ko bhi filter ki tarah laga do." Ye bilkul SQL ke `WHERE` jaisa kaam karta hai, bas DAX me.

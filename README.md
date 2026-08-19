# Superstore Sales & Business Analytics — SQL + Power BI Project

End-to-end business analytics project built on a retail sales dataset — from database design and advanced SQL analysis in MySQL, to a fully interactive 4-page Power BI dashboard.

## 🎯 Project Overview

This project simulates a real-world business analytics workflow: I designed a relational database, wrote SQL queries ranging from basic aggregations to advanced window functions and customer segmentation (RFM), and built a professional, interactive Power BI dashboard to communicate the findings.

**Goal:** Answer real business questions like *"Which regions and products drive the most profit?"*, *"Which customers are most valuable, and who's at risk of churning?"*, and *"Where is the business losing money?"*

## 🛠️ Tech Stack

- **Database:** MySQL 8.0
- **BI Tool:** Power BI Desktop
- **Language:** SQL, DAX

## 📊 Dataset

Retail sales data (Superstore-style) with 1,500 order records across Furniture, Office Supplies, and Technology categories, spanning 4 US regions and 3 customer segments.

## 🗂️ SQL Concepts Demonstrated

| Category | Concepts |
|---|---|
| Fundamentals | SELECT, WHERE, GROUP BY, ORDER BY, aggregate functions |
| Joins | INNER JOIN, LEFT JOIN, multi-table relationships |
| Advanced Filtering | Subqueries, CASE statements, HAVING vs WHERE |
| Window Functions | RANK, DENSE_RANK, ROW_NUMBER, LAG, running totals, moving averages |
| CTEs | Common Table Expressions for readable, layered queries |
| Customer Analytics | RFM Analysis (Recency, Frequency, Monetary), Cohort/Retention Analysis |
| Database Objects | Views, Stored Procedures (parameterized) |
| Performance | EXPLAIN query plans, Indexing |

## 📈 Power BI Dashboard — 4 Pages

1. **Executive Summary** — KPI cards (Sales, Profit, Margin%, Orders, AOV), regional sales, monthly trend, category breakdown, top products
2. **Regional & Product Deep-Dive** — Interactive US map, category/sub-category breakdown, conditional-formatted profitability table
3. **Customer Segmentation (RFM)** — Scatter plot of customer value, segment distribution, top customers
4. **Returns & Profitability** — Return rate analysis, category profit comparison, loss-making order investigation with data-backed insights

Built with custom DAX measures (including time intelligence), a custom color theme, and cross-filtering slicers throughout.

## 💡 Key Business Insights

- Identified that order losses were spread across multiple categories rather than concentrated in one product — pointing to a broader discounting policy issue
- Found the return rate (14.9%) exceeds typical retail benchmarks (~10%), flagging a potential quality/expectation-mismatch issue
- Segmented customers into High/Medium/Low value tiers using RFM analysis to support targeted retention strategies

## 📁 Repository Structure

```
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_basic_queries.sql
│   ├── 03_intermediate_queries.sql
│   ├── 04_window_functions_ctes.sql
│   └── 05_advanced_rfm_cohort.sql
├── powerbi/
│   ├── dax_measures_reference.md
│   └── theme.json
├── screenshots/
│   ├── page1_executive_summary.png
│   ├── page2_regional_deepdive.png
│   ├── page3_customer_segmentation.png
│   └── page4_returns_profitability.png
└── README.md
```

## 🚀 How to Reproduce

1. Run the SQL scripts in `sql/` sequentially in MySQL Workbench to build the database and run the analysis
2. Import the resulting tables into Power BI Desktop
3. Apply the DAX measures from `powerbi/dax_measures_reference.md`
4. Import `powerbi/theme.json` for the custom color theme

## 👤 Author

Built by [Tisha Jain] as a hands-on project to apply SQL and Power BI skills to a realistic business analytics scenario.

• [tj2003jain@gmail.com]

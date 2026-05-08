# SQL E-commerce Analytics Case Study

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Dataset](https://img.shields.io/badge/Dataset-500K%2B%20Rows-orange)

## Project Overview

This project performs end-to-end SQL analytics on a real-world UK-based e-commerce dataset containing over 500,000 transactions between 2010 and 2011.

The analysis focuses on:
- Revenue trends
- Customer behavior
- Product performance
- Business growth insights
- Advanced SQL analytics using CTEs and Window Functions

## Dataset Information

- **Source:** UCI E-commerce Dataset via Kaggle
- **Dataset Link:** https://www.kaggle.com/datasets/carrie1/ecommerce-data
- **Records:** ~541,000 transactions
- **Time Period:** 2010–2011

### Dataset Columns
- InvoiceNo
- StockCode
- Description
- Quantity
- InvoiceDate
- UnitPrice
- CustomerID
- Country


## Business Questions Solved

| # | Business Question | SQL Concepts Used |
|---|------------------|------------------|
| 1 | Total revenue by country | GROUP BY, Aggregates |
| 2 | Top 10 best-selling products | GROUP BY, LIMIT |
| 3 | Countries with revenue above £50K | HAVING |
| 4 | Monthly revenue trend | DATE_FORMAT |
| 5 | Top 10 customers by spend | Aggregations |
| 6 | Average order value per customer | Subqueries |
| 7 | Repeat customer analysis | HAVING |
| 8 | Customer lifetime value (LTV) | CTE |
| 9 | High-value products above average price | CTE |
| 10 | Year-over-year revenue comparison | CASE WHEN |
| 11 | Product revenue ranking within each country | RANK() |
| 12 | Running cumulative revenue | SUM() OVER |
| 13 | Customer spend percentile segmentation | NTILE() |
| 14 | Month-over-month revenue growth | LAG() |
| 15 | Top 3 customers per country | ROW_NUMBER() |

---

## SQL Concepts Demonstrated

### Core SQL
- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- LIMIT

### Aggregations
- SUM()
- AVG()
- COUNT()
- ROUND()

### Advanced SQL
- Common Table Expressions (CTEs)
- Subqueries
- Window Functions
- Ranking Functions
- Running Totals
- Date Functions

### Window Functions Used
- RANK()
- ROW_NUMBER()
- NTILE()
- LAG()
- SUM() OVER()

---

## Key Business Insights

- United Kingdom generated the majority of total revenue
- A small percentage of customers contributed heavily to total sales
- Revenue showed strong seasonal spikes during late 2011
- Repeat customers contributed significantly to business growth
- High-value customers had substantially larger average order values

---

## Tools & Technologies

- MySQL Workbench
- SQL
- Git & GitHub
- Kaggle Dataset

---

## How to Run the Project

### 1. Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/sql-ecommerce-analytics.git

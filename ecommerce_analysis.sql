
# Q1 — Total revenue by country
SELECT 
  Country,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM orders
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY Country
ORDER BY total_revenue DESC;

# Q2 — Top 10 best-selling products
SELECT 
  Description,
  SUM(Quantity) AS total_units_sold
FROM orders
WHERE Quantity > 0
GROUP BY Description
ORDER BY total_units_sold DESC
LIMIT 10;
SELECT COUNT(*) FROM orders;

#Q3 — Countries with revenue above £50,000 (HAVING)
SELECT 
  Country,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM orders
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY Country
HAVING total_revenue > 50000
ORDER BY total_revenue DESC;

#Q4 — Monthly revenue trend
SELECT 
  DATE_FORMAT(
    STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'),
    '%Y-%m'
  ) AS month,
  ROUND(SUM(Quantity * UnitPrice), 2) AS monthly_revenue
FROM orders
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY month
ORDER BY month;

#Q5 — Total spend per customer (top 10)
SELECT 
  CustomerID,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_spend,
  COUNT(DISTINCT InvoiceNo) AS total_orders
FROM orders
WHERE Quantity > 0 AND UnitPrice > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_spend DESC
LIMIT 10;

#Q6 — Average order value per customer
SELECT 
  CustomerID,
  ROUND(AVG(order_value), 2) AS avg_order_value
FROM (
  SELECT 
    CustomerID,
    InvoiceNo,
    SUM(Quantity * UnitPrice) AS order_value
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
    AND CustomerID IS NOT NULL
  GROUP BY CustomerID, InvoiceNo
) AS order_summary
GROUP BY CustomerID
ORDER BY avg_order_value DESC
LIMIT 10;

# Q7 — Repeat customers (more than 1 order)
SELECT 
  COUNT(*) AS repeat_customers
FROM (
  SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS order_count
  FROM orders
  WHERE CustomerID IS NOT NULL
  GROUP BY CustomerID
  HAVING order_count > 1
) AS repeats;

# Q8 — Customer LTV using CTE
WITH customer_revenue AS (
  SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS lifetime_value,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    MIN(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS first_order,
    MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS last_order
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
    AND CustomerID IS NOT NULL
  GROUP BY CustomerID
)
SELECT 
  CustomerID,
  ROUND(lifetime_value, 2) AS LTV,
  total_orders,
  first_order,
  last_order,
  DATEDIFF(last_order, first_order) AS customer_lifespan_days
FROM customer_revenue
ORDER BY LTV DESC
LIMIT 20;

# Q9 — High value products with above-average price (CTE)
WITH avg_price AS (
  SELECT AVG(UnitPrice) AS mean_price
  FROM orders
  WHERE UnitPrice > 0
)
SELECT 
  Description,
  ROUND(AVG(UnitPrice), 2) AS avg_unit_price,
  SUM(Quantity) AS total_sold
FROM orders, avg_price
WHERE UnitPrice > mean_price
  AND Quantity > 0
GROUP BY Description
ORDER BY avg_unit_price DESC
LIMIT 15;

# Q10 — Monthly revenue YoY comparison (CTE)
WITH monthly AS (
  SELECT 
    DATE_FORMAT(
      STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'),
      '%Y'
    ) AS yr,
    DATE_FORMAT(
      STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'),
      '%m'
    ) AS mo,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
  FROM orders
  WHERE Quantity > 0 
    AND UnitPrice > 0
  GROUP BY yr, mo
)
SELECT 
  mo AS month,
  MAX(CASE WHEN yr = '2010' THEN revenue END) AS revenue_2010,
  MAX(CASE WHEN yr = '2011' THEN revenue END) AS revenue_2011
FROM monthly
GROUP BY mo
ORDER BY mo;

# Q11 — Product revenue rank within each country
SELECT *
FROM (
  SELECT 
    Country,
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue,
    RANK() OVER (
      PARTITION BY Country 
      ORDER BY SUM(Quantity * UnitPrice) DESC
    ) AS rank_in_country
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
  GROUP BY Country, Description
) ranked
WHERE rank_in_country <= 3
ORDER BY Country, rank_in_country;

# Q12 — Running total revenue over time
SELECT 
  month,
  monthly_revenue,
  ROUND(SUM(monthly_revenue) OVER (ORDER BY month), 2) AS running_total
FROM (
  SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS monthly_revenue
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
  GROUP BY month
) AS monthly_data
ORDER BY month;

# Q13 — Customer spend percentile (NTILE)
SELECT 
  CustomerID,
  ROUND(total_spend, 2) AS total_spend,
  NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
FROM (
  SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS total_spend
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
    AND CustomerID IS NOT NULL
  GROUP BY CustomerID
) AS spend_data
ORDER BY total_spend DESC;

# Q14 — Month-over-month revenue growth % (LAG)
SELECT 
  month,
  monthly_revenue,
  LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue,
  ROUND(
    (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month)) 
    / LAG(monthly_revenue) OVER (ORDER BY month) * 100, 2
  ) AS mom_growth_pct
FROM (
  SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS monthly_revenue
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
  GROUP BY month
) AS monthly_data
ORDER BY month;

# Q15 — Top 3 customers per country (ROW_NUMBER)
SELECT *
FROM (
  SELECT 
    Country,
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_spend,
    ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Quantity * UnitPrice) DESC) AS rn
  FROM orders
  WHERE Quantity > 0 AND UnitPrice > 0
    AND CustomerID IS NOT NULL
  GROUP BY Country, CustomerID
) AS ranked
WHERE rn <= 3
ORDER BY Country, rn;

 
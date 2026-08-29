CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(30),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(30),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(14,2),
    quantity INT,
    discount DECIMAL(6,4),
    profit DECIMAL(14,2),
    year INT,
    month INT,
    month_name VARCHAR(10),
    quarter_name VARCHAR(5),
    profit_margin_pct DECIMAL(10,4),
    shipping_days INT,
    first_purchase_date DATE,
    customer_type VARCHAR(30)
);

-- 1. Overall KPIs
SELECT ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit,
       ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM orders;

-- 2. Orders, customers, products
SELECT COUNT(DISTINCT order_id) AS orders,
       COUNT(DISTINCT customer_id) AS customers,
       COUNT(DISTINCT product_id) AS products
FROM orders;

-- 3. Average order value
SELECT ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) AS average_order_value
FROM orders;

-- 4. Category performance
SELECT category,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit,
       ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS margin_pct
FROM orders
GROUP BY category
ORDER BY revenue DESC;

-- 5. Sub-category performance
SELECT sub_category,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY sub_category
ORDER BY revenue DESC;

-- 6. Top 10 products by revenue
SELECT product_name,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- 7. Bottom 10 products by profit
SELECT product_name,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY product_name
ORDER BY profit ASC
LIMIT 10;

-- 8. Yearly trend
SELECT year,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY year
ORDER BY year;

-- 9. Monthly trend
SELECT year, month, month_name,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY year, month, month_name
ORDER BY year, month;

-- 10. Customer performance
SELECT customer_id, customer_name,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY customer_id, customer_name
ORDER BY revenue DESC;

-- 11. New vs returning
SELECT customer_type,
       COUNT(DISTINCT customer_id) AS customers,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY customer_type;

-- 12. Region performance
SELECT region,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit,
       COUNT(DISTINCT order_id) AS orders
FROM orders
GROUP BY region
ORDER BY revenue DESC;

-- 13. Discount vs profit
SELECT discount,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit,
       ROUND(AVG(profit),2) AS average_profit
FROM orders
GROUP BY discount
ORDER BY discount;

-- 14. Loss-making sub-categories
SELECT sub_category,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY profit ASC;

-- 15. State performance for Power BI
SELECT state, region,
       ROUND(SUM(sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit
FROM orders
GROUP BY state, region
ORDER BY revenue DESC;

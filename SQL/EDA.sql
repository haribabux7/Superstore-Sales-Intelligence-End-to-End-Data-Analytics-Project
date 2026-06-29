-- EDA.sql: SQL Exploratory Data Analysis for the Superstore dataset

-- 1. Dataset Summary
SELECT
    COUNT(*) AS rows_count,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    SUM(profit) / NULLIF(SUM(revenue), 0) AS profit_margin
FROM superstore_cleaned;

-- 2. Yearly trend
SELECT order_year, SUM(revenue) AS revenue, SUM(profit) AS profit, COUNT(DISTINCT order_id) AS orders
FROM superstore_cleaned
GROUP BY order_year
ORDER BY order_year;

-- 3. Monthly trend
SELECT order_month, SUM(revenue) AS revenue, SUM(profit) AS profit, COUNT(DISTINCT order_id) AS orders
FROM superstore_cleaned
GROUP BY order_month
ORDER BY order_month;

-- 4. Category analysis
SELECT category, SUM(revenue) AS revenue, SUM(profit) AS profit, SUM(profit)/NULLIF(SUM(revenue),0) AS margin
FROM superstore_cleaned
GROUP BY category
ORDER BY revenue DESC;

-- 5. Sub-category analysis
SELECT sub_category, SUM(revenue) AS revenue, SUM(profit) AS profit, SUM(quantity) AS units_sold
FROM superstore_cleaned
GROUP BY sub_category
ORDER BY profit ASC;

-- 6. Segment analysis
SELECT segment, COUNT(DISTINCT customer_id) AS customers, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM superstore_cleaned
GROUP BY segment
ORDER BY revenue DESC;

-- 7. Region/state performance
SELECT region, state, SUM(revenue) AS revenue, SUM(profit) AS profit, SUM(profit)/NULLIF(SUM(revenue),0) AS margin
FROM superstore_cleaned
GROUP BY region, state
ORDER BY profit DESC;

-- 8. Top 10 products by revenue
SELECT product_name, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM superstore_cleaned
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- 9. Bottom 10 products by profit
SELECT product_name, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM superstore_cleaned
GROUP BY product_name
ORDER BY profit ASC
LIMIT 10;

-- 10. Discount impact
SELECT discount_band, COUNT(*) AS order_lines, SUM(revenue) AS revenue, SUM(profit) AS profit, AVG(profit_margin) AS avg_margin
FROM superstore_cleaned
GROUP BY discount_band
ORDER BY AVG(discount);

-- 11. Shipping mode performance
SELECT ship_mode, AVG(ship_days) AS avg_ship_days, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM superstore_cleaned
GROUP BY ship_mode
ORDER BY revenue DESC;

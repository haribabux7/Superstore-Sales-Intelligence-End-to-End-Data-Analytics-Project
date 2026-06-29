-- Data_Cleaning.sql
-- Dialect: PostgreSQL-compatible SQL. Adapt DATE parsing functions for MySQL/SQL Server if needed.

DROP TABLE IF EXISTS superstore_raw;
CREATE TABLE superstore_raw (
    row_id INT,
    order_id VARCHAR(50),
    order_date TEXT,
    ship_date TEXT,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(150),
    segment VARCHAR(50),
    country VARCHAR(80),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(80),
    sub_category VARCHAR(80),
    product_name TEXT,
    sales NUMERIC(12,4),
    quantity INT,
    discount NUMERIC(6,4),
    profit NUMERIC(12,4)
);

-- COPY superstore_raw FROM '/path/Raw_Data.csv' WITH CSV HEADER ENCODING 'LATIN1';

DROP TABLE IF EXISTS superstore_cleaned;
CREATE TABLE superstore_cleaned AS
WITH standardized AS (
    SELECT DISTINCT
        row_id,
        TRIM(order_id) AS order_id,
        TO_DATE(order_date, 'MM/DD/YYYY') AS order_date,
        TO_DATE(ship_date, 'MM/DD/YYYY') AS ship_date,
        INITCAP(TRIM(ship_mode)) AS ship_mode,
        TRIM(customer_id) AS customer_id,
        INITCAP(TRIM(customer_name)) AS customer_name,
        INITCAP(TRIM(segment)) AS segment,
        INITCAP(TRIM(country)) AS country,
        INITCAP(TRIM(city)) AS city,
        INITCAP(TRIM(state)) AS state,
        COALESCE(NULLIF(TRIM(postal_code), ''), 'Unknown') AS postal_code,
        INITCAP(TRIM(region)) AS region,
        TRIM(product_id) AS product_id,
        INITCAP(TRIM(category)) AS category,
        INITCAP(TRIM(sub_category)) AS sub_category,
        TRIM(product_name) AS product_name,
        COALESCE(sales, 0) AS sales,
        COALESCE(quantity, 0) AS quantity,
        LEAST(GREATEST(COALESCE(discount, 0), 0), 1) AS discount,
        COALESCE(profit, 0) AS profit
    FROM superstore_raw
), engineered AS (
    SELECT *,
        sales AS revenue,
        sales - profit AS cost,
        CASE WHEN sales <> 0 THEN profit / sales ELSE 0 END AS profit_margin,
        EXTRACT(YEAR FROM order_date)::INT AS order_year,
        DATE_TRUNC('month', order_date)::DATE AS order_month,
        CONCAT('Q', EXTRACT(QUARTER FROM order_date)::INT) AS order_quarter,
        GREATEST(ship_date - order_date, 0) AS ship_days,
        CASE
            WHEN discount = 0 THEN 'No Discount'
            WHEN discount <= 0.10 THEN 'Low'
            WHEN discount <= 0.20 THEN 'Medium'
            WHEN discount <= 0.50 THEN 'High'
            ELSE 'Very High'
        END AS discount_band,
        CASE WHEN profit >= 0 THEN 'Profitable' ELSE 'Loss-Making' END AS profitability_status
    FROM standardized
)
SELECT * FROM engineered;

-- Data validation checks
SELECT COUNT(*) AS total_rows FROM superstore_cleaned;
SELECT COUNT(*) AS invalid_ship_dates FROM superstore_cleaned WHERE ship_date < order_date;
SELECT COUNT(*) AS invalid_discount FROM superstore_cleaned WHERE discount < 0 OR discount > 1;
SELECT COUNT(*) AS missing_order_id FROM superstore_cleaned WHERE order_id IS NULL OR order_id = '';

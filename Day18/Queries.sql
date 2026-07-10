-- Day 18: Date & Time Functions in PostgreSQL

-- Setup
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    quantity INT,
    added_date DATE,
    discount_rate NUMERIC
);

SELECT * FROM products;

-- 1. NOW() - Get Current Date and Time
SELECT NOW() AS current_datetime;

-- 2. CURRENT_DATE() - Get Current Date
SELECT CURRENT_DATE AS today_date;

SELECT added_date, CURRENT_DATE, (CURRENT_DATE - added_date) AS days_difference
FROM products;

-- 3. EXTRACT() - Extract Parts of a Date
-- Extract the year, month, and day from the added_date column
SELECT product_name,
    EXTRACT(YEAR FROM added_date) AS year_added,
    EXTRACT(MONTH FROM ad

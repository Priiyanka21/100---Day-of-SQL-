-- ===================================
-- Day 19 of #100DaysOfSQL
-- Date & Time Functions in PostgreSQL
-- ===================================

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

INSERT INTO products (product_name, category, price, quantity, added_date, discount_rate) VALUES
('Laptop', 'Electronics', 75000, 4, '01-03-2026', 5.00),
('Smartphone', 'Electronics', 45000, 25, '04-03-2025', 8.00),
('Keyboard', 'Electronics', 55000, 20, '01-05-2026', 5.00),
('Desk', 'Furniture', 95000, 22, '11-03-2026', 6.00),
('Mouse', 'Electronics', 35000, 30, '01-03-2026', 7.00),
('Tablet', 'Electronics', 75000, 4, '01-03-2026', 5.00),
('Printer', 'Electronics', 75000, 4, '01-03-2026', 3.00),
('Monitor', 'Electronics', 75000, 4, '01-03-2026', 9.00);

SELECT * FROM products;

-- 6. DATE_PART() - Get Specific Date Part
-- Extract the day of the week from added_date
SELECT product_name, added_date,
    DATE_PART('dow', added_date) AS day_of_week
FROM products;

-- 7. DATE_TRUNC() - Truncate Date to Precision
-- Truncate added_date to the start of the month
SELECT product_name,
    DATE_TRUNC('month', added_date) AS Month_start
FROM products;

-- 8. INTERVAL - Add or Subtract Time Intervals
-- Add 6 days to the added_date
SELECT product_name, added_date,
    added_date + INTERVAL '6 days' AS new_date
FROM products;

-- 9. CURRENT_TIME() - Get Current Time
-- Retrieve only the current time
SELECT CURRENT_TIME AS current_time;

-- 10. TO_DATE() - Convert String to Date
-- Convert a string to a date format
SELECT TO_DATE('01-11-2025') AS converted_date;

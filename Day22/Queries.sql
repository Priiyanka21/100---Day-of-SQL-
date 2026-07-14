-- Day 22 of #100DaysOfSQL
-- Topic: COALESCE() and handling discounts with NULLs

-- View existing data
SELECT * FROM products;

-- Add a new column to store discount price
ALTER TABLE products
ADD COLUMN discount_price NUMERIC(10,2);

-- Set discount_price as NULL for specific products (no discount)
UPDATE products
SET discount_price = NULL
WHERE product_name IN ('Laptop', 'Desk');

-- Calculate discount_price for the rest (10% off)
UPDATE products
SET discount_price = price * 0.9
WHERE product_name NOT IN ('Laptop', 'Desk');

-- Check discount_price values (some NULLs present)
SELECT product_name, discount_price
FROM products;

-- Use COALESCE to fall back to price when discount_price is NULL
SELECT product_name,
       COALESCE(discount_price, price) AS final_price
FROM products;

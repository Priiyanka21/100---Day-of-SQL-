-- Day 17 of #100DaysOfSQL — String Functions

-- Count length of product name
SELECT product_name, LENGTH(product_name) AS COUNT_OF_CHAR
FROM products;

-- Remove leading and trailing space from string
SELECT TRIM('   Monitor   ') AS Trimmed_text;

-- Replace the word "monitor" with "device" in product names
SELECT REPLACE(product_name, 'monitor', 'device') AS updated
FROM products;

-- Get all categories in Uppercase
SELECT UPPER(category) AS Category_Capital
FROM products;

-- Join product_name and category text with hyphen
SELECT CONCAT(product_name, '-', category) AS product_details
FROM products;

-- Extract the first 5 characters from product_name
SELECT SUBSTRING(product_name, 1, 5) AS short_name
FROM products;

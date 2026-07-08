-- Total Quantity Available of all products
SELECT SUM(quantity) AS total_quantity
FROM products;

-- Total quantity of Electronics priced above 60000
SELECT SUM(quantity) AS quantity_of_ele
FROM products
WHERE category = 'Electronics' AND price > 60000;

-- Total number of products
SELECT COUNT(*) AS total_products
FROM products;

-- Count with Condition (product names ending in "phone")
SELECT COUNT(*) AS total_products
FROM products
WHERE product_name LIKE '%phone';

-- Average Price of Products
SELECT AVG(price) AS average_price
FROM products;

-- Average Price of Products with condition
SELECT AVG(price) AS average_price
FROM products
WHERE category = 'Furniture';

-- ==========================================
-- #100DaysOfSQL - Day 21
-- Topic: CASE Statement (Advanced) - AND/OR + LIKE Operator
-- ==========================================

SELECT * FROM products;

-- ==========================================
-- 1. CASE with AND & OR Operators - Stock Status
-- ==========================================
/* 
We will classify products based on quantity available:
   In Stock       -> if Quantity is 10 or more
   Limited Stock  -> if Quantity is between 5 and 9
   Out of Stock Soon -> if Quantity is less than 5
*/

SELECT product_name, quantity,
    CASE
        WHEN quantity >= 10 THEN 'Instock'
        WHEN quantity BETWEEN 5 AND 9 THEN 'Limited Stock'
        ELSE 'Out of Stock'
    END AS stock_status
FROM products;


-- ==========================================
-- 2. CASE with LIKE Operator - Category Classification
-- ==========================================
/*
Check if the category name contains "Electronics" or "Furniture" using LIKE
*/

SELECT product_name, Category,
    CASE
        WHEN Category LIKE 'Electronics%' THEN 'Electronics Item'
        WHEN Category LIKE 'Furniture%' THEN 'Furniture Item'
        ELSE 'Accessory Item'
    END AS category_status
FROM products;

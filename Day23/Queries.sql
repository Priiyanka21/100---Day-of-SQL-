-- Day 23 of #100DaysOfSQL — Window Functions: Ranking & Running Totals

SELECT * FROM products;

-- Assign a unique row number to each product within the same category
SELECT
    PRODUCT_NAME,
    CATEGORY,
    PRICE,
    ROW_NUMBER() OVER (
        PARTITION BY CATEGORY
        ORDER BY PRICE DESC
    ) AS ROW_NUM
FROM
    PRODUCTS;

-- Calculate a running total of price across all products, ordered by price
SELECT
    PRODUCT_NAME,
    CATEGORY,
    PRICE,
    SUM(PRICE) OVER (
        ORDER BY PRICE DESC
    ) AS RUNNING_TOTAL
FROM
    PRODUCTS;

-- ============================================
-- #100DaysOfSQL — Day 35: Q99 to Q110
-- ============================================

-- Q99: Find products ordered by all customers
-- Tables: customers, sales
SELECT s.product_id
FROM sales s
GROUP BY s.product_id
HAVING COUNT(DISTINCT s.customer_id) = (SELECT COUNT(*) FROM customers);


-- Q100: Find customers with orders totaling more than $5000 in the last year
-- Tables: orders
SELECT customer_id,
       SUM(order_amount) AS total_spent
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY customer_id
HAVING SUM(order_amount) > 5000;


-- Q101: Find the day with the highest number of new hires
-- Tables: employees
SELECT hire_date,
       COUNT(*) AS new_hires
FROM employees
GROUP BY hire_date
ORDER BY new_hires DESC
LIMIT 1;


-- Q102: Find the number of employees who have worked in more than one department
-- Tables: employee_department_history
SELECT COUNT(*) AS employees_multi_dept
FROM (
    SELECT employee_id
    FROM employee_department_history
    GROUP BY employee_id
    HAVING COUNT(DISTINCT department_id) > 1
) sub;


-- Q103: Find customers who ordered the most products in 2023
-- Tables: sales
SELECT customer_id,
       COUNT(product_id) AS total_products_ordered
FROM sales
WHERE EXTRACT(YEAR FROM sale_date) = 2023
GROUP BY customer_id
ORDER BY total_products_ordered DESC
LIMIT 1;


-- Q104: Find the average days taken to ship orders per shipping method
-- Tables: orders
SELECT shipping_method,
       ROUND(AVG(shipped_date - order_date), 2) AS avg_days_to_ship
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY shipping_method;


-- Q105: Find the total number of unique customers per product category
-- Tables: products, sales
SELECT p.category,
       COUNT(DISTINCT s.customer_id) AS unique_customers
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category;


-- Q106: Find employees with no projects assigned in the last 6 months
-- Tables: employees, project_assignments
SELECT e.employee_id,
       e.employee_name
FROM employees e
LEFT JOIN project_assignments pa
    ON e.employee_id = pa.employee_id
    AND pa.assigned_date >= CURRENT_DATE - INTERVAL '6 months'
WHERE pa.employee_id IS NULL;


-- Q107: Find the number of employees who have changed departments more than once
-- Tables: employee_department_history
SELECT COUNT(*) AS employees_changed_multiple_times
FROM (
    SELECT employee_id
    FROM employee_department_history
    GROUP BY employee_id
    HAVING COUNT(*) > 2   -- more than 1 change = more than 2 department records
) sub;


-- Q108: Find the product with the highest average rating
-- Tables: product_reviews
SELECT product_id,
       ROUND(AVG(rating), 2) AS avg_rating
FROM product_reviews
GROUP BY product_id
ORDER BY avg_rating DESC
LIMIT 1;


-- Q109: Find customers who have placed orders but never used a discount
-- Tables: orders
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(CASE WHEN discount_amount > 0 THEN 1 ELSE 0 END) = 0;


-- Q110: Find all managers who do not manage any employee
-- Tables: employees
SELECT e1.employee_id,
       e1.employee_name
FROM employees e1
WHERE e1.employee_id NOT IN (
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
);

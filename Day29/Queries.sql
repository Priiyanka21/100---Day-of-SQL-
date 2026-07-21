-- Q16: Employees whose names start and end with the same letter
SELECT name
FROM employees
WHERE LOWER(LEFT(name, 1)) = LOWER(RIGHT(name, 1));

-- Q17: Average order value per month and product category
SELECT 
    DATE_TRUNC('month', order_date) AS order_month,
    category,
    AVG(amount) AS avg_order_value
FROM orders
GROUP BY DATE_TRUNC('month', order_date), category
ORDER BY order_month, category;

-- Q18: Employees who have never made a sale
SELECT e.id, e.name
FROM employees e
LEFT JOIN sales s ON e.id = s.employee_id
WHERE s.employee_id IS NULL;

-- Q19: Average tenure (in years) of employees by department
SELECT 
    department_id,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))), 2) AS avg_tenure_years
FROM employees
GROUP BY department_id;

-- Q20: Customers who purchased more than once on the same day
SELECT customer_id, sale_date, COUNT(*) AS purchases
FROM sales
GROUP BY customer_id, sale_date
HAVING COUNT(*) > 1;

-- Q21: All departments with employee counts (including 0)
SELECT d.department_id, d.department_name, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- Q22: Products that have never been sold
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- Q23: Concatenate employee names in each department (string aggregation)
SELECT department_id, STRING_AGG(name, ', ') AS employee_names
FROM employees
GROUP BY department_id;

-- Q24: Customers who purchased all products in a specific category
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Electronics'   -- change category as needed
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*) FROM products WHERE category = 'Electronics'
);

-- Day 28 of #100DaysOfSQL

-- Q16: Employees whose names start and end with the same letter
SELECT id, name
FROM employees
WHERE LOWER(LEFT(name, 1)) = LOWER(RIGHT(name, 1));

-- Q17: Average order value per month and product category
SELECT
    DATE_TRUNC('month', o.order_date) AS order_month,
    p.category,
    AVG(o.order_value) AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date), p.category
ORDER BY order_month, p.category;

-- Q18: Employees who have never made a sale
SELECT e.id, e.name
FROM employees e
LEFT JOIN sales s ON e.id = s.employee_id
WHERE s.employee_id IS NULL;

-- Q19: Average tenure of employees by department
SELECT
    department_id,
    AVG(AGE(CURRENT_DATE, hire_date)) AS avg_tenure
FROM employees
GROUP BY department_id;

-- Q20: Customers who purchased more than once in the same day
SELECT customer_id, sale_date, COUNT(*) AS purchases
FROM sales
GROUP BY customer_id, sale_date
HAVING COUNT(*) > 1;

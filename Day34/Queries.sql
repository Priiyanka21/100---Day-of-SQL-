-- Q72: 5th highest salary (nth highest → change N)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 4; -- OFFSET N-1 for Nth highest

-- Alternative using DENSE_RANK (better for ties)
SELECT salary FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 5;

-- Q73: Average salary of employees hired each year
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY hire_year
ORDER BY hire_year;

-- Q74: Employees with company for more than 10 years
SELECT *
FROM employees
WHERE hire_date <= CURRENT_DATE - INTERVAL '10 years';

-- Q75: Department with the most promotions
-- Assumes promotions table: (emp_id, department_id, promotion_date)
SELECT d.department_name, COUNT(p.emp_id) AS total_promotions
FROM promotions p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_promotions DESC
LIMIT 1;

-- Q76: Customers who ordered products from at least 3 different categories
-- Assumes sales(customer_id, product_id), products(product_id, category)
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.category) >= 3;

-- Q77: Customers who never ordered product X
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT s.customer_id
    FROM sales s
    WHERE s.product_id = 'X'  -- replace with actual product id
);

-- Q78: Total revenue and number of orders per country
SELECT c.country,
       SUM(o.amount) AS total_revenue,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- Q79: Difference in days between first and last order per customer
SELECT customer_id,
       MAX(order_date) - MIN(order_date) AS days_diff
FROM orders
GROUP BY customer_id;

-- Q80: Departments with no employees
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.id IS NULL;

-- Q81: Product sold in highest quantity in a single order
-- Assumes sales(order_id, product_id, quantity)
SELECT product_id, order_id, quantity
FROM sales
ORDER BY quantity DESC
LIMIT 1;

-- Q82: Employees who joined before their department was created
-- Assumes departments(department_id, created_date)
SELECT e.name, e.hire_date, d.department_name, d.created_date
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date < d.created_date;

-- Q83: Customers with sales in at least 3 different years
SELECT customer_id
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM sale_date)) >= 3;

-- Q84: Average order amount per customer per year
SELECT customer_id,
       EXTRACT(YEAR FROM order_date) AS order_year,
       ROUND(AVG(amount), 2) AS avg_order_amount
FROM orders
GROUP BY customer_id, order_year
ORDER BY customer_id, order_year;

-- Q85: Employees who worked on at least one project with budget > $1,000,000
SELECT DISTINCT e.id, e.name
FROM employees e
JOIN project_assignments pa ON e.id = pa.employee_id
JOIN projects pr ON pa.project_id = pr.project_id
WHERE pr.budget > 1000000;

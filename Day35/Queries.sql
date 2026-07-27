-- Q86: Most recent promotion date per employee
SELECT employee_id, MAX(promotion_date) AS latest_promotion
FROM promotions
GROUP BY employee_id;

-- Q87: Products never ordered
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- Q88: Month with lowest sales in the past year
SELECT DATE_TRUNC('month', sale_date) AS month, SUM(amount) AS total_sales
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY month
ORDER BY total_sales ASC
LIMIT 1;

-- Q89: Employees hired each month in the last year
SELECT DATE_TRUNC('month', hire_date) AS month, COUNT(*) AS hires
FROM employees
WHERE hire_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY month
ORDER BY month;

-- Q90: Department with the highest number of projects
SELECT department, COUNT(*) AS project_count
FROM projects
GROUP BY department
ORDER BY project_count DESC
LIMIT 1;

-- Q91: Employees who do not have dependents
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
LEFT JOIN dependents d ON e.employee_id = d.employee_id
WHERE d.employee_id IS NULL;

-- Q92: Employees promoted but salary didn't increase
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
JOIN promotions p ON e.employee_id = p.employee_id
WHERE p.new_salary <= p.old_salary;

-- Q93: Customers with average order amount above $500
SELECT customer_id, AVG(amount) AS avg_order_amount
FROM orders
GROUP BY customer_id
HAVING AVG(amount) > 500;

-- Q94: Orders where total quantity exceeds 100 units
SELECT order_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
HAVING SUM(quantity) > 100;

-- Q95: Employees who worked on more than 3 projects in a year
SELECT employee_id, project_year, COUNT(project_id) AS project_count
FROM project_assignments
GROUP BY employee_id, project_year
HAVING COUNT(project_id) > 3;

-- Q96: Customers whose last order was placed more than 1 year ago
SELECT customer_id, MAX(order_date) AS last_order
FROM orders
GROUP BY customer_id
HAVING MAX(order_date) < CURRENT_DATE - INTERVAL '1 year';

-- Q97: Average salary increase percentage per department
SELECT e.department,
       AVG((p.new_salary - p.old_salary) * 100.0 / p.old_salary) AS avg_increase_pct
FROM promotions p
JOIN employees e ON p.employee_id = e.employee_id
GROUP BY e.department;

-- Q98: Employees who have never been promoted
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
LEFT JOIN promotions p ON e.employee_id = p.employee_id
WHERE p.employee_id IS NULL;

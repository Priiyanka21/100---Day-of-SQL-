-- ============================================
-- SQL PRACTICE: Q121 - Q135
-- ============================================

-- Q121: Employees with the highest number of direct reports
SELECT manager_id, COUNT(*) AS direct_reports
FROM employees
GROUP BY manager_id
ORDER BY direct_reports DESC
LIMIT 1;

-- Q122: Average time difference between order and delivery
SELECT AVG(delivery_date - order_date) AS avg_delivery_time
FROM orders;

-- Q123: Department with the youngest average employee age
SELECT department, AVG(age) AS avg_age
FROM employees
GROUP BY department
ORDER BY avg_age ASC
LIMIT 1;

-- Q124: Employee(s) with the highest number of late arrivals
SELECT employee_id, COUNT(*) AS late_count
FROM attendance
WHERE status = 'Late'
GROUP BY employee_id
ORDER BY late_count DESC
LIMIT 1;

-- Q125: Total revenue generated per sales representative
SELECT sales_rep_id, SUM(revenue) AS total_revenue
FROM sales
GROUP BY sales_rep_id
ORDER BY total_revenue DESC;

-- Q126: Customers with no orders in the last year
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
  AND o.order_date >= CURRENT_DATE - INTERVAL '1 year'
WHERE o.order_id IS NULL;

-- Q127: Customers with orders where no product quantity is less than 5
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_id NOT IN (
    SELECT order_id FROM order_items WHERE quantity < 5
);

-- Q128: Products ordered only by customers from one country
SELECT product_id
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY product_id
HAVING COUNT(DISTINCT c.country) = 1;

-- Q129: Employees who have not submitted their timesheets in the last month
SELECT employee_id
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id FROM timesheets
    WHERE submitted_date >= CURRENT_DATE - INTERVAL '1 month'
);

-- Q130: Total discount given in each month
SELECT DATE_TRUNC('month', order_date) AS month, SUM(discount) AS total_discount
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Q131: Customers who have placed orders but never paid by credit card
SELECT DISTINCT customer_id
FROM orders
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders WHERE payment_method = 'Credit Card'
);

-- Q132: Top 5 longest projects
SELECT project_id, project_name, (end_date - start_date) AS duration
FROM projects
ORDER BY duration DESC
LIMIT 5;

-- Q133: Employees who have not taken any leave in the last 6 months
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN leaves l
  ON e.employee_id = l.employee_id
  AND l.leave_date >= CURRENT_DATE - INTERVAL '6 months'
WHERE l.leave_id IS NULL;

-- Q134: Department with the most projects completed last year
SELECT department, COUNT(*) AS completed_projects
FROM projects
WHERE status = 'Completed'
  AND EXTRACT(YEAR FROM end_date) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
GROUP BY department
ORDER BY completed_projects DESC
LIMIT 1;

-- Q135: Average time to close tickets per support agent
-- (Note: no ticketing table in sample DB, using work_logs pattern)
SELECT agent_id, AVG(hours_worked) AS avg_close_time
FROM work_logs
GROUP BY agent_id;

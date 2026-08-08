-- Q201. Total sales per customer (including customers with zero sales)
SELECT c.customer_id, c.customer_name, COALESCE(SUM(s.amount), 0) AS total_sales
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name;


-- Q202. Highest salary by department + employee(s) who earn it
SELECT department, employee_name, salary
FROM employees e
WHERE salary = (
    SELECT MAX(salary) FROM employees e2 WHERE e2.department = e.department
);


-- Q203. Employees whose salary is within 10% of highest salary in their department
SELECT employee_name, department, salary
FROM employees e
WHERE salary >= 0.9 * (
    SELECT MAX(salary) FROM employees e2 WHERE e2.department = e.department
);


-- Q204. Running total of sales by date
SELECT sale_date, SUM(amount) AS daily_sales,
       SUM(SUM(amount)) OVER (ORDER BY sale_date) AS running_total
FROM sales
GROUP BY sale_date
ORDER BY sale_date;


-- Q205. Last 3 orders placed by each customer
SELECT *
FROM (
    SELECT o.*, 
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM orders o
) t
WHERE rn <= 3;


-- Q206. Total orders per day, including days with zero orders
SELECT d::date AS order_day, COUNT(o.order_id) AS total_orders
FROM generate_series(
    (SELECT MIN(order_date) FROM orders),
    (SELECT MAX(order_date) FROM orders),
    interval '1 day'
) d
LEFT JOIN orders o ON o.order_date::date = d::date
GROUP BY d
ORDER BY d;


-- Q207. Find gaps in employee IDs
SELECT (employee_id + 1) AS gap_start,
       next_id - 1 AS gap_end
FROM (
    SELECT employee_id,
           LEAD(employee_id) OVER (ORDER BY employee_id) AS next_id
    FROM employees
) t
WHERE next_id - employee_id > 1;


-- Q208. Employees hired before their managers
SELECT e.employee_name AS employee, e.hire_date AS emp_hire_date,
       m.employee_name AS manager, m.hire_date AS mgr_hire_date
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.hire_date < m.hire_date;


-- Q209. Customers who ordered all products in a category
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.customer_id, p.category
HAVING COUNT(DISTINCT s.product_id) = (
    SELECT COUNT(*) FROM products p2 WHERE p2.category = p.category
);


-- Q210. All employees and their manager names
SELECT e.employee_name AS employee, m.employee_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

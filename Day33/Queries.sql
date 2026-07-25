-- Day 33 of #100DaysOfSQL

-- Q61: Employees who have worked on more than 5 projects
SELECT employee_id, COUNT(DISTINCT project_id) AS project_count
FROM project_assignments
GROUP BY employee_id
HAVING COUNT(DISTINCT project_id) > 5;

-- Q62: Total number of products sold each day
SELECT sale_date, SUM(quantity) AS total_products_sold
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- Q63: Customers with orders totaling more than $10,000
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id
HAVING SUM(amount) > 10000;

-- Q64: Employees who have never received a bonus
SELECT e.id, e.name
FROM employees e
LEFT JOIN bonuses b ON e.id = b.employee_id
WHERE b.employee_id IS NULL;

-- Q65: Department with the lowest average salary
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary ASC
LIMIT 1;

-- Q66: Customers who ordered products only from one category
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.category) = 1;

-- Q67: Department with the highest variance in salaries
SELECT department_id, VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department_id
ORDER BY salary_variance DESC
LIMIT 1;

-- Q68: Customers who purchased both Product A and Product B
SELECT s1.customer_id
FROM

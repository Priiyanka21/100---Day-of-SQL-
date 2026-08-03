-- Q161: Find products ordered on their launch date
SELECT DISTINCT p.product_id, p.product_name, p.launch_date
FROM products p
JOIN orders o ON o.product_id = p.product_id
WHERE o.order_date = p.launch_date;

-- Q162: List departments with no open positions
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN job_openings j ON j.department_id = d.department_id
WHERE j.department_id IS NULL;

-- Q163: Retrieve employees who earn more than their manager
SELECT e.employee_id, e.employee_name, e.salary,
       m.employee_name AS manager_name, m.salary AS manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- Q164: Running total of salaries by department
SELECT employee_id, employee_name, department_id, salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY employee_id) AS running_total
FROM employees;

-- Q165: Calculate cumulative distribution (CDF) of salaries
SELECT employee_id, employee_name, salary,
       CUME_DIST() OVER (ORDER BY salary) AS salary_cdf
FROM employees;

-- Q166: Rank employees based on salary
SELECT employee_id, employee_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Q167: Calculate difference between current row and previous row's salary (LAG function)
SELECT employee_id, employee_name, salary,
       salary - LAG(salary) OVER (ORDER BY employee_id) AS salary_diff
FROM employees;

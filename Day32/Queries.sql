-- Day 32 of #100DaysOfSQL

-- Q46: Departments with avg salary > overall avg
SELECT department_id, AVG(salary) AS avg_dept_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- Q47: Employees with highest number of dependents
SELECT e.id, e.name, COUNT(d.dependent_id) AS dependent_count
FROM employees e
JOIN dependents d ON e.id = d.employee_id
GROUP BY e.id, e.name
ORDER BY dependent_count DESC
LIMIT 1;

-- Q48: Most recent order date per customer
SELECT customer_id, MAX(order_date) AS latest_order
FROM orders
GROUP BY customer_id;

-- Q49: Number of employees hired each year
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS total_hired
FROM employees
GROUP BY hire_year
ORDER BY hire_year;

-- Q50: Employees with same job title per department
SELECT department_id, job_title, COUNT(*) AS title_count
FROM employees
GROUP BY department_id, job_title
HAVING COUNT(*) > 1;

-- Q51: Employees with no manager assigned
SELECT id, name
FROM employees
WHER

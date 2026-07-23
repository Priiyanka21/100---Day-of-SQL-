-- Q34: Max salary gap between any two employees in same department
SELECT department_id, 
       MAX(salary) - MIN(salary) AS max_salary_gap
FROM employees
GROUP BY department_id;

-- Q35: Employees who worked in more than 3 different departments
SELECT employee_id, 
       COUNT(DISTINCT department_id) AS dept_count
FROM employee_department_history
GROUP BY employee_id
HAVING COUNT(DISTINCT department_id) > 3;

-- Q36: Employees who never took any leave
SELECT e.*
FROM employees e
LEFT JOIN leaves l ON e.id = l.employee_id
WHERE l.employee_id IS NULL;

-- Q37: First order date for each customer
SELECT customer_id, 
       MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;

-- Q38: Employees promoted more than twice
SELECT employee_id, 
       COUNT(*) AS promotion_count
FROM promotions
GROUP BY employee_id
HAVING COUNT(*) > 2;

-- Q39: Employees not assigned to any project
SELECT e.*
FROM employees e
LEFT JOIN project_assignments pa ON e.id = pa.employee_id
WHERE pa.employee_id IS NULL;

-- Q40: Customers with no orders in the last year
SELECT c.*
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
    AND o.order_date >= CURRENT_DATE - INTERVAL '1 year'
WHERE o.order_id IS NULL;

-- Q41: Employees earning more than company average salary
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q42: Difference in days between earliest & latest orders per customer
SELECT customer_id,
       MAX(order_date) - MIN(order_date) AS days_diff
FROM orders
GROUP BY customer_id;

-- Q43: Employees who worked on all projects
SELECT employee_id
FROM project_assignments
GROUP BY employee_id
HAVING COUNT(DISTINCT project_id) = (SELECT COUNT(*) FROM projects);

-- Q44: Customers who placed orders only in the last 6 months
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING MIN(order_date) >= CURRENT_DATE - INTERVAL '6 months';

-- Q45: Department with the most employees
SELECT department_id, 
       COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
ORDER BY emp_count DESC
LIMIT 1;

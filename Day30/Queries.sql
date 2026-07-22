-- Q25: Nth highest salary (set N)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET N-1;
-- Alternative using DENSE_RANK
SELECT salary FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = N;

-- Q26: Employees with no entries in salary_history
SELECT e.*
FROM employees e
LEFT JOIN salary_history sh ON e.id = sh.employee_id
WHERE sh.employee_id IS NULL;

-- Q27: Department with highest number of employees
SELECT department_id, COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
ORDER BY emp_count DESC
LIMIT 1;

-- Q28: Employees who never received a promotion
SELECT e.*
FROM employees e
LEFT JOIN promotions p ON e.id = p.employee_id
WHERE p.employee_id IS NULL;

-- Q29: Products never ordered
SELECT p.*
FROM products p
LEFT JOIN orders o ON p.id = o.product_id
WHERE o.product_id IS NULL;

-- Q30: Total sales amount & order count per customer in last 1 year
SELECT customer_id,
       SUM(amount) AS total_sales,
       COUNT(*) AS total_orders
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY customer_id;

-- Q31: Employees who managed more than 3 projects
SELECT manager_id, COUNT(*) AS project_count
FROM projects
GROUP BY manager_id
HAVING COUNT(*) > 3;

-- Q32: Department with highest average years of experience
SELECT department_id,
       AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))) AS avg_experience
FROM employees
GROUP BY department_id
ORDER BY avg_experience DESC
LIMIT 1;

-- Q33: Customers who haven't ordered in the last 6 months
SELECT c.*
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id 
    AND o.order_date >= CURRENT_DATE - INTERVAL '6 months'
WHERE o.customer_id IS NULL;

-- Q34: Max salary gap between any two employees in same department
SELECT department_id,
       MAX(salary) - MIN(salary) AS salary_gap
FROM employees
GROUP BY department_id
ORDER BY salary_gap DESC
LIMIT 1;

-- Q35: Employees who worked in more than 3 different departments
SELECT employee_id, COUNT(DISTINCT department_id) AS dept_count
FROM employee_department_history
GROUP BY employee_id
HAVING COUNT(DISTINCT department_id) > 3;

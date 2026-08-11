-- Q222: Customers who increased order volume every month for last 3 months
WITH monthly_orders AS (
    SELECT customer_id,
           DATE_TRUNC('month', order_date) AS order_month,
           COUNT(*) AS order_count
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '3 months'
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
ranked AS (
    SELECT customer_id, order_month, order_count,
           LAG(order_count) OVER (PARTITION BY customer_id ORDER BY order_month) AS prev_count
    FROM monthly_orders
)
SELECT DISTINCT customer_id
FROM ranked
WHERE customer_id NOT IN (
    SELECT customer_id FROM ranked WHERE order_count <= prev_count
);


-- Q223: Employees with same salary as average salary of their job title
SELECT e.*
FROM employees e
JOIN (
    SELECT job_title, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY job_title
) t ON e.job_title = t.job_title AND e.salary = t.avg_salary;


-- Q224: Difference in salary between employees and their managers
SELECT e.employee_id, e.name AS employee_name, e.salary AS employee_salary,
       m.name AS manager_name, m.salary AS manager_salary,
       (m.salary - e.salary) AS salary_difference
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;


-- Q225: Employee with maximum salary in each department
SELECT department, employee_id, name, salary
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 1;


-- Q226: Customers with orders on every day in the last week
SELECT customer_id
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY customer_id
HAVING COUNT(DISTINCT order_date) = 7;


-- Q227: Employees whose salary is above company avg but below department avg
SELECT e.*
FROM employees e
JOIN (
    SELECT department, AVG(salary) AS dept_avg FROM employees GROUP BY department
) d ON e.department = d.department
WHERE e.salary > (SELECT AVG(salary) FROM employees)
  AND e.salary < d.dept_avg;


-- Q228: Customers whose total orders exceed average order amount
SELECT customer_id, SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(amount) FROM orders);


-- Q229: Total sales per category, including zero-sales categories
SELECT c.category_id, c.category_name, COALESCE(SUM(s.sale_amount), 0) AS total_sales
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY c.category_id, c.category_name;


-- Q230: Products whose sales doubled compared to previous month
WITH monthly_sales AS (
    SELECT product_id,
           DATE_TRUNC('month', sale_date) AS sale_month,
           SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY product_id, DATE_TRUNC('month', sale_date)
),
compare_sales AS (
    SELECT product_id, sale_month, total_sales,
           LAG(total_sales) OVER (PARTITION BY product_id ORDER BY sale_month) AS prev_month_sales
    FROM monthly_sales
)
SELECT *
FROM compare_sales
WHERE total_sales >= 2 * prev_month_sales;

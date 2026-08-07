-- Q191. Product with highest sales for each category
SELECT category, product_id, total_sales
FROM (
    SELECT category, product_id, SUM(amount) AS total_sales,
           RANK() OVER (PARTITION BY category ORDER BY SUM(amount) DESC) AS rnk
    FROM sales
    GROUP BY category, product_id
) t
WHERE rnk = 1;

-- Q192. % contribution of each product's sales to total sales per month
SELECT 
    DATE_TRUNC('month', sale_date) AS month,
    product_id,
    SUM(amount) AS product_sales,
    ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (PARTITION BY DATE_TRUNC('month', sale_date)), 2) AS pct_contribution
FROM sales
GROUP BY DATE_TRUNC('month', sale_date), product_id
ORDER BY month, pct_contribution DESC;

-- Q193. 3 most recent orders per customer with order details
SELECT *
FROM (
    SELECT o.*, 
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rnk
    FROM orders o
) t
WHERE rnk <= 3;

-- Q194. Customers who ordered in January but not February
SELECT DISTINCT customer_id
FROM orders
WHERE EXTRACT(MONTH FROM order_date) = 1
AND customer_id NOT IN (
    SELECT customer_id FROM orders WHERE EXTRACT(MONTH FROM order_date) = 2
);

-- Q195. Products with price increase in last 6 months (stand-in via salary_history)
SELECT p.product_id, p.product_name
FROM products p
JOIN salary_history sh ON sh.employee_id = p.product_id  -- stand-in join
WHERE sh.change_date >= CURRENT_DATE - INTERVAL '6 months'
AND sh.new_salary > sh.old_salary;

-- Q196. Department(s) with second highest average salary
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) AS avg_salary,
           DENSE_RANK() OVER (ORDER BY AVG(salary) DESC) AS rnk
    FROM employees
    GROUP BY department
) t
WHERE rnk = 2;

-- Q197. Employees who joined in the same month and year
SELECT DATE_TRUNC('month', join_date) AS join_month, 
       ARRAY_AGG(employee_id) AS employees
FROM employees
GROUP BY DATE_TRUNC('month', join_date)
HAVING COUNT(*) > 1;

-- Q198. Salary above dept avg but below company avg
SELECT e.*
FROM employees e
JOIN (
    SELECT department, AVG(salary) AS dept_avg FROM employees GROUP BY department
) d ON e.department = d.department
WHERE e.salary > d.dept_avg
AND e.salary < (SELECT AVG(salary) FROM employees);

-- Q199. Customers with highest purchase amount per year
SELECT year, customer_id, total_amount
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year, customer_id, SUM(amount) AS total_amount,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(amount) DESC) AS rnk
    FROM sales
    GROUP BY EXTRACT(YEAR FROM sale_date), customer_id
) t
WHERE rnk = 1;

-- Q200. Employees with salary equal to dept average
SELECT e.*
FROM employees e
JOIN (
    SELECT department, AVG(salary) AS dept_avg FROM employees GROUP BY department
) d ON e.department = d.department
WHERE e.salary = d.dept_avg;

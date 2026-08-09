-- Q211. Employees with same salary as their manager
SELECT e.employee_id, e.name, e.salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary = m.salary;


-- Q212. Products with sales above average sales amount
SELECT product_id, SUM(amount) AS total_sales
FROM sales
GROUP BY product_id
HAVING SUM(amount) > (SELECT AVG(amount) FROM sales);


-- Q213. Cumulative count of orders per customer over time
SELECT customer_id, order_date, order_id,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_orders
FROM orders
ORDER BY customer_id, order_date;


-- Q214. Employee names with manager names (including those without managers)
SELECT e.name AS employee_name,
       m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;


-- Q215. Products with sales increasing every month for last 3 months
WITH monthly_sales AS (
  SELECT product_id,
         DATE_TRUNC('month', sale_date) AS month,
         SUM(amount) AS total_sales
  FROM sales
  GROUP BY product_id, DATE_TRUNC('month', sale_date)
),
ranked AS (
  SELECT *,
         LAG(total_sales, 1) OVER (PARTITION BY product_id ORDER BY month) AS prev1,
         LAG(total_sales, 2) OVER (PARTITION BY product_id ORDER BY month) AS prev2
  FROM monthly_sales
)
SELECT DISTINCT product_id
FROM ranked
WHERE total_sales > prev1 AND prev1 > prev2;


-- Q216. Difference between each order amount and previous order amount per customer
SELECT customer_id, order_id, order_date, amount,
       amount - LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_from_prev
FROM orders;


-- Q217. Employees with salaries higher than their department average
SELECT e.employee_id, e.name, e.salary, e.department
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.department = e.department
);


-- Q218. Difference between each row's value and previous row's value in sales
SELECT sale_id, sale_date, amount,
       amount - LAG(amount) OVER (ORDER BY sale_date) AS diff_from_prev
FROM sales;


-- Q219. Average gap (in days) between orders per customer
WITH order_gaps AS (
  SELECT customer_id, order_date,
         order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS gap
  FROM orders
)
SELECT customer_id, AVG(gap) AS avg_gap_days
FROM order_gaps
WHERE gap IS NOT NULL
GROUP BY customer_id;


-- Q220. Employees hired on the same day as their managers
SELECT e.employee_id, e.name, e.hire_date
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.hire_date = m.hire_date;

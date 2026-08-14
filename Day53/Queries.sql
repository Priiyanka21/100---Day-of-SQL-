-- Q251. Find products that were sold in every quarter of the current year.
SELECT product_id
FROM sales
WHERE EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY product_id
HAVING COUNT(DISTINCT EXTRACT(QUARTER FROM sale_date)) = 4;


- Q252. Find the most common product combinations in orders (pairs).
SELECT oi1.product_id AS product_1,
       oi2.product_id AS product_2,
       COUNT(*) AS pair_count
FROM order_items oi1
JOIN order_items oi2
  ON oi1.order_id = oi2.order_id
 AND oi1.product_id < oi2.product_id
GROUP BY oi1.product_id, oi2.product_id
ORDER BY pair_count DESC;


-- Q253. Find employees who have worked more than 40 hours in a week.
SELECT employee_id,
       DATE_TRUNC('week', work_date) AS week_start,
       SUM(hours_worked) AS total_hours
FROM work_logs
GROUP BY employee_id, DATE_TRUNC('week', work_date)
HAVING SUM(hours_worked) > 40;


-- Q254. Find products with an increasing sales trend over the last 3 months.
WITH monthly_sales AS (
    SELECT product_id,
           DATE_TRUNC('month', sale_date) AS month,
           SUM(quantity) AS total_qty
    FROM sales
    WHERE sale_date >= CURRENT_DATE - INTERVAL '3 months'
    GROUP BY product_id, DATE_TRUNC('month', sale_date)
),
ranked AS (
    SELECT *,
           LAG(total_qty, 1) OVER (PARTITION BY product_id ORDER BY month) AS prev_month,
           LAG(total_qty, 2) OVER (PARTITION BY product_id ORDER BY month) AS prev_2_month
    FROM monthly_sales
)
SELECT DISTINCT product_id
FROM ranked
WHERE total_qty > prev_month AND prev_month > prev_2_month;


-- Q255. Find departments where average salary is higher than the company average.
SELECT department_id, AVG(salary) AS avg_dept_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);


-- Q256. Find employees whose salaries are within 10% of their department's average salary.
WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.employee_id, e.department_id, e.salary, d.avg_salary
FROM employees e
JOIN dept_avg d ON e.department_id = d.department_id
WHERE e.salary BETWEEN d.avg_salary * 0.9 AND d.avg_salary * 1.1;


-- Q257. Find customers who ordered the most products in each category.
WITH customer_category_count AS (
    SELECT c.customer_id, p.category, COUNT(DISTINCT p.product_id) AS product_count
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY c.customer_id, p.category
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY product_count DESC) AS rnk
    FROM customer_category_count
)
SELECT customer_id, category, product_count
FROM ranked
WHERE rnk = 1;


-- Q258. Find employees who have been assigned projects outside their department.
SELECT DISTINCT e.employee_id, e.department_id, p.department_id AS project_department
FROM employees e
JOIN project_assignments pa ON e.employee_id = pa.employee_id
JOIN projects p ON pa.project_id = p.project_id
WHERE e.department_id <> p.department_id;


-- Q259. Find customers who made purchases only in one month of the year.
SELECT customer_id
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY customer_id
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM order_date)) = 1;


-- Q260. Find products with sales revenue above the average revenue per product.
WITH product_revenue AS (
    SELECT product_id, SUM(quantity * price) AS total_revenue
    FROM sales
    GROUP BY product_id
)
SELECT product_id, total_revenue
FROM product_revenue
WHERE total_revenue > (SELECT AVG(total_revenue) FROM product_revenue);

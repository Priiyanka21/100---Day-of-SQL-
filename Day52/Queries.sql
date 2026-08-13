-- ============================================
-- Q241–Q250: Advanced SQL Practice
-- ============================================

-- Q241. Find the 3 most recent orders per customer
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rnk
    FROM orders
) ranked
WHERE rnk <= 3;


-- Q242. Find employees with a salary greater than all employees in department 10
SELECT *
FROM employees
WHERE salary > (
    SELECT MAX(salary) FROM employees WHERE department_id = 10
);


-- Q243. Find the percentage of employees in each department
SELECT department_id,
       COUNT(*) AS emp_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM employees
GROUP BY department_id;


-- Q244. Find the second most expensive product per category
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS rnk
    FROM products
) ranked
WHERE rnk = 2;


-- Q245. Find employees with the highest salary in each job title
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY job_title ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk = 1;


-- Q246. Find customers who spent more than average in their country
SELECT c.customer_id, c.country, SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.country
HAVING SUM(o.amount) > (
    SELECT AVG(country_total)
    FROM (
        SELECT c2.country, c2.customer_id, SUM(o2.amount) AS country_total
        FROM customers c2
        JOIN orders o2 ON c2.customer_id = o2.customer_id
        WHERE c2.country = c.country
        GROUP BY c2.country, c2.customer_id
    ) sub
);


-- Q247. Find the top 3 customers by total order amount in each region
SELECT *
FROM (
    SELECT c.customer_id, c.region, SUM(o.amount) AS total_amount,
           RANK() OVER (PARTITION BY c.region ORDER BY SUM(o.amount) DESC) AS rnk
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.region
) ranked
WHERE rnk <= 3;


-- Q248. Find employees hired after their managers
SELECT e.employee_id, e.hire_date, m.employee_id AS manager_id, m.hire_date AS manager_hire_date
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.hire_date > m.hire_date;


-- Q249. Find customers who ordered all products from a specific category
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Electronics'   -- replace with target category
GROUP BY s.customer_id
HAVING COUNT(DISTINCT s.product_id) = (
    SELECT COUNT(*) FROM products WHERE category = 'Electronics'
);


-- Q250. Calculate the retention rate of customers month-over-month
WITH monthly_customers AS (
    SELECT DISTINCT customer_id,
           DATE_TRUNC('month', order_date) AS order_month
    FROM orders
),
retention AS (
    SELECT curr.order_month,
           COUNT(DISTINCT curr.customer_id) AS total_customers,
           COUNT(DISTINCT prev.customer_id) AS retained_customers
    FROM monthly_customers curr
    LEFT JOIN monthly_customers prev
      ON curr.customer_id = prev.customer_id
     AND prev.order_month = curr.order_month - INTERVAL '1 month'
    GROUP BY curr.order_month
)
SELECT order_month,
       ROUND(retained_customers * 100.0 / NULLIF(total_customers, 0), 2) AS retention_rate
FROM retention
ORDER BY order_month;

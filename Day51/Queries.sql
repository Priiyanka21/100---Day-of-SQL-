-- ============================================
-- Q231: Rank of employees based on salary within their department
-- ============================================
SELECT 
    employee_id,
    name,
    department_id,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;


-- ============================================
-- Q232: Customers who purchased a product but never reordered it
-- ============================================
SELECT 
    customer_id,
    product_id
FROM sales
GROUP BY customer_id, product_id
HAVING COUNT(*) = 1;


-- ============================================
-- Q233: Customers whose orders increased by at least 20% vs previous month
-- ============================================
WITH monthly_orders AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', order_date) AS order_month,
        SUM(order_amount) AS total_amount
    FROM orders
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
with_prev AS (
    SELECT 
        customer_id,
        order_month,
        total_amount,
        LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_month) AS prev_amount
    FROM monthly_orders
)
SELECT 
    customer_id,
    order_month,
    total_amount,
    prev_amount,
    ROUND(((total_amount - prev_amount) / prev_amount) * 100, 2) AS pct_increase
FROM with_prev
WHERE prev_amount IS NOT NULL
  AND total_amount >= prev_amount * 1.2;


-- ============================================
-- Q234: Employees who have worked on every project in their department
-- ============================================
SELECT 
    e.employee_id,
    e.name,
    e.department_id
FROM employees e
WHERE NOT EXISTS (
    SELECT p.project_id
    FROM projects p
    WHERE p.department_id = e.department_id
    EXCEPT
    SELECT pa.project_id
    FROM project_assignments pa
    WHERE pa.employee_id = e.employee_id
);


-- ============================================
-- Q235: Average order amount excluding the top 5% largest orders
-- ============================================
WITH ranked AS (
    SELECT 
        order_id,
        order_amount,
        PERCENT_RANK() OVER (ORDER BY order_amount DESC) AS pct_rank
    FROM orders
)
SELECT 
    ROUND(AVG(order_amount), 2) AS avg_order_amount_excl_top5pct
FROM ranked
WHERE pct_rank > 0.05;


-- ============================================
-- Q236: Top 3 employees with highest salary increase over last year
-- ============================================
WITH salary_change AS (
    SELECT 
        employee_id,
        MAX(CASE WHEN EXTRACT(YEAR FROM change_date) = EXTRACT(YEAR FROM CURRENT_DATE) THEN salary END) AS curr_salary,
        MAX(CASE WHEN EXTRACT(YEAR FROM change_date) = EXTRACT(YEAR FROM CURRENT_DATE) - 1 THEN salary END) AS prev_salary
    FROM salary_history
    GROUP BY employee_id
)
SELECT 
    e.employee_id,
    e.name,
    sc.curr_salary,
    sc.prev_salary,
    (sc.curr_salary - sc.prev_salary) AS salary_increase
FROM salary_change sc
JOIN employees e ON e.employee_id = sc.employee_id
WHERE sc.curr_salary IS NOT NULL AND sc.prev_salary IS NOT NULL
ORDER BY salary_increase DESC
LIMIT 3;


-- ============================================
-- Q237: First 5 orders after a customer's registration date
-- ============================================
SELECT customer_id, order_id, order_date, order_amount
FROM (
    SELECT 
        c.customer_id,
        o.order_id,
        o.order_date,
        o.order_amount,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS rn
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    WHERE o.order_date >= c.registration_date
) t
WHERE rn <= 5;


-- ============================================
-- Q238: Customers who placed orders every month for the last 6 months
-- ============================================
WITH monthly AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date) AS order_month
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT customer_id
FROM monthly
GROUP BY customer_id
HAVING COUNT(DISTINCT order_month) = 6;


-- ============================================
-- Q239: Moving average of sales over the last 3 days
-- ============================================
SELECT 
    sale_date,
    sale_amount,
    ROUND(AVG(sale_amount) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3day
FROM sales
ORDER BY sale_date;


-- ============================================
-- Q240: Top 5 employees by number of projects in each department
-- ============================================
WITH project_count AS (
    SELECT 
        e.employee_id,
        e.name,
        e.department_id,
        COUNT(pa.project_id) AS total_projects,
        RANK() OVER (PARTITION BY e.department_id ORDER BY COUNT(pa.project_id) DESC) AS rnk
    FROM employees e
    JOIN project_assignments pa ON pa.employee_id = e.employee_id
    GROUP BY e.employee_id, e.name, e.department_id
)
SELECT employee_id, name, department_id, total_projects
FROM project_count
WHERE rnk <= 5
ORDER BY department_id, total_projects DESC;

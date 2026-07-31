-- =========================================================
-- Day 35 - #100DaysOfSQL
-- Q135 to Q148, Q151
-- =========================================================

-- =========================================================
-- Q135. Average time to close tickets per support agent
-- (No ticketing table available — practicing pattern using work_logs,
--  treating hours_worked as ticket handling time)
-- Table: work_logs (agent_id, ticket_id, hours_worked)
-- =========================================================
SELECT 
    agent_id,
    ROUND(AVG(hours_worked), 2) AS avg_handling_time
FROM work_logs
GROUP BY agent_id
ORDER BY avg_handling_time;


-- =========================================================
-- Q136. First and last login date for each user
-- Table: user_logins (user_id, login_date)
-- =========================================================
SELECT 
    user_id,
    MIN(login_date) AS first_login,
    MAX(login_date) AS last_login
FROM user_logins
GROUP BY user_id;


-- =========================================================
-- Q137. Departments where more than 50% of employees have salary > $60,000
-- Table: employees (emp_id, department, salary)
-- =========================================================
SELECT 
    department
FROM employees
GROUP BY department
HAVING 
    SUM(CASE WHEN salary > 60000 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > 0.5;


-- =========================================================
-- Q138. Average tenure of employees by department
-- Table: employees (emp_id, department, join_date, end_date)
-- Assumes end_date NULL for currently active employees
-- =========================================================
SELECT 
    department,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(COALESCE(end_date, CURRENT_DATE), join_date))), 2) AS avg_tenure_years
FROM employees
GROUP BY department;


-- =========================================================
-- Q139. Number of orders placed on weekends vs weekdays
-- Table: orders (order_id, order_date)
-- =========================================================
SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM order_date) IN (0,6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day_type;


-- =========================================================
-- Q140. Percentage of orders with discounts per month
-- Table: orders (order_id, order_date, discount)
-- =========================================================
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    ROUND(
        SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS pct_discounted_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;


-- =========================================================
-- Q141. Employees who have never been late to work
-- Tables: attendance (emp_id, status), employees (emp_id, name)
-- =========================================================
SELECT 
    e.emp_id,
    e.name
FROM employees e
WHERE e.emp_id NOT IN (
    SELECT emp_id FROM attendance WHERE status = 'Late'
);


-- =========================================================
-- Q142. Average order value per customer segment
-- Tables: customers (customer_id, segment), orders (order_id, customer_id, order_value)
-- =========================================================
SELECT 
    c.segment,
    ROUND(AVG(o.order_value), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.segment;


-- =========================================================
-- Q143. Employees who manage more than 3 projects
-- Table: projects (project_id, manager_id)
-- =========================================================
SELECT 
    manager_id,
    COUNT(project_id) AS total_projects
FROM projects
GROUP BY manager_id
HAVING COUNT(project_id) > 3;


-- =========================================================
-- Q144. Products that have never been returned
-- Tables: products (product_id, product_name), returns (return_id, product_id)
-- =========================================================
SELECT 
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN returns r ON p.product_id = r.product_id
WHERE r.product_id IS NULL;


-- =========================================================
-- Q145. Customers with orders but no shipments
-- Tables: orders (order_id, customer_id), shipments (shipment_id, order_id)
-- =========================================================
SELECT DISTINCT 
    o.customer_id
FROM orders o
LEFT JOIN shipments s ON o.order_id = s.order_id
WHERE s.order_id IS NULL;


-- =========================================================
-- Q146. Total number of unique products sold in the last quarter
-- Table: sales (sale_id, product_id, sale_date)
-- =========================================================
SELECT 
    COUNT(DISTINCT product_id) AS unique_products_sold
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '3 months';


-- =========================================================
-- Q147. Top 5 customers by total order value in the last year
-- Table: orders (order_id, customer_id, order_value, order_date)
-- =========================================================
SELECT 
    customer_id,
    SUM(order_value) AS total_order_value
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY customer_id
ORDER BY total_order_value DESC
LIMIT 5;


-- =========================================================
-- Q148. Number of employees who changed departments in the last year
-- Table: dept_history (emp_id, department, change_date)
-- =========================================================
SELECT 
    COUNT(DISTINCT emp_id) AS employees_changed_dept
FROM dept_history
WHERE change_date >= CURRENT_DATE - INTERVAL '1 year';


-- =========================================================
-- Q151. Employees who have never received a promotion
-- Tables: employees (emp_id, name), promotions (promo_id, emp_id)
-- =========================================================
SELECT 
    e.emp_id,
    e.name
FROM employees e
LEFT JOIN promotions p ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;

-- Q152: Total number of orders placed each day in the last week
SELECT 
    order_date,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY order_date
ORDER BY order_date;

-- Q153: Customers with orders in both online and in-store channels
SELECT customer_id
FROM orders
WHERE channel IN ('online', 'in-store')
GROUP BY customer_id
HAVING COUNT(DISTINCT channel) = 2;

-- Q154: Top 3 sales reps by number of deals closed this quarter
-- Note: 'sales' as stand-in for deals closed, 'employees' for sales rep
SELECT 
    e.employee_id,
    e.employee_name,
    COUNT(s.sale_id) AS deals_closed
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
WHERE DATE_TRUNC('quarter', s.sale_date) = DATE_TRUNC('quarter', CURRENT_DATE)
GROUP BY e.employee_id, e.employee_name
ORDER BY deals_closed DESC
LIMIT 3;

-- Q155: Products that have been discontinued but still have sales
SELECT DISTINCT p.product_id, p.product_name
FROM products p
JOIN sales s ON p.product_id = s.product_id
WHERE p.is_discontinued = TRUE;

-- Q156: Average delivery time by shipping method
SELECT 
    shipping_method,
    AVG(delivery_date - shipped_date) AS avg_delivery_days
FROM shipments
GROUP BY shipping_method
ORDER BY avg_delivery_days;

-- Q157: Orders where the total quantity exceeds 100
SELECT 
    order_id,
    SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
HAVING SUM(quantity) > 100;

-- Q158: Customers who made orders but never returned a product
SELECT DISTINCT o.customer_id
FROM orders o
WHERE o.customer_id NOT IN (
    SELECT DISTINCT r.customer_id
    FROM returns r
);

-- Q159: Employees who have worked on projects for more than 2 years
SELECT 
    employee_id,
    project_id,
    (end_date - start_date) AS duration_days
FROM project_assignments
WHERE (COALESCE(end_date, CURRENT_DATE) - start_date) > 730;

-- Q160: Total working hours per employee per week
SELECT 
    employee_id,
    DATE_TRUNC('week', work_date) AS week_start,
    SUM(hours_worked) AS total_hours
FROM work_logs
GROUP BY employee_id, DATE_TRUNC('week', work_date)
ORDER BY employee_id, week_start;

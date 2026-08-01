-- Day 41 of #100DaysOfSQL

-- Q145. Customers with orders but no shipments
-- Tables: orders (order_id, customer_id), shipments (shipment_id, order_id)
SELECT DISTINCT
    o.customer_id
FROM orders o
LEFT JOIN shipments s ON o.order_id = s.order_id
WHERE s.order_id IS NULL;


-- Q146. Total number of unique products sold in the last quarter
-- Table: sales (sale_id, product_id, sale_date)
SELECT
    COUNT(DISTINCT product_id) AS unique_products_sold
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '3 months';


-- Q147. Top 5 customers by total order value in the last year
-- Table: orders (order_id, customer_id, order_value, order_date)
SELECT
    customer_id,
    SUM(order_value) AS total_order_value
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY customer_id
ORDER BY total_order_value DESC
LIMIT 5;


-- Q148. Number of employees who changed departments in the last year
-- Table: dept_history (emp_id, department, change_date)
SELECT
    COUNT(DISTINCT emp_id) AS employees_changed_dept
FROM dept_history
WHERE change_date >= CURRENT_DATE - INTERVAL '1 year';


-- Q151. Employees who have never received a promotion
-- Tables: employees (emp_id, name), promotions (promo_id, emp_id)
SELECT
    e.emp_id,
    e.name
FROM employees e
LEFT JOIN promotions p ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;

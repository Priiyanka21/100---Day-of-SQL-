-- ============================================
-- SQL Practice: Q111 to Q127
-- Schema assumptions noted table-wise (adjust column names to your actual DB)
-- ============================================

-- Q111. Average salary of employees hired each month
-- Table: employees(emp_id, name, salary, hire_date)
SELECT 
    TO_CHAR(hire_date, 'YYYY-MM') AS hire_month,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY-MM')
ORDER BY hire_month;

-- Q112. Number of employees who share the same birthday (month-day)
-- Table: employees(emp_id, name, dob)
SELECT 
    TO_CHAR(dob, 'MM-DD') AS birth_day,
    COUNT(*) AS employee_count
FROM employees
GROUP BY TO_CHAR(dob, 'MM-DD')
HAVING COUNT(*) > 1
ORDER BY employee_count DESC;

-- Q113. Customers who ordered the same product multiple times in one day
-- Table: sales(sale_id, customer_id, product_id, sale_date, quantity)
SELECT customer_id, product_id, sale_date, COUNT(*) AS times_ordered
FROM sales
GROUP BY customer_id, product_id, sale_date
HAVING COUNT(*) > 1;

-- Q114. Total sales for each product including products with zero sales
-- Tables: products(product_id, product_name), sales(sale_id, product_id, amount)
SELECT p.product_id, p.product_name, COALESCE(SUM(s.amount), 0) AS total_sales
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id;

-- Q115. Day with the largest difference between max and min temperature
-- Table: weather_data(date, max_temp, min_temp)
SELECT date, (max_temp - min_temp) AS temp_diff
FROM weather_data
ORDER BY temp_diff DESC
LIMIT 1;

-- Q116. Products with sales only in a specific country (e.g. 'India')
-- Tables: customers(customer_id, country), sales(sale_id, customer_id, product_id)
SELECT s.product_id
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.product_id
HAVING COUNT(DISTINCT c.country) = 1
   AND MAX(c.country) = 'India';

-- Q117. Employee who worked the most hours in a project
-- Table: project_assignments(emp_id, project_id, hours_worked)
SELECT project_id, emp_id, hours_worked
FROM (
    SELECT project_id, emp_id, hours_worked,
           RANK() OVER (PARTITION BY project_id ORDER BY hours_worked DESC) AS rnk
    FROM project_assignments
) ranked
WHERE rnk = 1;

-- Q118. First order date for each customer
-- Table: orders(order_id, customer_id, order_date)
SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;

-- Q119. Ratio of males to females in each department
-- Table: employees(emp_id, department, gender)
SELECT 
    department,
    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
    ROUND(
        SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END)::NUMERIC / 
        NULLIF(SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END), 0), 2
    ) AS male_to_female_ratio
FROM employees
GROUP BY department;

-- Q120. Employees not assigned to any project in the last year
-- Tables: employees(emp_id, name), project_assignments(emp_id, assigned_date)
SELECT e.emp_id, e.name
FROM employees e
WHERE e.emp_id NOT IN (
    SELECT emp_id FROM project_assignments
    WHERE assigned_date >= CURRENT_DATE - INTERVAL '1 year'
);

-- Q121. Employees with the highest number of direct reports
-- Table: employees(emp_id, name, manager_id)
SELECT manager_id, COUNT(*) AS direct_reports
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY direct_reports DESC
LIMIT 1;

-- Q122. Average time difference between order and delivery
-- Table: orders(order_id, order_date, delivery_date)
SELECT ROUND(AVG(EXTRACT(EPOCH FROM (delivery_date - order_date)) / 86400), 2) AS avg_days_to_deliver
FROM orders
WHERE delivery_date IS NOT NULL;

-- Q123. Department with the youngest average employee age
-- Table: employees(emp_id, department, dob)
SELECT department, AVG(DATE_PART('year', AGE(dob))) AS avg_age
FROM employees
GROUP BY department
ORDER BY avg_age ASC
LIMIT 1;

-- Q124. Employee(s) with the highest number of late arrivals
-- Table: attendance(emp_id, date, status)  -- status = 'Late'/'On Time'
SELECT emp_id, COUNT(*) AS late_count
FROM attendance
WHERE status = 'Late'
GROUP BY emp_id
HAVING COUNT(*) = (
    SELECT MAX(late_cnt) FROM (
        SELECT COUNT(*) AS late_cnt
        FROM attendance
        WHERE status = 'Late'
        GROUP BY emp_id
    ) sub
);

-- Q125. Total revenue generated per sales representative
-- Table: sales(sale_id, sales_rep, amount)
SELECT sales_rep, SUM(amount) AS total_revenue
FROM sales
GROUP BY sales_rep
ORDER BY total_revenue DESC;

-- Q126. Customers with no orders in the last year
-- Tables: customers(customer_id, name), orders(order_id, customer_id, order_date)
SELECT c.customer_id, c.name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT customer_id FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
);

-- Q127. Customers with orders where no product quantity is less than 5
-- Table: order_items(order_id, customer_id, product_id, quantity)
SELECT DISTINCT customer_id
FROM order_items oi
WHERE customer_id NOT IN (
    SELECT customer_id FROM order_items WHERE quantity < 5
);

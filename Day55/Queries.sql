-- Q271. Product with highest sales for each month
SELECT month, product_id, total_sales
FROM (
    SELECT DATE_TRUNC('month', sale_date) AS month,
           product_id,
           SUM(amount) AS total_sales,
           RANK() OVER (PARTITION BY DATE_TRUNC('month', sale_date) ORDER BY SUM(amount) DESC) AS rnk
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date), product_id
) t
WHERE rnk = 1;

-- Q272. Customers with highest order count in each region
SELECT region, customer_id, order_count
FROM (
    SELECT c.region, c.customer_id, COUNT(o.order_id) AS order_count,
           RANK() OVER (PARTITION BY c.region ORDER BY COUNT(o.order_id) DESC) AS rnk
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.region, c.customer_id
) t
WHERE rnk = 1;

-- Q273. Flag customers with increase in orders every month this year
WITH monthly AS (
    SELECT customer_id,
           DATE_TRUNC('month', order_date) AS month,
           COUNT(*) AS order_count
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
trend AS (
    SELECT customer_id, month, order_count,
           LAG(order_count) OVER (PARTITION BY customer_id ORDER BY month) AS prev_count
    FROM monthly
)
SELECT customer_id
FROM trend
GROUP BY customer_id
HAVING BOOL_AND(prev_count IS NULL OR order_count > prev_count);

-- Q274. Employees whose hire date is same weekday as manager's
SELECT e.employee_id, e.name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE EXTRACT(DOW FROM e.hire_date) = EXTRACT(DOW FROM m.hire_date);

-- Q275. "Suppliers" who delivered to all regions (using shipments)
SELECT employee_id
FROM shipments
GROUP BY employee_id
HAVING COUNT(DISTINCT region) = (SELECT COUNT(DISTINCT region) FROM shipments);

-- Q276. Employees with salary in top 5% company-wide
SELECT employee_id, name, salary
FROM (
    SELECT employee_id, name, salary,
           PERCENT_RANK() OVER (ORDER BY salary DESC) AS pct_rank
    FROM employees
) t
WHERE pct_rank <= 0.05;

-- Q277. Find median salary
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees;

-- Q278. Longest consecutive streak of daily logins per user
WITH ranked AS (
    SELECT user_id, login_date,
           login_date - (ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date))::int AS grp
    FROM (SELECT DISTINCT user_id, login_date FROM user_logins) d
),
streaks AS (
    SELECT user_id, grp, COUNT(*) AS streak_length
    FROM ranked
    GROUP BY user_id, grp
)
SELECT user_id, MAX(streak_length) AS longest_streak
FROM streaks
GROUP BY user_id;

-- Q279. Compare two tables (employees vs customers) - rows with differences (shared id)
SELECT e.employee_id AS id, 'employees' AS source
FROM employees e
JOIN customers c ON e.employee_id = c.customer_id
WHERE e.name IS DISTINCT FROM c.name
   OR e.email IS DISTINCT FROM c.email;
-- Note: Generic example, adjust column names to your actual shared-id tables

-- Q280. Identify overlapping date ranges for bookings
SELECT b1.booking_id AS booking1, b2.booking_id AS booking2
FROM bookings b1
JOIN bookings b2 
  ON b1.booking_id < b2.booking_id
 AND b1.start_date <= b2.end_date
 AND b2.start_date <= b1.end_date;

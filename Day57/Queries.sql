-- Q291. Find the median salary per department
SELECT
    department_id,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees
GROUP BY department_id;

-- Q292. Find customers whose orders decreased consecutively for 3 months
WITH monthly_orders AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', order_date) AS month,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
comparison AS (
    SELECT
        customer_id,
        month,
        order_count,
        LAG(order_count, 1) OVER (
            PARTITION BY customer_id ORDER BY month
        ) AS prev_1,
        LAG(order_count, 2) OVER (
            PARTITION BY customer_id ORDER BY month
        ) AS prev_2
    FROM monthly_orders
)
SELECT DISTINCT customer_id
FROM comparison
WHERE order_count < prev_1
  AND prev_1 < prev_2;

-- Q293. Find customers whose order frequency increased month-over-month
WITH monthly_orders AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', order_date) AS month,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
comparison AS (
    SELECT
        customer_id,
        month,
        order_count,
        LAG(order_count) OVER (
            PARTITION BY customer_id ORDER BY month
        ) AS prev_count
    FROM monthly_orders
)
SELECT DISTINCT customer_id
FROM comparison
WHERE order_count > prev_count;

-- Q294. Recursive query to find the full reporting chain for each employee
WITH RECURSIVE reporting_chain AS (
    SELECT
        employee_id,
        name,
        manager_id,
        CAST(name AS TEXT) AS reporting_chain
    FROM employees

    UNION ALL

    SELECT
        rc.employee_id,
        rc.name,
        e.manager_id,
        rc.reporting_chain || ' -> ' || e.name
    FROM reporting_chain rc
    JOIN employees e
        ON rc.manager_id = e.employee_id
)
SELECT
    employee_id,
    name,
    reporting_chain
FROM reporting_chain
WHERE manager_id IS NULL;

-- Q295. Find gaps in a sequence of numbers (missing IDs)
WITH RECURSIVE id_range AS (
    SELECT MIN(employee_id) AS id
    FROM employees

    UNION ALL

    SELECT id + 1
    FROM id_range
    WHERE id < (SELECT MAX(employee_id) FROM employees)
)
SELECT id AS missing_id
FROM id_range
WHERE id NOT IN (
    SELECT employee_id
    FROM employees
)
ORDER BY id;

-- Q296. Pivot rows into columns dynamically (fixed values)
SELECT
    product_id,
    SUM(CASE WHEN month = '2026-01' THEN total_sales ELSE 0 END) AS jan_sales,
    SUM(CASE WHEN month = '2026-02' THEN total_sales ELSE 0 END) AS feb_sales,
    SUM(CASE WHEN month = '2026-03' THEN total_sales ELSE 0 END) AS mar_sales,
    SUM(CASE WHEN month = '2026-04' THEN total_sales ELSE 0 END) AS apr_sales
FROM sales
GROUP BY product_id
ORDER BY product_id;

-- Q297. Find all employees who are at the lowest level in the hierarchy
SELECT e.*
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employees sub
    WHERE sub.manager_id = e.employee_id
);

-- Q298. Generate a calendar table with all dates for the current year
SELECT
    date_day::date AS calendar_date
FROM GENERATE_SERIES(
    DATE_TRUNC('year', CURRENT_DATE),
    DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 year' - INTERVAL '1 day',
    INTERVAL '1 day'
) AS date_day
ORDER BY calendar_date;

-- Q299. Recursive query to get all descendants of a manager
WITH RECURSIVE descendants AS (
    SELECT
        employee_id,
        name,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id = 101

    UNION ALL

    SELECT
        e.employee_id,
        e.name,
        e.manager_id,
        d.level + 1
    FROM employees e
    JOIN descendants d
        ON e.manager_id = d.employee_id
)
SELECT *
FROM descendants
ORDER BY level, employee_id;

-- Q300. Find employees whose salaries are between the 25th and 75th percentile
WITH percentiles AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) AS p25,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) AS p75
    FROM employees
)
SELECT e.*
FROM employees e
CROSS JOIN percentiles p
WHERE e.salary BETWEEN p.p25 AND p.p75
ORDER BY e.salary;

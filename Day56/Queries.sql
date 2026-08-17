-- Q281. Aggregate JSON data to list all employee names in a department as JSON array
SELECT department_id,
       json_agg(name) AS employee_names
FROM employees
GROUP BY department_id;


-- Q282. Find consecutive days where sales were above a threshold
WITH flagged AS (
    SELECT sale_date, total_sales,
           CASE WHEN total_sales > 1000 THEN 1 ELSE 0 END AS is_above
    FROM sales
),
grouped AS (
    SELECT *,
           sale_date - (ROW_NUMBER() OVER (PARTITION BY is_above ORDER BY sale_date))::int AS grp
    FROM flagged
    WHERE is_above = 1
)
SELECT MIN(sale_date) AS streak_start,
       MAX(sale_date) AS streak_end,
       COUNT(*) AS streak_length
FROM grouped
GROUP BY grp
HAVING COUNT(*) >= 2
ORDER BY streak_start;


-- Q283. Identify overlapping shifts for employees
SELECT s1.employee_id,
       s1.shift_id AS shift1,
       s2.shift_id AS shift2,
       s1.start_time AS s1_start, s1.end_time AS s1_end,
       s2.start_time AS s2_start, s2.end_time AS s2_end
FROM shifts s1
JOIN shifts s2
  ON s1.employee_id = s2.employee_id
 AND s1.shift_id < s2.shift_id
 AND s1.start_time < s2.end_time
 AND s2.start_time < s1.end_time;


-- Q284. Identify employees who had overlapping project assignments
SELECT p1.employee_id,
       p1.project_id AS project1,
       p2.project_id AS project2,
       p1.start_date AS p1_start, p1.end_date AS p1_end,
       p2.start_date AS p2_start, p2.end_date AS p2_end
FROM project_assignments p1
JOIN project_assignments p2
  ON p1.employee_id = p2.employee_id
 AND p1.project_id < p2.project_id
 AND p1.start_date < p2.end_date
 AND p2.start_date < p1.end_date;


-- Q285. Pivot monthly sales data for each product into columns
SELECT product_id,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 1 THEN total_sales ELSE 0 END) AS jan,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 2 THEN total_sales ELSE 0 END) AS feb,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 3 THEN total_sales ELSE 0 END) AS mar,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 4 THEN total_sales ELSE 0 END) AS apr,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 5 THEN total_sales ELSE 0 END) AS may,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 6 THEN total_sales ELSE 0 END) AS jun,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 7 THEN total_sales ELSE 0 END) AS jul,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 8 THEN total_sales ELSE 0 END) AS aug,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 9 THEN total_sales ELSE 0 END) AS sep,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 10 THEN total_sales ELSE 0 END) AS oct,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN total_sales ELSE 0 END) AS nov,
       SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 12 THEN total_sales ELSE 0 END) AS dec
FROM sales
GROUP BY product_id;


-- Q286. Find customers with the longest gap between two consecutive orders
WITH ordered AS (
    SELECT customer_id, order_date,
           LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order
    FROM orders
),
gaps AS (
    SELECT customer_id, order_date, prev_order,
           order_date - prev_order AS gap_days
    FROM ordered
    WHERE prev_order IS NOT NULL
)
SELECT customer_id, MAX(gap_days) AS longest_gap
FROM gaps
GROUP BY customer_id
ORDER BY longest_gap DESC;


-- Q287. Find the median salary of employees
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees;


-- Q288. Find employees with consecutive workdays
WITH grouped AS (
    SELECT employee_id, work_date,
           work_date - (ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY work_date))::int AS grp
    FROM attendance
)
SELECT employee_id, MIN(work_date) AS streak_start, MAX(work_date) AS streak_end,
       COUNT(*) AS consecutive_days
FROM grouped
GROUP BY employee_id, grp
HAVING COUNT(*) >= 2
ORDER BY employee_id, streak_start;


-- Q289. Find employees with overlapping project assignments
SELECT p1.employee_id,
       p1.project_id AS project1,
       p2.project_id AS project2
FROM project_assignments p1
JOIN project_assignments p2
  ON p1.employee_id = p2.employee_id
 AND p1.project_id < p2.project_id
 AND p1.start_date < p2.end_date
 AND p2.start_date < p1.end_date;


-- Q290. Find employees with the longest consecutive workdays
WITH grouped AS (
    SELECT employee_id, work_date,
           work_date - (ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY work_date))::int AS grp
    FROM attendance
),
streaks AS (
    SELECT employee_id, grp, COUNT(*) AS streak_length,
           MIN(work_date) AS streak_start, MAX(work_date) AS streak_end
    FROM grouped
    GROUP BY employee_id, grp
)
SELECT DISTINCT ON (employee_id) employee_id, streak_length, streak_start, streak_end
FROM streaks
ORDER BY employee_id, streak_length DESC;

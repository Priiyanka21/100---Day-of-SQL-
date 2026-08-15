-- Q261. Find employees who worked on all projects in the company.
SELECT pa.employee_id
FROM project_assignments pa
GROUP BY pa.employee_id
HAVING COUNT(DISTINCT pa.project_id) = (SELECT COUNT(*) FROM projects);


-- Q262. Find customers who ordered products from all categories.
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.category) = (SELECT COUNT(DISTINCT category) FROM products);


-- Q263. Find products with sales only during holiday seasons.
-- Assuming holiday months are Nov & Dec (adjust as needed)
SELECT product_id
FROM sales
GROUP BY product_id
HAVING COUNT(*) = SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) IN (11,12) THEN 1 ELSE 0 END);


-- Q264. Find the department with the largest increase in employee count compared to last year.
WITH yearly_counts AS (
    SELECT department, EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS emp_count
    FROM employees
    GROUP BY department, EXTRACT(YEAR FROM hire_date)
),
dept_diff AS (
    SELECT department,
           hire_year,
           emp_count,
           emp_count - LAG(emp_count) OVER (PARTITION BY department ORDER BY hire_year) AS increase
    FROM yearly_counts
)
SELECT department, hire_year, increase
FROM dept_diff
ORDER BY increase DESC NULLS LAST
LIMIT 1;


-- Q265. Find employees whose salaries increased every year.
WITH salary_diff AS (
    SELECT employee_id,
           salary,
           effective_year,
           salary - LAG(salary) OVER (PARTITION BY employee_id ORDER BY effective_year) AS diff
    FROM salary_history
)
SELECT employee_id
FROM salary_diff
GROUP BY employee_id
HAVING BOOL_AND(diff > 0) FILTER (WHERE diff IS NOT NULL);


-- Q266. Find the day with the highest sales in each month.
WITH daily_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
           order_date::date AS sale_day,
           SUM(total_amount) AS day_total
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date), order_date::date
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY day_total DESC) AS rnk
    FROM daily_sales
)
SELECT month, sale_day, day_total
FROM ranked
WHERE rnk = 1;


-- Q267. Find products with the highest sales increase compared to the previous month.
WITH monthly_sales AS (
    SELECT product_id,
           DATE_TRUNC('month', sale_date) AS month,
           SUM(amount) AS total_sales
    FROM sales
    GROUP BY product_id, DATE_TRUNC('month', sale_date)
),
sales_diff AS (
    SELECT product_id,
           month,
           total_sales,
           total_sales - LAG(total_sales) OVER (PARTITION BY product_id ORDER BY month) AS increase
    FROM monthly_sales
)
SELECT product_id, month, increase
FROM sales_diff
WHERE increase IS NOT NULL
ORDER BY increase DESC
LIMIT 1;


-- Q268. Find products with the lowest average rating per category.
WITH avg_ratings AS (
    SELECT p.category,
           pr.product_id,
           AVG(pr.rating) AS avg_rating
    FROM product_reviews pr
    JOIN products p ON pr.product_id = p.product_id
    GROUP BY p.category, pr.product_id
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY avg_rating ASC) AS rnk
    FROM avg_ratings
)
SELECT category, product_id, avg_rating
FROM ranked
WHERE rnk = 1;


-- Q269. Find employees who report to a manager hired after them.
SELECT e.employee_id, e.hire_date AS emp_hire_date, m.employee_id AS manager_id, m.hire_date AS manager_hire_date
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE m.hire_date > e.hire_date;


-- Q270. Find products that have been ordered but never reviewed.
SELECT DISTINCT s.product_id
FROM sales s
LEFT JOIN product_reviews pr ON s.product_id = pr.product_id
WHERE pr.product_id IS NULL;

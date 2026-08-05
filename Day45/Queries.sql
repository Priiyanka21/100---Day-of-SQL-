-- Q173: Retrieve the last 5 orders for each customer
SELECT *
FROM (
    SELECT o.*,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM orders o
) t
WHERE rn <= 5;

-- Q174: Difference between current row's sales and previous row's sales, partitioned by product
SELECT product_id, sale_date, amount,
       amount - LAG(amount) OVER (PARTITION BY product_id ORDER BY sale_date) AS sales_diff
FROM sales;

-- Q175: Running count of employees joined each year
SELECT hire_year,
       SUM(emp_count) OVER (ORDER BY hire_year) AS running_count
FROM (
    SELECT EXTRACT(YEAR FROM hire_date) AS hire_year,
           COUNT(*) AS emp_count
    FROM employees
    GROUP BY EXTRACT(YEAR FROM hire_date)
) t;

-- Q176: Second most recent order date per customer
SELECT customer_id, order_date
FROM (
    SELECT customer_id, order_date,
           DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rnk
    FROM orders
) t
WHERE rnk = 2;

-- Q177: Employees with salary in top 10% in their department
SELECT *
FROM (
    SELECT *,
           PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS pct_rank
    FROM employees
) t
WHERE pct_rank >= 0.9;

-- Q178: Find gaps in date sequences for each customer (missing days)
WITH date_seq AS (
    SELECT customer_id, sale_date,
           LEAD(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) AS next_date
    FROM sales
)
SELECT customer_id, sale_date AS gap_start, next_date AS gap_end,
       next_date - sale_date AS gap_days
FROM date_seq
WHERE next_date - sale_date > 1;

-- Q179: Rank employees by salary within department, and calculate percent rank
SELECT employee_id, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank,
       PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS pct_rank
FROM employees;

-- Q180: Employees whose salary is above department average but below company-wide average
SELECT *
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY department) AS dept_avg,
           AVG(salary) OVER () AS company_avg
    FROM employees
) t
WHERE salary > dept_avg AND salary < company_avg;

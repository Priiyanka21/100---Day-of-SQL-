-- Q168: Find employees who have the same salary as their manager
SELECT e.employee_id, e.name, e.salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary = m.salary;

-- Q169: Find departments with the highest average salary
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC
LIMIT 1;

-- Q170: Rank salespeople by monthly sales, resetting rank every month
SELECT salesperson_id, sale_month, total_sales,
       RANK() OVER (PARTITION BY sale_month ORDER BY total_sales DESC) AS sales_rank
FROM (
    SELECT salesperson_id, DATE_TRUNC('month', sale_date) AS sale_month,
           SUM(amount) AS total_sales
    FROM sales
    GROUP BY salesperson_id, DATE_TRUNC('month', sale_date)
) monthly_sales;

-- Q171: Percentage change in sales vs previous month for each product
SELECT product_id, sale_month, total_sales,
       ROUND(
         ((total_sales - LAG(total_sales) OVER (PARTITION BY product_id ORDER BY sale_month))
         / LAG(total_sales) OVER (PARTITION BY product_id ORDER BY sale_month)) * 100, 2
       ) AS pct_change
FROM (
    SELECT product_id, DATE_TRUNC('month', sale_date) AS sale_month,
           SUM(amount) AS total_sales
    FROM sales
    GROUP BY product_id, DATE_TRUNC('month', sale_date)
) monthly;

-- Q172: Employees earning more than company avg but less than their dept's max salary
SELECT e.employee_id, e.name, e.salary, e.department
FROM employees e
WHERE e.salary > (SELECT AVG(salary) FROM employees)
  AND e.salary < (SELECT MAX(salary) FROM employees e2 WHERE e2.department = e.department);

-- Q173: Last 5 orders for each customer
SELECT *
FROM (
    SELECT o.*, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM orders o
) ranked
WHERE rn <= 5;

-- Q174: Difference between current and previous row's sales, partitioned by product
SELECT product_id, sale_date, amount,
       amount - LAG(amount) OVER (PARTITION BY product_id ORDER BY sale_date) AS diff_from_prev
FROM sales;

-- Q175: Running count of employees joined each year
SELECT join_year, employees_joined,
       SUM(employees_joined) OVER (ORDER BY join_year) AS running_count
FROM (
    SELECT EXTRACT(YEAR FROM join_date) AS join_year, COUNT(*) AS employees_joined
    FROM employees
    GROUP BY EXTRACT(YEAR FROM join_date)
) yearly
ORDER BY join_year;

-- Q176: Second most recent order date per customer
SELECT customer_id, order_date
FROM (
    SELECT customer_id, order_date,
           DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rnk
    FROM orders
) ranked
WHERE rnk = 2;

-- Q177: Employees with salary in top 10% within their department
SELECT employee_id, name, department, salary
FROM (
    SELECT *, PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS pct_rank
    FROM employees
) ranked
WHERE pct_rank <= 0.1;

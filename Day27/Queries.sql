-- Q6: Customers who haven't made any purchase
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;


-- Q7: Conditional aggregation - male/female count per department
SELECT department,
       COUNT(CASE WHEN gender = 'M' THEN 1 END) AS male_count,
       COUNT(CASE WHEN gender = 'F' THEN 1 END) AS female_count
FROM employees
GROUP BY department;


-- Q8: Employees with salary greater than company average, descending
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;


-- Q9: First and last purchase date per customer
SELECT customer_id,
       MIN(purchase_date) AS first_purchase,
       MAX(purchase_date) AS last_purchase
FROM sales
GROUP BY customer_id;


-- Q10: Number of employees in each job title
SELECT job_title, COUNT(*) AS emp_count
FROM employees
GROUP BY job_title;

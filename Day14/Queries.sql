-- Day 14: Sorting, Filtering & Aggregation Practice

-- 1. Fixed: List employees sorted by salary in DESCENDING order
SELECT first_name, last_name, salary
FROM employee2
ORDER BY salary DESC;

-- 2. Find employees earning above the average salary
SELECT first_name, last_name, salary
FROM employee2
WHERE salary > (SELECT AVG(salary) FROM employee2);

-- 3. Get the second highest salary (without using LIMIT/OFFSET)
SELECT MAX(salary) AS second_highest
FROM employee2
WHERE salary < (SELECT MAX(salary) FROM employee2);

-- 4. Count employees per department
SELECT department, COUNT(*) AS emp_count
FROM employee2
GROUP BY department
ORDER BY emp_count DESC;

-- 5. Find departments where average salary is above 55000
SELECT department, AVG(salary) AS avg_salary
FROM employee2
GROUP BY department
HAVING AVG(salary) > 55000;

-- 6. Concatenate first and last name into a full name
SELECT first_name || ' ' || last_name AS full_name, salary
FROM employee2;

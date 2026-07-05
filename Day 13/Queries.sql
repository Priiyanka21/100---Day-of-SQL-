SELECT * FROM employee2;

-- Retrieve employees whose salary is between 40,000 and 60,000
-- Use BETWEEN Operator

SELECT first_name, last_name, salary
FROM employee2
WHERE salary BETWEEN 40000 AND 60000;

-- Find employees whose email addresses end with gmail.com
-- Use LIKE Operator

SELECT first_name, last_name, email
FROM employee2
WHERE email LIKE '%@gmail.com';

-- Retrieve employees who belong to either the 'Finance' or 'Marketing' departments
-- Use IN Operator

SELECT first_name, last_name, department
FROM employee2
WHERE department IN ('Finance', 'Marketing');

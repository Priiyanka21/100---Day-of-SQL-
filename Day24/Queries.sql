-- Day 24 of #100DaysOfSQL
-- Topic: JOINs (RIGHT JOIN & INNER JOIN)

-- Create Departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Insert data into Departments
INSERT INTO departments (department_id, department_name)
VALUES
(101, 'sales'),
(102, 'marketing'),
(103, 'it'),
(104, 'hr');

SELECT * FROM departments;

-- RIGHT JOIN: returns all departments, even those with no matching employees
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees3 e
RIGHT JOIN departments d
ON e.department_id = d.department_id;

-- INNER JOIN: returns only matching records between employees3 and departments
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees3 e
INNER JOIN departments d
ON e.department_id = d.department_id;

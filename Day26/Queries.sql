-- ================================
-- STEP 1: Create Tables
-- ================================

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    salary NUMERIC,
    department_id INT,
    manager_id INT,
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ================================
-- STEP 2: Insert Sample Data
-- ================================

INSERT INTO departments (department_name) VALUES
('HR'), ('IT'), ('Sales'), ('Finance'), ('Marketing');

INSERT INTO employees (name, email, salary, department_id, manager_id, hire_date) VALUES
('Amit', 'amit@mail.com', 55000, 2, NULL, '2024-01-15'),
('Priya', 'priya@mail.com', 60000, 2, 1, '2023-06-10'),
('Rohit', 'rohit@mail.com', 45000, 1, NULL, '2022-03-20'),
('Neha', 'neha@mail.com', 70000, 2, 1, '2021-11-05'),
('Karan', 'karan@mail.com', 50000, 1, 3, '2024-05-01'),
('Simran', 'simran@mail.com', 65000, 3, NULL, '2020-09-12'),
('Vikas', 'vikas@mail.com', 55000, 3, 6, '2023-12-01'),
('Anjali', 'anjali@mail.com', 48000, 1, 3, '2024-02-14'),
('Suresh', 'suresh@mail.com', 72000, 2, 1, '2019-07-23'),
('Meena', 'meena@mail.com', 50000, 1, 3, '2024-06-10');
-- Note: department_id 4 (Finance) aur 5 (Marketing) me koi employee nahi -> Q5 test karega

-- ================================
-- STEP 3: Run These 5 Queries
-- ================================

-- Q1. Second highest salary
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Q2. Duplicate records
SELECT name, email, salary, department_id, COUNT(*)
FROM employees
GROUP BY name, email, salary, department_id
HAVING COUNT(*) > 1;

-- Q3. Departments with more than 5 employees (yahan koi dept 5+ nahi hoga, 
-- toh number ghata ke test karo: > 2)
SELECT department_id, COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- Q4. Employees joined in last 6 months
SELECT *
FROM employees
WHERE hire_date >= CURRENT_DATE - INTERVAL '6 months';

-- Q5. Departments with no employees
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.id IS NULL;

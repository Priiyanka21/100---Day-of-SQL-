-- Day 1: Create Database and Table in SQL
-- Topic: DDL Commands - CREATE TABLE, INSERT INTO, SELECT

-- Create Employees Table
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10,2),
    department VARCHAR(30),
    joining_date DATE
);

-- Insert Data
INSERT INTO employees (name, salary, department, joining_date)
VALUES 
('Priyanka', 74000, 'Analytics', '2024-08-01'),
('Sneha', 50000, 'Developer', '2025-05-21'),
('Neha', 67000, 'Developer', '2026-05-21'),
('Jyoti', 50000, 'Web Developer', '2025-05-25'),
('Kriti', 790000, 'Developer', '2025-05-21'),
('Sikha', 50000, 'Developer', '2025-05-21');

-- Select All Data
SELECT * FROM employees;

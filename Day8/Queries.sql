-- ═══════════════════════════════════════════════
--  Day 8 — Employee Database Assignment
--  #100DaysOfSQL
-- ═══════════════════════════════════════════════

-- ─── Table Creation ───────────────────────────────
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2) CHECK (salary > 0),
    joining_date DATE NOT NULL,
    age INT CHECK (age >= 18)
);

SELECT * FROM employees;

-- ─── Insert Data ──────────────────────────────────
INSERT INTO employees (first_name, last_name, department, salary, joining_date, age)
VALUES
    ('Amit', 'Sharma', 'IT', 60000, '2022-05-2', 28),
    ('mit', 'Rao', 'HR', 66000, '2024-05-2', 36),
    ('Nia', 'Sharma', 'IT', 68000, '2026-05-2', 24),
    ('Anuuj', 'Patel', 'Operation', 50000, '2022-05-2', 28),
    ('Ani', 'Varma', 'Finance', 60000, '2025-05-2', 18);


-- ═══════════════════════════════════════════════
--  Assignment Questions
-- ═══════════════════════════════════════════════

-- Q1: Retrieve all employees' first_names and their departments.
SELECT
    FIRST_NAME,
    DEPARTMENT
FROM
    EMPLOYEES;


-- Q2: Update the salary of all employees in the 'IT' department
--     by increasing it by 10%.
UPDATE EMPLOYEES
SET
    SALARY = SALARY + (SALARY * 0.1)
WHERE
    DEPARTMENT = 'IT';


-- Q3: Delete all employees who are older than 34 years.
DELETE FROM EMPLOYEES
WHERE
    AGE > 30;


-- Q4: Add a new column 'email' to the 'employees' table.
ALTER TABLE EMPLOYEES
ADD COLUMN EMAIL VARCHAR(100);


-- Q5: Rename the 'department' column to 'dept_name'.
ALTER TABLE EMPLOYEES
RENAME COLUMN DEPARTMENT TO DEPT_NAME;


-- Q6: Retrieve the names of employees who joined after January 1, 2024.
SELECT first_name, last_name, joining_date FROM employees
WHERE joining_date > '2021-01-01';


-- Q7: Change the data type of the 'salary' column to 'INTEGER'.
ALTER TABLE employees
ALTER COLUMN salary TYPE INTEGER USING salary::INTEGER;


-- Q8: List all employees with their age and salary
--     in descending order of salary.
SELECT first_name, age, salary FROM employees
ORDER BY salary DESC;


-- Q9: Insert a new employee with the following details:
-- ('Raj', 'Singh', 'Marketing', 60000, '2024-05-01', 30)
INSERT INTO employees (first_name, last_name, Dept_name, salary, joining_date, age)
VALUES ('Raj', 'Singh', 'Marketing', 60000, '2024-05-01', 30);


-- Q10: Update age of employee +1 to every employee.
UPDATE employees
SET age = age + 1;

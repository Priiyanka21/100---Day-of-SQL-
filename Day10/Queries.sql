-- 1. Created a fresh table (if needed)
DROP TABLE IF EXISTS employee2;

CREATE TABLE employee2(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    department VARCHAR(20),
    salary NUMERIC(10,2),
    joining_date DATE,
    age INT
);

-- 2. Inserted data
INSERT INTO employee2 
(employee_id, first_name, last_name, salary)
VALUES
(101, 'John', 'Doe', 50000),
(102, 'Jane', 'Smith', 60000),
(103, 'Raj', 'Kumar', 45000),
(104, 'Priya', 'Sharma', 70000),
(105, 'Amit', 'Verma', 55000);

-- 3. Checked the data
SELECT * FROM employee2;

-- 4. Calculated bonus
SELECT
    FIRST_NAME,
    SALARY,
    (SALARY * 0.10) AS BONUS
FROM em

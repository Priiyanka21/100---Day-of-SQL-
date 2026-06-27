-- Day 05: UPDATE & SET Statements
-- 100 Days of SQL Challenge

-- Drop table if exists
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INT,
    city VARCHAR(50)
);

-- Insert sample data
INSERT INTO users (user_id, name, email, age, city)
VALUES
(1, 'John doe', 'john.doe@example.com', 25, 'Mumbai'),
(2, 'Riya', 'riya@example.com', 22, 'Delhi'),
(3, 'Ria', 'ria@example.com', 20, 'Pune'),
(4, 'Nia', 'nia@example.com', 19, 'Bangalore'),
(5, 'Ajit', 'ajit@example.com', 20, 'Chennai');

-- View all data
SELECT * FROM users;

-- Update city to Chennai where age >= 30
UPDATE users
SET city = 'Chennai'
WHERE age >= 30;

-- Update age and city for Nia
UPDATE users
SET age = 31, city = 'Kolkata'
WHERE name = 'Nia';

-- View updated data
SELECT * FROM users;

-- Order by user_id
SELECT * FROM users 
ORDER BY user_id ASC;

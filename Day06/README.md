-- Drop the table if it already exists
DROP TABLE IF EXISTS users;

-- Create the users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INT,
    city VARCHAR(50)
);

-- Insert 5 sample users into the users table
INSERT INTO users (name, email, age, city)
VALUES
    ('John doe', 'johndoe@gmail.com', 25, 'Mumbai'),
    ('Riya', 'riya@gmail.com', 25, 'Mumbai'),
    ('Ria', 'ria@gmail.com', 25, 'Mumbai'),
    ('Nia', 'nia@gmail.com', 25, 'Mumbai'),
    ('Ajit', 'ajit@gmail.com', 25, 'Mumbai');

-- View all users
SELECT * FROM users;

-- Select specific columns
SELECT name, city FROM users;

-- Update age
UPDATE users
SET age = 26
WHERE name = 'Ajit';

-- View updated data
SELECT * FROM users;

-- Order by user_id
SELECT * FROM users ORDER BY user_id ASC;

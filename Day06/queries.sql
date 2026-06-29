-- =============================================
-- Day 6 - 100 Days of SQL
-- Topics: DROP TABLE, CREATE TABLE, INSERT,
--         SELECT, UPDATE, ORDER BY,
--         Graph Visualiser (Bar, Pie, Line)
-- =============================================

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

-- View empty table
SELECT * FROM users;

-- Insert 5 sample users into the users table
INSERT INTO users (user_id, name, email, age, city)
VALUES
  (1, 'John Doe', 'johndoe@gmail.com', 28, 'Mumbai'),
  (2, 'Riya', 'riya@gmai

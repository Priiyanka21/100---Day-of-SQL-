-- =============================================
-- Day 7 - 100 Days of SQL
-- Topics: ALTER TABLE, CONSTRAINTS, RENAME
-- =============================================

-- Create the table
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    age INT,
    city VARCHAR(50)
);

-- Insert 5 users
INSERT INTO users (name, email, age, city)
VALUES
  ('Rajesh', 'rajesh@gmail.com', 25, 'Mumbai'),
  ('Priti', 'p@gmail.com', 25, 'Mumbai'),
  ('Nia', 'nia@gmail.com', 28, 'Delhi'),
  ('Amit', 'amit@gmail.com', 32, 'Pune'),
  ('Sara', 'sara@gmail.com', 22, 'Bangalore');

-- View name and city
SELECT name, city FROM users;

-- Update Rajesh's age
UPDATE users
SET age = 26
WHERE name = 'Rajesh';

-- View all data
SELECT * FROM users;

-- Update city to Chennai where age is 30 or above
UPDATE users
SET city = 'Chennai'
WHERE age >= 30;

-- Update Nia's age and city
UPDATE users
SET age = 31, city = 'Kolkata'
WHERE name = 'Nia';

-- View all data ordered by user_id
SELECT * FROM users ORDER BY user_id ASC;

-- Rename column name to full_name
ALTER TABLE users
RENAME COLUMN name TO full_name;

-- View after rename
SELECT * FROM users ORDER BY user_id ASC;

-- Change age column data type from INT to SMALLINT
ALTER TABLE users
ALTER COLUMN age TYPE SMALLINT;

-- Add NOT NULL constraint to city column
ALTER TABLE users
ALTER COLUMN city SET NOT NULL;

-- Add CHECK constraint to age column (age must be 18 or above)
ALTER TABLE users
ADD CONSTRAINT age CHECK (age >= 18);

-- Insert new user Vinod
INSERT INTO users (full_name, email, age, city)
VALUES ('Vinod', 'vinod@gmail.com', 25, 'Mumbai');

-- Rename table users to customers
ALTER TABLE users
RENAME TO customers;

-- View final result
SELECT * FROM customers ORDER BY user_id ASC;

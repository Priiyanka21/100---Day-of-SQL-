-- Day 20: CASE Function - Price Categorization

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    quantity INT,
    added_date DATE,
    discount_rate NUMERIC
);

INSERT INTO products (product_name, category, price, quantity, added_date, discount_rate) VALUES
('Laptop', 'Electronics', 75000, 4, '01-03-2026', 5.00),
('Smartphone', 'Electronics', 45000, 25, '04-03-2025', 8.00),
('Keyboard', 'Electronics', 55000, 20, '01-05-2026', 5.00),
('Desk', 'Furniture', 95000, 22, '11-03-2026', 6.00),
('Mouse', 'Electronics', 35000, 30, '01-03-2026', 7.00),
('Tablet', 'Electronics', 75000, 4, '01-03-2026', 5.00),
('Printer', 'Electronics', 75000, 4, '01-03-2026', 3.00),
('Monitor',

-- Day 60: Find customers with longest consecutive daily purchase streaks

-- Sample Schema
CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    customer_id INT,
    purchase_date DATE
);

INSERT INTO purchases (customer_id, purchase_date) VALUES
(1, '2024-01-01'), (1, '2024-01-02'), (1, '2024-01-03'),
(1, '2024-01-05'), (1, '2024-01-06'),
(2, '2024-01-01'), (2, '2024-01-02'),
(3, '2024-01-01'), (3, '2024-01-03'), (3, '2024-01-04'), (3, '2024-01-05');

-- Question: Find each customer's longest consecutive-day purchase streak,
-- along with streak start and end dates.

WITH ranked_purchases AS (
    SELECT 
        customer_id,
        purchase_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY purchase_date) AS rn
    FROM (SELECT DISTINCT customer_id, purchase_date FROM purchases) t
),
grouped AS (
    SELECT 
        customer_id,
        purchase_date,
        purchase_date - (rn * INTERVAL '1 day') AS grp_key
    FROM ranked_purchases
),
streaks AS (
    SELECT 
        customer_id,
        grp_key,
        MIN(purchase_date) AS streak_start,
        MAX(purchase_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY customer_id, grp_key
),
ranked_streaks AS (
    SELECT *,
        RANK() OVER (PARTITION BY customer_id ORDER BY streak_length DESC) AS streak_rank
    FROM streaks
)
SELECT customer_id, streak_start, streak_end, streak_length
FROM ranked_streaks
WHERE streak_rank = 1
ORDER BY customer_id;

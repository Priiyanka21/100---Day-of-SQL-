-- ============================================
-- #100DaysOfSQL — Day 59 (Extended Batch)
-- Topic: Streaks, Consecutive Patterns & Window Functions
-- ============================================

-- Q1: Customer purchase streak of 3+ consecutive days (island-gap logic)
WITH ranked_orders AS (
    SELECT customer_id, order_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM orders
),
grouped_orders AS (
    SELECT customer_id, order_date,
           order_date - (rn * INTERVAL '1 day') AS streak_group
    FROM ranked_orders
),
streaks AS (
    SELECT customer_id, streak_group,
           COUNT(*) AS streak_length,
           MIN(order_date) AS streak_start,
           MAX(order_date) AS streak_end
    FROM grouped_orders
    GROUP BY customer_id, streak_group
)
SELECT customer_id, streak_start, streak_end, streak_length
FROM streaks
WHERE streak_length >= 3
ORDER BY customer_id, streak_start;


-- Q2: Longest login streak per user (max consecutive days)
WITH ranked_logins AS (
    SELECT user_id, login_date,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) AS rn
    FROM logins
),
grouped_logins AS (
    SELECT user_id, login_date,
           login_date - (rn * INTERVAL '1 day') AS streak_group
    FROM ranked_logins
)
SELECT user_id, COUNT(*) AS longest_streak
FROM grouped_logins
GROUP BY user_id, streak_group
ORDER BY longest_streak DESC
LIMIT 1;


-- Q3: Find employees with 5+ consecutive days of attendance
WITH ranked_att AS (
    SELECT employee_id, attendance_date,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY attendance_date) AS rn
    FROM attendance
    WHERE status = 'Present'
),
grouped_att AS (
    SELECT employee_id, attendance_date,
           attendance_date - (rn * INTERVAL '1 day') AS streak_group
    FROM ranked_att
)
SELECT employee_id, MIN(attendance_date) AS streak_start,
       MAX(attendance_date) AS streak_end, COUNT(*) AS days_present
FROM grouped_att
GROUP BY employee_id, streak_group
HAVING COUNT(*) >= 5
ORDER BY employee_id;


-- Q4: Detect consecutive price increase streaks for a stock
WITH price_change AS (
    SELECT stock_symbol, trade_date, close_price,
           LAG(close_price) OVER (PARTITION BY stock_symbol ORDER BY trade_date) AS prev_price
    FROM stock_prices
),
flagged AS (
    SELECT *,
           CASE WHEN close_price > prev_price THEN 1 ELSE 0 END AS is_increase
    FROM price_change
),
grouped AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY stock_symbol ORDER BY trade_date) -
           SUM(is_increase) OVER (PARTITION BY stock_symbol ORDER BY trade_date) AS grp
    FROM flagged
)
SELECT stock_symbol, MIN(trade_date) AS streak_start, MAX(trade_date) AS streak_end,
       COUNT(*) AS increase_streak_days
FROM grouped
WHERE is_increase = 1
GROUP BY stock_symbol, grp
HAVING COUNT(*) >= 3
ORDER BY stock_symbol, streak_start;


-- Q5: Find months where a customer ordered every single month (no gap) in a year
WITH months_ordered AS (
    SELECT customer_id, DATE_TRUNC('month', order_date) AS order_month
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 2024
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
)
SELECT customer_id, COUNT(*) AS active_months
FROM months_ordered
GROUP BY customer_id
HAVING COUNT(*) = 12;

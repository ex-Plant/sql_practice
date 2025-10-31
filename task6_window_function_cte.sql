/* 💥Task💥
Running Revenue with Window Functions
You’re helping the analytics team understand sales trends. They want a daily report that shows each qualifying day’s revenue, the running total across those days, and how much revenue changed from the previous qualifying day.

Write a query that returns the following columns in this exact order:

sale_date — the date of the sales day
daily_revenue — the total revenue for that day
running_total — a running total of daily_revenue across the result, ordered by sale_date
day_over_day_change — the difference between the current day’s daily_revenue and the previous qualifying day’s daily_revenue
Requirements:

Use a Common Table Expression (CTE) to first aggregate orders by day.
Only include days that have at least 2 orders and a daily_revenue of at least 100. Use GROUP BY with HAVING in the CTE to filter days.
Compute the running total with a window function like SUM(...) OVER (ORDER BY sale_date).
Compute the day-over-day change with a window function like LAG(...) OVER (ORDER BY sale_date) and subtract it from daily_revenue. The first row can return NULL for the change.
Sort the final results by sale_date in ascending order.
Tip:

Window functions use the OVER clause. For a running total across the whole result, use OVER (ORDER BY sale_date).*/

-- Populate tables
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    amount INTEGER NOT NULL
);

INSERT INTO orders (id, order_date, amount) VALUES (1, '2023-01-01', 50);
INSERT INTO orders (id, order_date, amount) VALUES (2, '2023-01-01', 70);
INSERT INTO orders (id, order_date, amount) VALUES (3, '2023-01-02', 30);
INSERT INTO orders (id, order_date, amount) VALUES (4, '2023-01-03', 40);
INSERT INTO orders (id, order_date, amount) VALUES (5, '2023-01-03', 40);
INSERT INTO orders (id, order_date, amount) VALUES (6, '2023-01-03', 30);
INSERT INTO orders (id, order_date, amount) VALUES (7, '2023-01-04', 80);
INSERT INTO orders (id, order_date, amount) VALUES (8, '2023-01-05', 200);
INSERT INTO orders (id, order_date, amount) VALUES (9, '2023-01-05', 50);
INSERT INTO orders (id, order_date, amount) VALUES (10, '2023-01-06', 90);
INSERT INTO orders (id, order_date, amount) VALUES (11, '2023-01-06', 15);

-- ✅ Solution

WITH daily_totals AS (
    SELECT
        order_date AS sale_date,
        count(order_date) as orders_count,
        SUM(amount) AS daily_revenue
    FROM orders
    GROUP BY order_date
    HAVING orders_count >= 2
)

SELECT
    sale_date,
    daily_revenue,
    -- THIS IS A WINDOW FUNCTION ❗
    SUM(daily_revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total,

    daily_revenue - LAG(daily_revenue) OVER (
        ORDER BY sale_date
        ) as day_over_day_change

    FROM daily_totals
    ORDER BY sale_date;

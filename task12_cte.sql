-- Q1 Category Revenue (CTE Practice)
-- Your analytics team wants a Q1 report showing which product categories brought in the most revenue, but only for categories that sold at least 2 different products during the quarter.
--
-- Use the tables defined in 001_up.sql.
--
-- Write a query that returns exactly these columns:
--
-- category — the category name
-- total_revenue — the total revenue in Q1 (sum of price * quantity)
-- products_sold_count — the number of distinct products sold in that category in Q1
-- Additional rules:
--
-- Only include orders from Q1 2023: from 2023-01-01 to 2023-03-31 (inclusive)
-- Only include categories where products_sold_count is at least 2
-- Sort by total_revenue in descending order, then by category in ascending order
-- Use at least one CTE (WITH clause)
-- Tip:
--
-- A good approach is to build a CTE of Q1 line items (joined orders, order_items, products, categories) and compute line revenues there, then aggregate in a second CTE.


CREATE TABLE categories (
                            id INTEGER PRIMARY KEY,
                            name TEXT NOT NULL
);

CREATE TABLE products (
                          id INTEGER PRIMARY KEY,
                          name TEXT NOT NULL,
                          price INTEGER NOT NULL,
                          category_id INTEGER NOT NULL
);

CREATE TABLE orders (
                        id INTEGER PRIMARY KEY,
                        created_at DATE NOT NULL
);

CREATE TABLE order_items (
                             order_id INTEGER NOT NULL,
                             product_id INTEGER NOT NULL,
                             quantity INTEGER NOT NULL
);

INSERT INTO categories (id, name) VALUES
                                      (1, 'Electronics'),
                                      (2, 'Books'),
                                      (3, 'Home'),
                                      (4, 'Toys');

INSERT INTO products (id, name, price, category_id) VALUES
                                                        (1, 'Phone', 700, 1),
                                                        (2, 'Laptop', 1200, 1),
                                                        (3, 'Headphones', 150, 1),
                                                        (4, 'Novel', 20, 2),
                                                        (5, 'Textbook', 80, 2),
                                                        (6, 'Blender', 60, 3),
                                                        (7, 'Vacuum', 150, 3),
                                                        (8, 'Puzzle', 15, 4),
                                                        (9, 'Board Game', 30, 4);

INSERT INTO orders (id, created_at) VALUES
                                        (1, '2023-01-05'),
                                        (2, '2023-01-20'),
                                        (3, '2023-02-11'),
                                        (4, '2023-03-03'),
                                        (5, '2023-03-25'),
                                        (6, '2023-04-02');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
                                                             (1, 1, 1),   -- Phone
                                                             (1, 4, 2),   -- 2x Novel
                                                             (2, 2, 1),   -- Laptop
                                                             (2, 3, 1),   -- Headphones
                                                             (2, 8, 1),   -- Puzzle
                                                             (3, 5, 3),   -- 3x Textbook
                                                             (4, 6, 2),   -- 2x Blender
                                                             (5, 9, 1),   -- Board Game
                                                             (5, 8, 2),   -- 2x Puzzle
                                                             (6, 7, 1),   -- Vacuum (Q2 - should be excluded)
                                                             (6, 2, 1);   -- Laptop (Q2 - should be excluded)


-- ✅ Solution

WITH q1_line_items AS (
    SELECT
        c.name AS category,
        p.id AS product_id,
        oi.quantity * p.price AS line_revenue
    FROM orders o
             JOIN order_items oi ON o.id = oi.order_id
             JOIN products p ON oi.product_id = p.id
             JOIN categories c ON p.category_id = c.id
    WHERE o.created_at BETWEEN '2023-01-01' AND '2023-03-31'
),
     q1_category_agg AS (
         SELECT
             category,
             SUM(line_revenue) AS total_revenue,
             COUNT(DISTINCT product_id) AS products_sold_count
         FROM q1_line_items
         GROUP BY category
     )
SELECT
    category,
    total_revenue,
    products_sold_count
FROM q1_category_agg
WHERE products_sold_count >= 2
ORDER BY total_revenue DESC, category ASC;

-- Restaurant Ratings Report (GROUP BY + HAVING)
-- You work for a food delivery app. Product wants a quick report of the best-performing restaurants in the first half of 2024.
--
-- Write a query against the provided restaurants and orders tables to return:
--
-- restaurant_name — the restaurant's name
-- total_orders — the number of orders in H1 2024
-- avg_rating — the average rating in H1 2024, rounded to 2 decimals
-- Rules:
--
-- Only include orders where created_at is between 2024-01-01 and 2024-06-30 (inclusive). Use WHERE for this row-level filter.
-- Only include restaurants with at least 3 orders AND an average rating of 4.0 or higher in that period. Use HAVING for these group-level filters.
-- Sort by avg_rating DESC, then total_orders DESC, then restaurant_name ASC.
-- Notes:
--
-- Use GROUP BY to aggregate per restaurant.
-- WHERE vs HAVING: WHERE filters individual rows before grouping; HAVING filters the grouped results after aggregation.
-- Rounding: ROUND(value, 2) rounds to 2 decimal places.

-- Create tables
CREATE TABLE restaurants (
                             id INTEGER PRIMARY KEY,
                             name TEXT NOT NULL,
                             cuisine TEXT
);

CREATE TABLE orders (
                        id INTEGER PRIMARY KEY,
                        restaurant_id INTEGER NOT NULL,
                        created_at DATE NOT NULL,
                        rating INTEGER NOT NULL
);

INSERT INTO restaurants (id, name, cuisine) VALUES
    (1, 'Pasta Palace', 'Italian'),
    (2, 'Curry Corner', 'Indian'),
    (3, 'Burger Barn', 'American'),
    (4, 'Sushi Spot', 'Japanese'),
    (5, 'Taco Town', 'Mexican');

-- Pasta Palace (H1 2024 + one 2023 order to test WHERE)
INSERT INTO orders (id, restaurant_id, created_at, rating) VALUES
     (1, 1, '2024-01-10', 5),
     (2, 1, '2024-02-10', 4),
     (3, 1, '2024-03-05', 4),
     (4, 1, '2024-04-01', 3),
     (5, 1, '2023-12-15', 1);

-- Curry Corner (qualifies strongly)
INSERT INTO orders (id, restaurant_id, created_at, rating) VALUES
    (6, 2, '2024-01-12', 5),
    (7, 2, '2024-02-14', 5),
    (8, 2, '2024-03-20', 4),
    (9, 2, '2024-05-01', 4),
    (10, 2, '2024-06-28', 5);

-- Burger Barn (not enough orders)
INSERT INTO orders (id, restaurant_id, created_at, rating) VALUES
    (11, 3, '2024-02-02', 4),
    (12, 3, '2024-06-10', 4);

-- Sushi Spot (enough orders but low average)
INSERT INTO orders (id, restaurant_id, created_at, rating) VALUES
    (13, 4, '2024-01-08', 3),
    (14, 4, '2024-03-03', 4),
    (15, 4, '2024-04-22', 3);

-- Taco Town (qualifies, with one order outside range)
INSERT INTO orders (id, restaurant_id, created_at, rating) VALUES
    (16, 5, '2024-02-15', 4),
    (17, 5, '2024-03-17', 4),
    (18, 5, '2024-06-30', 4),
    (19, 5, '2024-07-01', 5);


-- # ✅ Solution
SELECT name AS restaurant_name,
       COUNT(orders.id) AS total_orders,
       ROUND(AVG(rating), 2) as avg_rating
FROM restaurants
         JOIN orders ON orders.restaurant_id = restaurants.id
WHERE orders.created_at BETWEEN '2024-01-01 ' AND '2024-06-30'
GROUP BY name
HAVING avg_rating >= 4 AND total_orders > 2
ORDER BY avg_rating DESC, total_orders DESC, restaurant_name ASC

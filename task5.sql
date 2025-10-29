/* 💥Task💥
Popular Categories by City
A small e-commerce team wants to know which product categories are popular in each city. A category is considered "popular" in a city if at least 2 different customers from that city have placed orders in that category.

Write a query to return the following:

The city name as city
The product category
The number of unique customers who ordered in that city-category as unique_customers
The total number of orders in that city-category as total_orders
Additionally, the query should:

Only include city-category groups with at least 2 unique customers (use HAVING)
Sort the results by unique_customers in descending order, then by city ascending, then by category ascending
Notes:

You can use COUNT(DISTINCT ...) to count unique customers within each group.
Check the 001_up.sql file to see the schema and sample data.
Expected column order:

city, category, unique_customers, total_orders
*/

# Create tables
CREATE TABLE cities (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  city_id INTEGER NOT NULL
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL
);

INSERT INTO cities (id, name) VALUES
  (1, 'Springfield'),
  (2, 'Riverton'),
  (3, 'Lakeside');

INSERT INTO customers (id, name, city_id) VALUES
  (1, 'Alice', 1),
  (2, 'Bob', 1),
  (3, 'Cara', 1),
  (4, 'Dan', 2),
  (5, 'Erin', 2),
  (6, 'Frank', 2),
  (7, 'Grace', 3),
  (8, 'Hank', 3),
  (9, 'Ivy', 3),
  (10, 'John', 3);

INSERT INTO products (id, name, category) VALUES
  (1, 'Phone', 'Electronics'),
  (2, 'Laptop', 'Electronics'),
  (3, 'Novel', 'Books'),
  (4, 'Puzzle', 'Toys'),
  (5, 'Board Game', 'Toys');

-- Springfield: Electronics popular (customers 1 and 2)
INSERT INTO orders (id, customer_id, product_id) VALUES
  (1, 1, 1), -- Alice, Phone
  (2, 1, 2), -- Alice, Laptop
  (3, 2, 1); -- Bob, Phone

-- Springfield: Books (only Cara) -> should NOT appear
INSERT INTO orders (id, customer_id, product_id) VALUES
  (4, 3, 3); -- Cara, Novel

-- Riverton: Books popular (Erin and Frank, multiple orders)
INSERT INTO orders (id, customer_id, product_id) VALUES
  (5, 5, 3), -- Erin, Novel
  (6, 5, 3), -- Erin, Novel
  (7, 6, 3); -- Frank, Novel

-- Riverton: Electronics (only Dan) -> should NOT appear
INSERT INTO orders (id, customer_id, product_id) VALUES
  (8, 4, 2); -- Dan, Laptop

-- Lakeside: Toys popular (Hank, Ivy, John)
INSERT INTO orders (id, customer_id, product_id) VALUES
  (9, 8, 4),  -- Hank, Puzzle
  (10, 9, 5), -- Ivy, Board Game
  (11, 10, 4); -- John, Puzzle

-- Lakeside: Electronics (only Grace) -> should NOT appear
INSERT INTO orders (id, customer_id, product_id) VALUES
  (12, 7, 1); -- Grace, Phone


# ✅ Solution
SELECT
    cities.name as city,
    products.category,
    count(DISTINCT(customers.id)) as unique_customers,
    count(orders.id) as total_orders
FROM orders
JOIN cities on cities.id = customers.city_id
JOIN products on products.id = orders.product_id
JOIN customers on customers.id = orders.customer_id
GROUP BY city, products.category
HAVING (unique_customers >= 2)
ORDER BY unique_customers DESC, city, category

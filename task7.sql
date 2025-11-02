/*💥Task💥
Above-Average Spenders (June 2023)
An e-commerce manager wants a list of customers who spent more than the average customer in June 2023.

Write a single SELECT query that uses subqueries to return the customers whose total spend in June 2023 is above the overall average spend per customer for that month.

Return the following columns in this order:

customer_name
country_code
total_spent
Requirements:

Only include orders with created_at between 2023-06-01 and 2023-06-30 (inclusive)
Compute each customer’s total_spent as the sum of quantity * unit_price for their June orders
Only include customers whose total_spent is greater than the average total_spent across all customers who ordered in June
Sort by total_spent in descending order, then by customer_name in ascending order
Hints:

Use a subquery (or a CTE) to calculate per-customer totals for June.
Use a scalar subquery to compare each customer’s total to the overall average.
*/

-- Populate tables
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    country_code TEXT NOT NULL
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    created_at TEXT NOT NULL
);

CREATE TABLE order_items (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price INTEGER NOT NULL
);

INSERT INTO customers (id, name, country_code) VALUES
     (1, 'Alice', 'US'),
     (2, 'Bob', 'US'),
     (3, 'Carlos', 'BR'),
     (4, 'Diana', 'CA'),
     (5, 'Emi', 'JP');

INSERT INTO products (id, name, category) VALUES
    (1, 'Widget', 'Gadgets'),
    (2, 'Gizmo', 'Gadgets'),
    (3, 'Doodad', 'Accessories'),
    (4, 'Thingamajig', 'Gadgets');

INSERT INTO orders (id, customer_id, created_at) VALUES
     (1, 1, '2023-06-05'),
     (2, 1, '2023-06-20'),
     (3, 2, '2023-06-10'),
     (4, 2, '2023-05-30'),
     (5, 3, '2023-06-12'),
     (6, 3, '2023-06-28'),
     (7, 4, '2023-06-03'),
     (8, 5, '2023-06-15');

INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 2, 100),   -- Alice: 200
    (2, 1, 2, 1, 150),   -- Alice: +150 -> 350
    (3, 2, 4, 1, 200),   -- Alice: +200 -> 550 total in June
    (4, 3, 3, 1, 80),    -- Bob: 80
    (5, 3, 2, 1, 150),   -- Bob: +150 -> 230 in June
    (6, 4, 4, 2, 200),   -- Bob: May order, ignored
    (7, 5, 1, 3, 100),   -- Carlos: 300
    (8, 6, 4, 1, 200),   -- Carlos: +200
    (9, 6, 3, 1, 80),    -- Carlos: +80 -> 580 in June
    (10, 7, 3, 1, 80),   -- Diana: 80 in June
    (11, 8, 2, 2, 150);  -- Emi: 300 in June

-- ✅ Solution
WITH june_totals AS (
    SELECT
        customers.name as customer_name,
        customers.country_code,
        SUM(quantity * unit_price) AS total_spent
        FROM order_items
        JOIN orders ON orders.id = order_id
        JOIN customers ON customers.id = orders.customer_id
        WHERE orders.created_at >= '2023-06-01' AND orders.created_at <= '2023-06-30'
        GROUP BY customer_id
)


SELECT
    customer_name,
    june_totals.country_code,
    total_spent
    FROM june_totals
    WHERE total_spent > (
    SELECT AVG(total_spent) FROM june_totals
    )
    ORDER BY total_spent DESC, customer_name

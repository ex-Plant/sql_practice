/*💥Task💥
Fix Monthly Customer Tiers (CTE)
The current query tries to use a CTE to calculate monthly spending per customer, but it groups at the wrong levels, includes canceled orders, and sorts the results incorrectly.

Fix the query so that it:

Uses a CTE to compute each completed order's total for May 2023
Join orders -> order_items -> menu_items
Filter to orders.created_at in May 2023 only
Only include orders with status = 'completed'
Group by order (not by customer) to get order_total
Aggregates by customer from the CTE to return exactly these columns in this order:
customer_name
completed_orders (count of completed orders in May 2023)
total_spent (sum of order totals in May 2023)
tier using a CASE expression:
Gold when completed_orders >= 3
Silver when completed_orders = 2
Bronze when completed_orders = 1
Only includes customers with at least 1 completed order in May 2023
Sorts by total_spent DESC, then customer_name ASC
*/


CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    signup_date TEXT NOT NULL
);

CREATE TABLE menu_items (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price INTEGER NOT NULL
);

CREATE TABLE orders (
     id INTEGER PRIMARY KEY,
     customer_id INTEGER NOT NULL,
     created_at TEXT NOT NULL,
     status TEXT NOT NULL
);

CREATE TABLE order_items (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL
);

INSERT INTO customers (id, name, signup_date) VALUES
    (1, 'Alice', '2023-01-10'),
    (2, 'Bob', '2023-02-05'),
    (3, 'Chloe', '2023-03-12'),
    (4, 'Dan', '2023-04-01');

INSERT INTO menu_items (id, name, price) VALUES
  (1, 'Burger', 10),
  (2, 'Pizza', 12),
  (3, 'Salad', 8),
  (4, 'Soda', 3);

-- Orders
INSERT INTO orders (id, customer_id, created_at, status) VALUES
     (1, 1, '2023-05-03', 'completed'),
     (2, 1, '2023-05-15', 'completed'),
     (3, 1, '2023-04-20', 'completed'),
     (4, 2, '2023-05-10', 'cancelled'),
     (5, 2, '2023-05-12', 'completed'),
     (6, 3, '2023-05-07', 'completed'),
     (7, 3, '2023-05-21', 'completed'),
     (8, 3, '2023-05-25', 'completed'),
     (9, 4, '2023-06-02', 'completed');

-- Order items
INSERT INTO order_items (id, order_id, item_id, quantity) VALUES
-- Order 1 (Alice): 2 burgers (20), 1 soda (3) = 23
(1, 1, 1, 2),
(2, 1, 4, 1),
-- Order 2 (Alice): 1 pizza (12), 1 salad (8) = 20
(3, 2, 2, 1),
(4, 2, 3, 1),
-- Order 3 (Alice, April): ignore in May
(5, 3, 1, 1),
-- Order 4 (Bob, cancelled): ignore
(6, 4, 3, 3),
-- Order 5 (Bob): 1 burger (10) = 10
(7, 5, 1, 1),
-- Order 6 (Chloe): 2 pizza (24) = 24
(8, 6, 2, 2),
-- Order 7 (Chloe): 1 pizza (12), 2 sodas (6) = 18
(9, 7, 2, 1),
(10, 7, 4, 2),
-- Order 8 (Chloe): 3 burgers (30), 1 salad (8) = 38
(11, 8, 1, 3),
(12, 8, 3, 1),
-- Order 9 (Dan, June)
(13, 9, 2, 1);

-- ✅ Solution
WITH order_totals AS (
    SELECT
        o.id AS order_id,
        o.customer_id,
        SUM(oi.quantity * mi.price) AS order_total
    FROM orders o
             LEFT JOIN order_items oi ON o.id = oi.order_id
             LEFT JOIN menu_items mi ON oi.item_id = mi.id
    WHERE o.created_at LIKE '2023-05%' and o.status  = 'completed'
    GROUP BY o.id
)


SELECT
    c.name AS customer_name,
    COUNT(order_totals.order_id) AS completed_orders,
    SUM(order_totals.order_total) AS total_spent,
    CASE
        WHEN COUNT(order_totals.order_id) >= 3 THEN 'Gold'
        WHEN COUNT(order_totals.order_id) = 2 THEN 'Silver'
        ELSE 'Bronze'
        END AS tier
FROM customers c
         LEFT JOIN order_totals ON c.id = order_totals.customer_id
GROUP BY c.id
HAVING  completed_orders > 0
ORDER BY total_spent DESC, customer_name

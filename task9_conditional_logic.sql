/* 💥Task💥
Seller Fulfillment Breakdown (CASE + Aggregation)
Your marketplace ops team wants a quick view of each seller’s order status breakdown and fulfillment performance.

Write a query that returns one row per seller with a conditional breakdown using CASE expressions.

Return the following columns in this exact order:

seller — the seller's name
shipped_orders — count of orders where status is shipped
pending_orders — count of orders where status is pending
canceled_orders — count of orders where status is canceled
fulfillment_rate — the percentage of shipped orders out of all that seller’s orders, rounded to the nearest whole number
Additional requirements:

Only include sellers with at least 3 total orders
Sort by fulfillment_rate in descending order, then by seller in ascending order
Hints:

Use CASE WHEN ... THEN ... ELSE ... END inside SUM() to do conditional counts.
Use COUNT(*) for total orders per seller.
To compute a percentage, multiply by 100.0 to avoid integer division, then ROUND(...) to get a whole number
 */

-- CREATE TABLES
CREATE TABLE sellers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  seller_id INTEGER NOT NULL,
  status TEXT NOT NULL, -- 'shipped', 'pending', or 'canceled'
  amount INTEGER NOT NULL
);

INSERT INTO sellers (id, name, city) VALUES
  (1, 'Alpha Gadgets', 'Austin'),
  (2, 'Beta Books', 'Boston'),
  (3, 'Gamma Gear', 'Denver'),
  (4, 'Delta Decor', 'Austin'),
  (5, 'Epsilon Eats', 'Seattle');

INSERT INTO orders (id, seller_id, status, amount) VALUES
  -- Alpha Gadgets: 3 shipped, 1 pending, 1 canceled (5 total)
  (1, 1, 'shipped', 120),
  (2, 1, 'shipped', 80),
  (3, 1, 'pending', 50),
  (4, 1, 'canceled', 60),
  (5, 1, 'shipped', 140),

  -- Beta Books: 1 shipped, 1 pending, 2 canceled (4 total)
  (6, 2, 'pending', 30),
  (7, 2, 'canceled', 40),
  (8, 2, 'canceled', 25),
  (9, 2, 'shipped', 70),

  -- Gamma Gear: 2 shipped, 1 pending (3 total)
  (10, 3, 'shipped', 200),
  (11, 3, 'pending', 90),
  (12, 3, 'shipped', 150),

  -- Delta Decor: 1 shipped, 1 canceled (2 total) -> should be excluded by HAVING
  (13, 4, 'shipped', 60),
  (14, 4, 'canceled', 40),

  -- Epsilon Eats: 3 shipped (3 total)
  (15, 5, 'shipped', 45),
  (16, 5, 'shipped', 55),
  (17, 5, 'shipped', 65);

-- ✅ My solution
SELECT seller, shipped_orders, pending_orders, canceled_orders,
    -- (shipped + pending + canceled) as total,
    ROUND((shipped_orders * 100.0 / (shipped_orders + pending_orders + canceled_orders)))  as fulfillment_rate
FROM(
SELECT
  name AS seller,
  SUM(CASE WHEN orders.status = 'shipped' THEN 1 ELSE 0 END) AS shipped_orders,
  SUM(CASE WHEN orders.status = 'pending' THEN 1 ELSE 0 END) AS pending_orders,
  SUM(CASE WHEN orders.status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders
  FROM sellers s
  JOIN orders ON orders.seller_id = s.id
  GROUP BY seller
)
  WHERE  shipped_orders + pending_orders + canceled_orders > 2
  ORDER BY fulfillment_rate DESC, seller

-- ✅ Solution from bootcamp
SELECT
  s.name AS seller,
  SUM(CASE WHEN o.status = 'shipped' THEN 1 ELSE 0 END) AS shipped_orders,
  SUM(CASE WHEN o.status = 'pending' THEN 1 ELSE 0 END) AS pending_orders,
  SUM(CASE WHEN o.status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders,
  ROUND(100.0 * SUM(CASE WHEN o.status = 'shipped' THEN 1 ELSE 0 END) / COUNT(*)) AS fulfillment_rate
FROM sellers AS s
JOIN orders AS o ON o.seller_id = s.id
GROUP BY s.name
HAVING COUNT(*) >= 3
ORDER BY fulfil

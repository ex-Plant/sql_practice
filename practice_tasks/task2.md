# TASK
    Write a single SQL query that returns the following columns in this exact order:
    
    customer_name
    order_count — the number of completed orders in 2023
    unique_categories — the number of unique product categories purchased in 2023
    total_spent — the total amount spent in 2023 (sum of quantity * unit_price)
    Requirements:
    
    Only include orders with status = 'completed'
    Only include orders with order_date in the year 2023 ('2023-01-01' to '2023-12-31')
    Group by customer
    Use HAVING to keep only customers who meet all of these thresholds:
    order_count >= 2
    unique_categories >= 2 (hint: use COUNT(DISTINCT products.category))
    total_spent >= 200
    Sort the results by total_spent in descending order, then by customer_name ascending
    Notes:
    
    You can compute total_spent as SUM(order_items.quantity * products.unit_price).
    If you prefer, you may use a subquery to pre-filter 2023 completed orders, but it’s not required.


# JOINS ARE CREATING DUPLICATED DATA!
🔑 Mental model:
👉 Without DISTINCT: “How many rows did the joins create?”
👉 With DISTINCT: “How many unique order IDs survived the joins?”

```SQL
      SELECT
         customers.name as customer_name,
         COUNT(DISTINCT(orders.id)) as order_count,
         COUNT(DISTINCT(products.category)) as unique_categories,
         sum(products.unit_price * order_items.quantity) as total_spent
         FROM customers
       
       
         JOIN orders ON customers.id = orders.customer_id
         JOIN order_items ON orders.id = order_items.order_id
         JOIN products ON order_items.product_id = products.id
       
       
         WHERE orders.order_date LIKE '2023-__-%' AND orders.status = 'completed'  
         GROUP BY customers.name
       
       
         HAVING order_count >=2 AND unique_categories >=2 AND total_spent >=200
         ORDER BY total_spent DESC, customer_name asc
```





# SETUP
```SQL
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  unit_price INTEGER NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  order_date DATE NOT NULL,
  status TEXT NOT NULL
);

CREATE TABLE order_items (
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL
);

INSERT INTO customers (id, name) VALUES
  (1, 'Alice'),
  (2, 'Bob'),
  (3, 'Charlie'),
  (4, 'Diana'),
  (5, 'Evan'),
  (6, 'Fiona'),
  (7, 'Greg');

INSERT INTO products (id, name, category, unit_price) VALUES
  (1, 'Laptop', 'Electronics', 1000),
  (2, 'Mouse', 'Electronics', 20),
  (3, 'Coffee', 'Food', 10),
  (4, 'Book', 'Books', 15),
  (5, 'Headphones', 'Electronics', 50),
  (6, 'Blender', 'Home', 40);

INSERT INTO orders (id, customer_id, order_date, status) VALUES
  (1, 1, '2023-02-10', 'completed'),
  (2, 1, '2023-03-05', 'completed'),
  (3, 2, '2023-01-15', 'completed'),
  (4, 2, '2023-06-10', 'cancelled'),
  (5, 3, '2023-07-20', 'completed'),
  (6, 3, '2023-08-02', 'completed'),
  (7, 4, '2022-12-30', 'completed'),
  (8, 4, '2023-11-11', 'completed'),
  (9, 5, '2023-03-03', 'completed'),
  (10, 5, '2023-04-04', 'completed'),
  (11, 6, '2023-05-05', 'completed'),
  (12, 7, '2023-09-09', 'completed'),
  (13, 7, '2023-10-10', 'completed');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
  -- Alice (id=1): orders 1,2
  (1, 1, 1),  -- Laptop x1 = 1000
  (1, 2, 1),  -- Mouse x1 = 20
  (2, 4, 2),  -- Book x2 = 30
  (2, 3, 5),  -- Coffee x5 = 50

  -- Bob (id=2): orders 3,4 (4 is cancelled)
  (3, 3, 3),  -- Coffee x3 = 30
  (3, 4, 1),  -- Book x1 = 15
  (4, 5, 2),  -- Headphones x2 = 100 (cancelled order)

  -- Charlie (id=3): orders 5,6
  (5, 6, 2),  -- Blender x2 = 80
  (6, 5, 3),  -- Headphones x3 = 150

  -- Diana (id=4): orders 7,8 (7 is 2022)
  (7, 1, 1),  -- Laptop x1 = 1000 (2022)
  (8, 2, 2),  -- Mouse x2 = 40

  -- Evan (id=5): orders 9,10
  (9, 3, 10), -- Coffee x10 = 100
  (10, 4, 2), -- Book x2 = 30

  -- Fiona (id=6): order 11
  (11, 1, 1), -- Laptop x1 = 1000

  -- Greg (id=7): orders 12,13
  (12, 5, 1), -- Headphones x1 = 50
  (13, 2, 1)  -- Mouse x1 = 20
;
```

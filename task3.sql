/*
💥Task💥
Active Product Orders (LEFT JOIN)
You manage a small office-supplies store. Management wants a report of all active products and how many orders each has received. Even products with zero orders should appear, so they can decide what to promote.

Write a query to return:

The product name as product
The total number of orders for that product as total_orders
Additional requirements:

Include products even if they have zero orders (hint: use a LEFT JOIN from products to orders)
Only include products where is_active = 1
Group by product
Sort by total_orders descending, then by product ascending
Expected columns and order:

product
total_orders
Example behavior:

If a product has no matching rows in orders, it should still appear with total_orders = 0.
Tip:

COUNT(column) ignores NULLs. After a LEFT JOIN, non-matching rows have NULLs on the right side, which makes COUNT(orders.id) return 0 for those products.
*/

-- # CREATE TABLES
    CREATE TABLE products (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      is_active INTEGER NOT NULL
    );

    CREATE TABLE orders (
      id INTEGER PRIMARY KEY,
      product_id INTEGER NOT NULL,
      created_at DATE NOT NULL
    );

    INSERT INTO products (id, name, is_active) VALUES (1, 'Notebook', 1);
    INSERT INTO products (id, name, is_active) VALUES (2, 'Pen', 1);
    INSERT INTO products (id, name, is_active) VALUES (3, 'Backpack', 1);
    INSERT INTO products (id, name, is_active) VALUES (4, 'Stapler', 0);
    INSERT INTO products (id, name, is_active) VALUES (5, 'Marker', 1);
    INSERT INTO products (id, name, is_active) VALUES (6, 'Eraser', 1);

    INSERT INTO orders (id, product_id, created_at) VALUES (1, 1, '2024-01-10');
    INSERT INTO orders (id, product_id, created_at) VALUES (2, 1, '2024-01-12');
    INSERT INTO orders (id, product_id, created_at) VALUES (3, 2, '2024-02-01');
    INSERT INTO orders (id, product_id, created_at) VALUES (4, 3, '2024-02-05');
    INSERT INTO orders (id, product_id, created_at) VALUES (5, 3, '2024-02-20');
    INSERT INTO orders (id, product_id, created_at) VALUES (6, 3, '2024-03-01');
    INSERT INTO orders (id, product_id, created_at) VALUES (7, 5, '2024-03-15');

-- ✅ Solution
SELECT
     name as product,
     count(orders.id) as total_orders
     FROM products
left join orders
on products.id = product_id
WHERE is_active = 1
group by products.name
order by total_orders desc, product asc

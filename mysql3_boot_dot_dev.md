Resources:
https://www.freecodecamp.org/news/a-beginners-guide-to-sql/
https://www.youtube.com/watch?v=KBDSJU3cGkc&t=3054s

https://www.boot.dev

### INTRO
- *Structured Query Language*, or SQL, is the primary programming language used to manage and interact with relational 
databases. SQL can perform various operations such as creating, updating, reading, and deleting records within a database.
- Database: An organized collection of data, stored electronically in a structured format for efficient retrieval and manipulation.
- Although many different databases use the SQL language, most of them will have their own dialect
- a NoSQL database is a database that does not use SQL (Structured Query Language). Each NoSQL typically has its own way of writing and executing queries
- NoSQL databases are usually non-relational, SQL databases are usually relational
- SQL databases usually have a defined schema, NoSQL databases usually have dynamic schema.
- SQL databases are table-based, NoSQL databases have a variety of different storage methods, such as document, 
  key-value, graph, wide-column, and more.
- Examples: non-relational examples: MongoDB, Cassandra

# Types of NoSQL databases
- Document Database 
- Key-Value Store
- Wide-Column
- Graph


# SQL Databases right now are:
- PostgreSQL
- MySQL
- Microsoft SQL Server
- SQLite

*Postgres* is a very powerful, open-source, production-ready SQL database. *SQLite* is a lightweight, embeddable, 
open-source database. SQLite is a serverless database management system (DBMS) that has the ability to run within applications, whereas PostgreSQL uses a Client-Server model and requires a server to be installed and listening on a network, similar to an HTTP server.

### SQLITE has a loose type system - you can actually insert a integer into a TEXT column and it will work ❗


### ALTERING TABLES

# *RENAME*
```sql
ALTER TABLE employees
RENAME TO staff;

ALTER TABLE staff
RENAME COLUMN salary TO invoice;
```

# *DROP ADD*
```sql
ALTER TABLE contractors
DROP COLUMN invoice;

ALTER TABLE contractors
ADD COLUMN invoice INT;
```

### MIGRATIONS
Change of a structure of a db is called a migration.
Migration is a set of changes made to the db like changing the name, dropping, adding column etc.
Good migrations are done in small steps and are ideally reversible. We have to be extra careful with migrations.
We can easily break things. If we alter table name, and our backend was already getting data from that table, it 
will break.

# UP migrations
- moves schema forward

# DOWN migrations
- roles the changes back to the previous state
- Down migrations allow us to:

Undo changes introduced by an up migration
Quickly recover from bugs or compatibility issues in production
Keep our schema consistent across environments (local, staging, production)


**UP MIGRATION**

```sql
    ALTER TABLE projects RENAME TO tasks;
    ALTER TABLE tasks RENAME COLUMN project_id TO task_id;
```

**DOWN MIGRATION**
```sql
  ALTER TABLE tasks RENAME COLUMN task_id TO project_id;
  ALTER TABLE tasks RENAME TO projects;
```

Real World Migration Tools
In real-world projects, we don't run raw SQL migrations. We use tools that help:
- Track which migration have been applied.
- Organize migrations in files.
- Apply and roll back safely.

We can use for example Prisma Migrate when using PRISMA Orm


# Most Common Data Types

- INT
- DECIMAL (10, 4) — two digits number followed by 4 decimal places
- VARCHAR(255) — string of max 255 characters
- BLOB — binary large object
- DATE
- TIMESTAMP

### DATA TYPES
IN SQLITE there are 5 data types:
- NULL
- INTEGER
- REAL (FLOAT)
- TEXT
- BLOB
- BOOLEAN - Boolean values are written in SQLite queries as true or false, but are recorded as 1 or 0.

```sql
    CREATE TABLE users(
    id INTEGER PRIMARY KEY
    NAME TEXT
    IS_ADMIN INTEGER
    SALARY REAL
    )
```

### CONSTRAINTS
 - UNIQUE
 - NOT NULL
 - PRIMARY KEY

In other dialects of SQL you can ADD CONSTRAINT within an ALTER TABLE statement. SQLite does not support this feature, so when we create our tables we need to make sure we specify all the constraints we want.

# PRIMARY KEY
 - a key is used to define and protect relationships between tables. 
 - primary key is a unique identifier for a record within the table
 - ensures data integrity by preventing duplicate records.

# FOREIGN KEYS 
 - is used to add a link between two tables, references an id from another table to create a relationship

# Composite key
- A combination of two or more columns that uniquely identify a row.
- Used when a single column is insufficient to uniquely identify a record.

# NATURAL KEY
-  Based on inherent data attributes (e.g., social security number, email etc.)
- has a real world meaning
- is subject to change

# SURROGATE KEY 
- no real world meaning like artificially generated uuid

# Candidate key 
- A set of columns that could serve as a primary key.
- Only one candidate key is chosen as the primary key. 

# Self-referencing relationship (within one table)
- A column can reference the primary key of the same table. This models hierarchies or relationships like "user has a manager" or "category has a parent category".
- Implemented using a foreign key that points to the table's own primary key.

Example (MySQL):

```sql
CREATE TABLE employees (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  manager_id INT NULL,
  CONSTRAINT fk_employees_manager
    FOREIGN KEY (manager_id) REFERENCES employees(id)
);
```

Querying with a self-join:

```sql
-- List employees with their manager names
SELECT e.id AS employee_id,
       e.name AS employee_name,
       m.name AS manager_name
FROM employees AS e
LEFT JOIN employees AS m
  ON e.manager_id = m.id;
```


### SCHEMA
- schema is used to describe how data is organized within a db
- it consists of table names, field names, constraints, relationships etc.


***CRUD***

### CRUD VS HTTP METHODS
- create -> POST
- read - GET
- update -> PUT
- delete -> DELETE

### HTTP CRUD DATABASE LIFECYCLE
***CREATE***
 - front end sends request to the server with some data collected via a form etc using an HTTP method like POST
 - backend receives the request and makes a query to the db using INSERT statement to create a new record
 - once the server has processed that db query was successful it responds to the front end with a status code

```sql
  INSERT INTO users values(1, 'David', 34, 'US', 'DavidDev', 'insertPractice', 0);
  INSERT INTO users values(2, 'Samantha', 29, 'BR', 'Sammy93', 'addingRecords!', 0);
```

***READ***
First, the front-end webpage loads.
The front-end sends an HTTP GET request to a /users endpoint on the back-end server.
The server receives the request.
The server uses a SELECT statement to retrieve the user's record from the users table in the database.
The server converts the row of SQL data into a JSON object and sends it back to the front-end.

### WHERE + IS NULL / IS NOT NULL
```sql
    SELECT * FROM users
    WHERE user_id IS NOT NULL;
```

***DELETE***
```sql
    DELETE FROM users
    WHERE user_id = 1;
```

Remember to ALWAYS include a WHERE clause when deleting data from the dB. otherwise YOU WILL DELETE ALL DATA FROM
YOUR DB.
You also do not want to delete data base on the name, or any other non-unique field, as you can accidentally remove
more fields than intended. Probably the best strategy is to simply use primary key.

Deleting data is a very dangerous operations, often impossible or very hard to revert.
Some of the common strategies to get back removed data:

- ***BACKUPS***
  `YOU SHOULD ALWAYS HAVE A BACKUP STRATEGY IN PLACE ❗❗❗`

  Always turn on automated backups if they are supported by db 
  provider. For example daily backup that can be restored up to one month.
  For most small companies hourly snapshots or daily backups are enough. 
- You have to remember though that backups are not a silver bullet.  You can return to a previous state but the data 
  might be corrupted - things might have happened with the data that is impossible to roll back. 

- ***SOFT DELETES***
It is a strategy when you do not actually delete data from your db, only mark it as deleted for example by adding a 
  field is_deleted or deleted_at.
It is used only in projects that have a very strict data retention policy.


***UPDATE***
```sql
    UPDATE users
    SET name = 'John Doe'
    WHERE name IS NULL;
```

### ORM Object-Relational Mapping
- ***ORM*** is a tool that allows performing CRUD operations using a traditional programming language, usually in a 
  form of a library or framework. The main benefit of ORMs is that it maps your db records to objects. 
- It lets you interact with a db much easier.

PROS AND CONS:
- with ORM you have *more simplicity* but *less control* than using raw SQL statements


### RELATIONAL DATABASES
- data represented in tables with *columns* or *fields* that holds attributes of the record
- each row or entry is called a *record*
- typically each record has a unique identifier called *primary key*


### NON RELATIONAL DATABASES
- main difference - they nest data instead of keeping records in separate tables
- This often results in duplicate data within the database. That's obviously less than ideal, but it does have some 
  benefits.


TWO TYPICAL STRATEGIES USED WITH PRIMARY KEYS
## AUTOINCREMENT
- used typically on the id field to automatically generate next id value when inserting data
-  in SQLite any column that has the INTEGER PRIMARY KEY constraint will auto increment

## UUID 
- used typically on the id field to automatically generate a unique identifier for each record


## COUNT
Count is an operation from within AGGREGATIONS category
- Use a COUNT(*) statement to retrieve the number of records in the users table.
```sql 
  SELECT COUNT(*) FROM employees;
```

## WHERE
 - used to query db with some more specific tasks

```sql
  select * from transactions;
  select * from transactions 
  where sender_id IS NOT NULL;
```

# DELETE
```sql
  DELETE FROM employees
  WHERE id = 251;
```

### **AS CLAUSE** IN SQL
- alias
```sql
  SELECT transactions.note AS birthday_message, transactions.amount from transactions
  WHERE sender_id = 10
```

### SQL **FUNCTIONS**

## IIF

```sql
  IIF(carA > carB, 'carA is faster', 'carB is faster')
```

```sql
  SELECT quantity,
  IIF(quantity < 10, 'Order More', 'In Stock') AS directive
  FROM inventory;
```

# TASK: Return all the data from the transactions table, and add an extra column at the end called audit.
# If a row's was_successful field is true, the audit field should say "No action required".
# If a row's was_successful field is false, the audit field should say "Perform an audit".

```SQL 
  SELECT *,
  IIF(was_successful, 'No action required', 'Perform an audit' ) AS audit 
  from transactions;
```

## BETWEEN
```SQL
  SELECT employee_name, salary
  FROM employees
  WHERE salary BETWEEN 3000 and 10000
```

```SQL
  SELECT product_name, quantity
  FROM products
  WHERE quantity NOT BETWEEN 20 AND 100;
```

```SQL
  SELECT users.name, users.age FROM users
  WHERE users.age BETWEEN 18 AND 30;
```

## DISTINCT
- retrieve data from the db without duplicates
- returns one row for each unique previous_company value

```sql
    SELECT DISTINC previous_company FROM employees;
```

### LOGICAL OPERATORS

# AND

```SQL
  SELECT product_name, quantity, shipment_status
  FROM products
  WHERE shipment_status = 'pending'
  AND quantity BETWEEN 0 and 10;
```
`ℹ️ in SQL there is no double  == or tripple ===, equal sign is always a comparison operator, we are not using it as 
assignment 
operator like in js, so we don't need to differentiate between them`

=
<
>
<=
>=
<> or !=

```sql
  SELECT * from users
  WHERE country_code = 'CA' and age < 18
```

# OR
```SQL
  SELECT product_name, quantity, shipment_status
    FROM products
    WHERE shipment_status = 'out of stock'
    OR quantity BETWEEN 10 and 100;
```

`You can group logical operators with parentheses to control the order of operations`

```sql
 (this AND that) OR the_other
```

```sql
  SELECT COUNT(*) AS junior_count FROM users
  WHERE (country_code = 'US' OR country_code = 'CA')
  AND age < 18;
```

# IN
*IN* operator returns true or false if the first operand matches any of the values in the second operand. The *IN* 
operator is a shortcut for multiple *OR* conditions.

This is the same
```sql
  SELECT product_name, shipment_status
      FROM products
      WHERE shipment_status IN ('shipped', 'preparing', 'out of stock');
```

# AS
```sql
  SELECT product_name, shipment_status
    FROM products
    WHERE shipment_status = 'shipped'
    OR shipment_status = 'preparing'
    OR shipment_status = 'out of stock';
```

```SQL
  SELECT users.name, users.age, users.country_code FROM users
    WHERE country_code IN ('US', 'CA', 'MX');
```


# LIKE 
- ends with banana 
```SQL
  SELECT * FROM products
    WHERE product_name LIKE 'banana%';
```

- starts with banana
```SQL
  SELECT * FROM products
    WHERE product_name LIKE '%banana';
```

- contains banana
```SQL
  SELECT * FROM products
    WHERE product_name LIKE '%banana%';
```

 - single character
```sql
  SELECT * FROM products
    WHERE product_name LIKE '_oot';
```

```SQL
  SELECT * FROM users
    WHERE users.name LIKE 'AL___'
```


# TASK
All users over the age of 55 will qualify for a senior discount
Users from Canada (country_code 'CA') qualify for a Canada Day discount.
Write a query that returns every user from the users table, including all columns, along with an additional column called discount_eligible.
The discount_eligible column should have a boolean value of true or false depending on whether the user matches any discount conditions listed above.

```SQL
   SELECT *,
   IIF(age > 55 OR country_code = 'CA', 1, 0)  as discount_eligible
   FROM users
```

# LIMIT

```SQL
  SELECT * FROM products
    WHERE product_name LIKE '%berry%'
    LIMIT 50;
```

# ORDER BY
```SQL
  SELECT name, price, quantity FROM products
    ORDER BY quantity DESC;
```

```SQL
  SELECT * FROM transactions
    where amount BETWEEN 10 AND 80
    ORDER BY AMOUNT DESC;
```

❗❗ `When using both ORDER BY and LIMIT, the ORDER BY clause must come first.` 

```SQL
  SELECT * FROM transactions
    WHERE amount BETWEEN 10 AND 80
    ORDER BY amount DESC
    LIMIT 4;
```

# Task
Write a query that returns the name and username for every user with a password equal to backendDev, welovebootdev, or SQLrocks. Order the records so that the names are in alphabetical order.

```sql
  SELECT name, username FROM users
    WHERE password in ('backendDev', 'welovebootdev', 'SQLrocks')
    ORDER BY name ASC
```

### AGGREGATIONS
- Aggregation is a single value that is derived by combining multiple values
- Data stored in a database should generally be stored raw. When we need to calculate some additional data from the raw data, we can use an aggregation.
- This query returns the number of products that have a quantity of 0. We could store a count of the products in a separate database table, and increment/decrement it whenever we make changes to the products table - but that would be redundant.
- It's much simpler to store the products in a single place (we call this a single source of truth) and run an aggregation when we need to derive additional information from the raw data.

```sql
  SELECT COUNT(*)
    FROM products
    WHERE quantity = 0;
```

```sql
    Select count(*) as successful_transactions from transactions
      WHERE user_id = 6 AND was_successful
```


### SUM
```SQL
  SELECT SUM(salary)
    FROM employees;
```

### MAX
```SQL
  SELECT MAX(salary)
    FROM employees;
```

# TASK
Use a MAX aggregation to return the age of our oldest CashPal user who is also an admin. Alias the returned age column to just be named "age".

```sql
  select max(age) as age from users where is_admin;
```

### MIN

# TASK
Use a MIN aggregation to find only the age of our youngest CashPal user in the United States in the users table. The country_code of the United States is US. Alias the returned age column to just be named "age".

```SQL
    select MIN(age) as age from users where country_code = 'US';
```

### GROUP BY
SQL offers the GROUP BY clause which can group rows that have similar values into "summary" rows. It returns one row for each group. The interesting part is that each group can have an aggregate function applied to it that operates only on the grouped data.

```sql
  SELECT album_id, count(song_id)
    FROM songs
    GROUP BY album_id;
```

# task
Let's get the balance of every user in the transactions table, all in a single query! Use a combination of the sum aggregation and the GROUP BY clause to return a single row for each user with transactions.

```sql
  SELECT user_id, SUM(amount) AS balance
    FROM transactions
    WHERE was_successful = true
    GROUP BY user_id;
```

### AVG
SQL offers us the AVG() function. Similar to MAX(), AVG() calculates the average of all non-NULL values.

```SQL
  select avg(age) from users
    where country_code = 'US';
```

### HAVING
The HAVING clause is similar to the WHERE clause, but it operates on groups after they've been grouped, rather than rows before they've been grouped.
First we select something and than we want to limit this selection by another condition.

```SQL
  SELECT album_id, count(id) as count
    FROM songs
    GROUP BY album_id
    HAVING count > 5;
```

# TASK
Your query should:

Return a sender_id (the person spending money) and a balance.
The balance is the SUM() of all amounts.
Don't return any rows that have a NULL sender_id.
Only return transactions that were successful.
The note must contain the word lunch to be a part of the aggregation.
Group by sender_id.
The aggregated balance must be greater than 20.
Order the results by the balance in ascending order.

``` SQL
  SELECT sender_id, sum(amount) AS BALANCE FROM transactions
    WHERE sender_id IS NOT NULL and was_successful AND NOTE LIKE '%lunch%'
    Group BY SENDER_ID
    HAVING SUM(AMOUNT) > 20
    ORDER BY BALANCE ASC
```

### ROUND
SQL ROUND() function allows you to specify both the value you wish to round and the precision to which you wish to round it:
```SQL
  ROUND(value, precision)
```

If no precision is given, SQL will round the value to the nearest whole value:
```SQL
   SELECT ROUND(AVG(song_length), 1)
    FROM songs
```

```sql
  SELECT ROUND(AVG(age), 0) AS round_age
    FROM users
    WHERE country_code = 'US';
```

# task
Write an SQL statement that returns two columns, the country_code and the average age of users for records with that country_code. The marketing team has asked that we round the average to the nearest whole number and rename the column that contains the average age to average_age.

```sql
  SELECT country_code, ROUND(AVG(age), 0) as average_age
    FROM users
    GROUP BY country_code;
```


### SUBQUERIES - NESTED QUERIES
It is possible to run a query on the result set of another query 

```sql
      SELECT id, song_name, artist_id
        FROM songs
          WHERE artist_id IN (
          SELECT id
            FROM artists
            WHERE artist_name LIKE 'Rick%'
    );
```

# TASK
One of CashPal's customer service representatives needs us to pull all the transactions for a specific user. Trouble is, they only know the user's name, not their user_id.

Use a subquery to return all transaction details for the user with the name "David".

```sql
    select * from transactions 
      where user_id in (
        select id from users
          where name = 'David'
    );
```

# TASK
Using a subquery, write an SQL statement that retrieves full user records for every user who matches the sender_id in a transaction with invoice or tax mentioned anywhere in the transaction note, and who is not an admin.

```SQL
  SELECT * FROM users
    WHERE is_admin = 0 AND id IN (
      SELECT sender_id FROM transactions
        WHERE note LIKE '%invoice%' OR note LIKE '%tax%'
  );
```

### Calculations in sql
```sql
  Select * from users
    where age_in_days > (365  * 40);
```

### TABLE RELATIONSHIPS
Types of Relationships
There are 3 primary types of relationships in a relational database:

- One-to-one
- One-to-many
- Many-to-many

# One-to-one
A one-to-one relationship most often manifests as a field or set of fields on a row in a table. For example, a user will have exactly one password.
Settings fields might be another example of a one-to-one relationship. A user will have exactly one email_preference and exactly one birthday.
Usually rather than creating such a relationship you could use a single table and just add this fields to the table.

# One to many
When talking about the relationships between tables, a one-to-many relationship is probably the most commonly used relationship.
A one-to-many relationship occurs when a single record in one table is related to potentially many records in another table.
Note that the one->many relation only goes one way, a record in the second table can not be related to multiple records in the first table!

Examples of One-to-Many Relationships
A customers table and an orders table. Each customer has 0, 1, or many orders that they've placed.
A users table and a transactions table. Each user has 0, 1, or many transactions that they've taken part in.

```sql
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

    CREATE TABLE orders (
        id INTEGER PRIMARY KEY,
        amount INTEGER NOT NULL,
        customer_id INTEGER,
        CONSTRAINT fk_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
    );
```
# TASK
Instead of a single users table where each user has a single country_code, do the following:
- Remove the country_code field from the users table
- Create a new table called countries with 4 fields:
id: an integer primary key
country_code: a TEXT
name: a TEXT
user_id: an integer foreign key to the users table's id field

```SQL
    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      age INTEGER NOT NULL,
      -- country_code TEXT NOT NULL,
      username TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      is_admin BOOLEAN
    );
    
    CREATE TABLE countries(
      id INTEGER PRIMARY KEY,
      country_code TEXT,
      name TEXT,
      user_id INTEGER,
      CONSTRAINT fk_users
      FOREIGN KEY (user_id)
      REFERENCES users(id)
    );
```

# Many to many
A many-to-many relationship occurs when multiple records in one table can be related to multiple records in another table.

# Examples of many-to-many relationships
A products table and a suppliers table - Products may have 0 to many suppliers, and suppliers can supply 0 to many products.
A classes table and a students table - Students can take potentially many classes and classes can have many students enrolled.

```sql
  CREATE TABLE product_suppliers (
  product_id INTEGER,
  supplier_id INTEGER,
  UNIQUE(product_id, supplier_id)
);
```

```sql
  CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  is_admin BOOLEAN
);

CREATE TABLE countries (
  id INTEGER PRIMARY KEY,
  country_code TEXT,
  name TEXT
);

create table users_countries (
  country_id INTEGER,
  user_id INTEGER,
  UNIQUE(country_id, user_id)
);

```

# Joining tables
Joining tables helps define many-to-many relationships between data in a database. As an example, when defining the relationship above between products and suppliers, we would define a joining table called products_suppliers that contains the primary keys from the tables to be joined.

Then, when we want to see if a supplier supplies a specific product, we can look in the joining table to see if the ids share a row.

*Unique* constraints across 2 fields
When enforcing specific schema constraints we may need to enforce the UNIQUE constraint across two different fields.
This ensures that we can have multiple rows with the same product_id or supplier_id, but we can't have two rows where both the product_id and supplier_id are the same.

```sql
    CREATE TABLE product_suppliers (
      product_id INTEGER,
      supplier_id INTEGER,
      UNIQUE(product_id, supplier_id)
    );
```

# DATABASE NORMALIZATION
*Database normalization* is a method for structuring your database schema in a way that helps:

- Improve data integrity
- Reduce data redundancy

What is *data integrity*?
"Data integrity" refers to the accuracy and consistency of data. For example, if a user's age is stored in a database, rather than their birthday, that data becomes incorrect automatically with the passage of time.

It would be better to store a birthday and calculate the age as needed.

What is *data redundancy*?
"Data redundancy" occurs when the same piece of data is stored in multiple places. For example: saving the same file multiple times to different hard drives.

Data redundancy can be problematic, especially when data in one place is changed such that the data is no longer consistent across all copies of that data.


# Normal Forms
The creator of "database normalization", Edgar F. Codd, described different "normal forms" a database can adhere to. We'll talk about the most common ones.

First normal form (1NF)
Second normal form (2NF)
Third normal form (3NF)
Boyce-Codd normal form (BCNF)

In short, 1st normal form is the least "normalized" form, and Boyce-Codd is the most "normalized" form.
The more normalized a database, the better its data integrity, and the less duplicate data you'll have.

When we're talking more generally about data normalization, the term *"primary key"* means the collection of columns 
that uniquely identify a row. That can be a single column, but it can actually be any number of columns. A primary key is the minimum number of columns needed to uniquely identify a row in a table.

# 1st Normal Form (1NF)
To be compliant with first normal form, a database table simply needs to follow 2 rules:

`It must have a unique primary key`.

A cell `can't have a nested table` as its value (depending on the database you're using, this may not even be possible)
You should almost never design a table that doesn't adhere to 1NF

# 2nd Normal Form (2NF)
` All columns that are not part of the primary key are dependent on the entire primary key, and not just one of the 
columns in the primary key.`

# Example of 1st NF, but not 2nd NF
In this table, the primary key is a combination of first_name + last_name.

first_name	last_name	first_initial
Lane	Wagner	l
Lane	Small	l
Allan	Wagner	a

This table does not adhere to 2NF. The first_initial column is entirely dependent on the first_name column, rendering it redundant.

# Example of 2nd normal form
One way to convert the table above to 2NF is to add a new table that maps a first_name directly to its first_initial. This removes any duplicates:

first_name	last_name
Lane	Wagner
Lane	Small
Allan	Wagner

first_name	first_initial
Lane	l
Allan	a
2NF is usually a good idea

`You should probably default to keeping your tables in second normal form. That said, there are good reasons to 
deviate from it, particularly for performance reasons. The reason being that when you have query a second table to 
get additional data it can take a bit longer.`


# 3rd Normal Form (3NF)

`All columns that aren't part of the primary are dependent solely on the primary key.`
`In second normal form we can't have a column 
completely dependent on a part of the primary key, and in third normal form we can't have a column that is entirely 
dependent on anything that isn't the entire primary key.`

# Example of 2nd NF, but not 3rd NF
In this table, the primary key is simply the id column.

id	name	first_initial	email
1	Lane	l	lane.works@example.com
2	Breanna	b	breanna@example.com
3	Lane	l	lane.right@example.com

This table is in 2nd normal form because first_initial is not dependent on a part of the primary key. However, because it is dependent on the name column it doesn't adhere to 3rd normal form.

# Example of 3rd normal form
The way to convert the table above to 3NF is to add a new table that maps a name directly to its first_initial. Notice how similar this solution is to 2NF.

id	name	email
1	Lane	lane.works@example.com
2	Breanna	breanna@example.com
3	Lane	lane.right@example.com

name	first_initial
Lane	l
Breanna	b

`Optimize for data integrity and data de-duplication first by adhering to 3NF. If you have speed issues, 
de-normalize accordingly.`
Remember the IIF function and the AS clause.

# Boyce-Codd Normal Form (BCNF)

`A column that's part of a primary key can not be entirely dependent on a column that's not part of that primary key.`
This only comes into play when there are multiple possible primary key combinations that overlap. Another name for this is "overlapping candidate keys".

Only in rare cases does a table in third normal form not meet the requirements of Boyce-Codd normal form.

# Example of 3rd NF, but not Boyce-Codd NF
release_year	release_date	sales	name
2001	2001-01-02	100	Kiss me tender
2001	2001-02-04	200	Bloody Mary
2002	2002-04-14	100	I wanna be them
2002	2002-06-24	200	He got me
The interesting thing here is that there are 3 possible primary keys:

release_year + sales
release_date + sales
name
This means that by definition this table is in 2nd and 3rd normal form because those forms only restrict how dependent a column that is not part of a primary key can be.

This table is not in Boyce-Codd's normal form because release_year is entirely dependent on release_date.

# Example of Boyce-Codd normal form
The easiest way to fix the table in our example is to simply remove the duplicate data from release_date. Let's make that column release_day_and_month.

release_year	release_day_and_month	sales	name
2001	01-02	100	Kiss me tender
2001	02-04	200	Bloody Mary
2002	04-14	100	I wanna be them
2002	06-24	200	He got me
BCNF is usually a good idea
The same exact rule of thumb applies to the 2nd, 3rd and Boyce-Codd normal forms. That said, it's unlikely you'll see BCNF-specific issues in practice.

Optimize for data integrity and data de-duplication first by adhering to Boyce-Codd normal form. If you have speed issues, de-normalize accordingly.
Normalization Review
In my opinion, the exact definitions of 1st, 2nd, 3rd and Boyce-Codd normal forms simply are not all that important in your work as a back-end developer.

However, what is important is to understand the basic principles of data integrity and data redundancy that the normal forms teach us.
Let's go over some rules of thumb that you should commit to memory - they'll serve you well when you design databases and even just in coding interviews.

### Rules of thumb for database design
- Every table should `always have a unique identifier` (primary key)
  90% of the time, that unique identifier will be a `single column named id`
- `Avoid duplicate data`
- `Avoid storing data that is completely dependent on other data`. Instead, compute it on the fly when you need it.
- `Keep your schema as simple as you can. Optimize for a normalized database first. Only denormalize for speed's sake 
  when you start to run into performance problems.`


## JOINS
Joins are one of the most important features that SQL offers. Joins allow us to make use of the relationships we have set up between our tables. In short, joins allow us to query multiple tables at the same time.

# INNER JOIN
The simplest and most common type of join in SQL is the INNER JOIN. By default, a JOIN command is an INNER JOIN.

`An INNER JOIN returns all of the records in table_a that have matching records in table_b`

# The ON clause
In order to perform a join, we need to tell the database which fields should be "matched up". `The ON clause is used 
to specify these columns to join.`

```SQL
  SELECT *
    FROM employees
    INNER JOIN departments 
    ON employees.department_id = departments.id;
```

The query above returns all the fields from both tables. The INNER keyword doesn't have anything to do with the number of columns returned - it only affects the number of rows returned.

```SQL
  SELECT students.name, classes.name
    FROM students
    INNER JOIN classes on classes.class_id = students.class_id;
```

# LEFT JOIN
A LEFT JOIN will return every record from table_a regardless of whether or not any of those records have a match in table_b. A left join will also return any matching records from table_b.

```SQL
    select 
      users.name, 
      sum(transactions.amount) as sum, 
      count(transactions.amount) as count  
      from users
        left join transactions
        on transactions.user_id = users.id  
        group by users.id
        order by sum desc
```

# JOINING MORE THAN TWO TABLES

```SQL
    select 
      users.id,
      users.name,  
      users.age,
      users.username,
      countries.name as country_name,
      sum(transactions.amount) as balance
      from users
      join countries 
      on countries.country_code = users.country_code
      join transactions 
      on transactions.user_id = users.id
      where users.id = 6 AND transactions.was_successful
```

# USING AGGREGATED VALUE AS A CONDITION IN HAVING
```SQL
  select * from support_tickets;
  select * from users;

  select users.name, users.username, count(support_tickets.id) as support_ticket_count
    from users 
    join support_tickets on support_tickets.user_id = users.id
    where support_tickets.issue_type != 'Account Access'  
    group by users.name
    having support_ticket_count > 1
    order by support_ticket_count desc
```

# RIGHT JOIN
A RIGHT JOIN is, as you may expect, the opposite of a LEFT JOIN. It returns all records from table_b regardless of matches, and all matching records between the two tables.

SQLite Restriction
SQLite does not support right joins, but many dialects of SQL do. If you think about it, a RIGHT JOIN is just a LEFT JOIN with the order of the tables switched, so it's not a big deal that SQLite doesn't support the syntax.


# FULL JOIN
A FULL JOIN combines the result set of the LEFT JOIN and RIGHT JOIN commands. It returns all records from both from 
table_a and table_b regardless of whether or not they have matches - also not supported by SQLite.

# SQL Indexes
`An index is an in-memory structure that ensures that queries we run on a database are performant`, that is to say, 
they run quickly. If you can remember back to the data structures course, `most database indexes are just binary 
trees or B-trees`! The binary tree can be stored in RAM as well as on disk, and it makes it easy to look up the 
location of an entire row.

`PRIMARY KEY columns are indexed by default`, ensuring you can look up a row by its id very quickly. However, if you 
have other columns that you want to be able to do quick lookups on, you'll need to index them.
It's fairly common to name an index after the column it's created on with a suffix of _idx.

Like with many things, adding an index to a db is not free. It takes up space, slows down creation and updates etc. 
That is why fields are not indexed by default and you shouldn't be adding indexes like so, only when you actually 
need it.

The rule of thumb is simple:
`Add an index to columns you know you'll be doing frequent lookups on. Leave everything else un-indexed. You can 
always add indexes later.`

```SQL
CREATE INDEX index_name ON table_name (column_name);
```

```SQL
create index email_idx on users(email);
```

*Multi-column index* is sorted by the first column first, the second column next, and so forth. A lookup on only the 
first column in a multi-column index gets almost all of the performance improvements that it would get from its own 
single-column index. However, lookups on only the second or third column will have very degraded performance. 
Because of that *it is important to think about the order of columns in a multi-column index.*

```SQL
  create index user_id_recipient_id_idx 
  on 
  transactions (user_id, recipient_id);
```

# Denormalizing for Speed
We left you with a cliffhanger in the "normalization" chapter. As it turns out, *data integrity and deduplication 
come at a cost, and that cost is usually speed.*

`Joining tables together, using subqueries, performing aggregations, and running post-hoc calculations take time. At 
very large scales these advanced techniques can actually become a huge performance toll on an application - 
sometimes grinding the database server to a halt.`

*Storing duplicate information can drastically speed up an application that needs to look it up in different ways.*
For example, if you store a user's country information right on their user record, no expensive join is required to load their profile page!
That said, denormalize at your own risk! Denormalizing a database incurs a large risk of inaccurate and buggy data.
In my opinion, *it should be used as a kind of "last resort" in the name of speed.*

# SQL Injection
```SQL
INSERT INTO students(name) VALUES (?);
```

❌❌❌
```SQL
INSERT INTO students(name) VALUES ('Robert'); DROP TABLE students;--);
```

How Do We Protect Against SQL Injection?
You need to be aware of SQL injection attacks, but to be honest the solution these days is to simply use a modern SQL library that sanitizes SQL inputs. We don't often need to sanitize inputs by hand at the application level anymore.

For example, the Go standard library's SQL packages automatically protects your inputs against SQL attacks if you use it properly. In short, don't interpolate user input into raw strings yourself - make sure your database library has a way to sanitize inputs, and pass it those raw values.



# HAVING PLUS COUNT 
```SQL
  SELECT user_id FROM plays
    GROUP BY user_id
    HAVING COUNT(*) >= 2
```

# WITH
✅ WITH = Common Table Expression (CTE) = temporary “named table”  
We are creating a temporary table that we can use in our query,
We can create as many as we want 

```sql
    WITH my_numbers AS (
      SELECT 1 AS n
      UNION ALL
      SELECT 2
      UNION ALL
      SELECT 3
    )
    SELECT AVG(n) 
    FROM my_numbers;
```

```SQL
    WITH active_users AS (
    SELECT
    user_id
    FROM plays
    GROUP BY user_id
    HAVING COUNT(*) >= 2
    )
```

Then you can use this in a join
```sql
    JOIN active_users
    ON active_users.user_id = users.id
```

# substr
- get a piece of the field
  2023-01-05

```sql
 SUBSTR(ORDER_DATE, 1, 7)
```
RESULT = 2023-01-05

# When you use GROUP BY, the result is already unique per group
This will extract a month than group it by it and give back the sum

```sql
    SELECT
        substr(ORDER_DATE, 1, 7) AS month,
        sum(amount_cents) as total_revenue_cents
        FROM ORDERS
        group by month
```

# CTE
Common Table Expression is a temporary result of some select existing only for the duration of the query, defined 
using *WITH* word.
SQL first runs the query inside the WITH (...) block.
That result can then be referenced like a table in the main query (or in other CTEs that follow)
Store this intermediate result, give it a name, then build the final query using that name.

```sql
    -- THIS IS A CTE
    WITH daily_totals AS (
        SELECT 
            order_date AS sale_date,
            SUM(amount) AS daily_revenue
            FROM orders
            GROUP BY order_date
            ORDER BY order_date ASC
    )

    SELECT * FROM daily_totals
```

# Window functions + OVER 
The OVER keyword is what turns a normal aggregate or analytic expression into a window function.
OVER tells SQL “don’t collapse rows — instead, apply this calculation across a defined window of rows.”

Used to perform calculations across a set of rows that are related to the current row, without collapsing data into 
groups like GROUP BY does.


❗ GROUP BY 0 collapses mutliple rows into one
❗ WINDOW FUNCTIONS keeps all rows and adds extra calculations accross them


# We need to calculate running total 
```sql
    SELECT
      sale_date,
      daily_revenue,
      -- THIS IS A WINDOW FUNCTION ❗
      --SUM(daily_revenue) is the same aggregate as before — but since it’s inside OVER(), it doesn’t collapse rows.
      SUM(daily_revenue) OVER (
        ORDER BY sale_date
      -- defines the window frame: all rows from the start up to the current one.
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) AS running_total
    
    FROM daily_totals
    ORDER BY sale_date;
```

# ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
- from the first row to the current row
- used for running totals 

# ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
- all rows in the partition
- Used when you want a total, average, or rank over the entire set, repeated for each row.

# ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
- from the current to the end 

# ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
- you can specify exactly how many rows before and after the current one


# LAG 
- day_over_day_change — the difference between the current day’s daily_revenue and the previous qualifying day’s daily_revenue
```sql
    SELECT
      sale_date,
      daily_revenue,
      -- LAG WINDOW FUNCTION ❗
      daily_revenue - LAG(daily_revenue)
      OVER (ORDER BY sale_date) as day_over_day_change
    FROM daily_totals
    ORDER BY sale_date;
```

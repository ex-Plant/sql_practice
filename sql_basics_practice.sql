
-- ### 1) Create the `employee` table

  CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
  );

- `super_id` and `branch_id` will be foreign keys.
- We can't however make them foreign keys at this stage, as the `branch` table doesn't exist yet (and self-reference also requires the base table to exist first).

---

## 2) Create the `branch` table (referencing `employee` as manager)

Now we will create a new `branch` and create a relation with the `employee` table by setting a column `manager_id` as a foreign key related to `emp_id` column in `employee` table.

```sql
  CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id)
    REFERENCES employee(emp_id) ON DELETE SET NULL
  );

```

---

## 3) Add FK from `employee.branch_id` to `branch.branch_id`

Since we created the `branch` table now we can alter `employee` table and make `branch_id` column a foreign key.

```sql
  ALTER TABLE employee
  ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;
```

## 4) Add self-referencing FK on `employee.super_id`

Since `employee` table was created as well now we can add reference to this table. This will be a self-referencing relationship. This can also be done only AFTER we have created a table that we want to reference to even if this is the same table.

```sql
  ALTER TABLE employee
  ADD FOREIGN KEY(super_id) REFERENCES employee(emp_id) ON DELETE SET NULL;
```

Note: Using `super_id` here to match the column defined in the `employee` table above.

## 5) Create the `client` table (referencing `branch`)

Now we will create another table `client`, and add a foreign key to `branch_id`.

```sql
  CREATE TABLE client (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
  );
```

---

## 6) Create the `works_with` table (junction for employee client)

Next step is to create table `works_with`. This table will have two foreign keys and the primary key will be a composite key of two columns `emp_id` and `client_id`.

    ```sql
      CREATE TABLE works_with (
        emp_id INT,
        client_id INT,
        total_sales INT,
        PRIMARY KEY(emp_id, client_id),
        FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
        FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
      );
    ```

    ## 7) Create the `branch_supplier` table (composite key, references `branch`)
Ok, last table we will create is table `branch_supplier`. It will have a composite key and a relation to table `branch`.


```sql
  CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
  );
```

## 8) Insert data to tables
In c complex db where we have multiple tables we need to insert data in a specific order
This is due to relationships between tables

```sql
  -- Corporate
  INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

  INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

  UPDATE employee
  SET branch_id = 1
  WHERE emp_id = 100;

  INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

  -- Scranton
  INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

  INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

  UPDATE employee
  SET branch_id = 2
  WHERE emp_id = 102;

  INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
  INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
  INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

  -- Stamford
  INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

  INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

  UPDATE employee
  SET branch_id = 3
  WHERE emp_id = 106;

  INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
  INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


  -- BRANCH SUPPLIER
  INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
  INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
  INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
  INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
  INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
  INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
  INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

  -- CLIENT
  INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
  INSERT INTO client VALUES(401, 'Lackawana Country', 2);
  INSERT INTO client VALUES(402, 'FedEx', 3);
  INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
  INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
  INSERT INTO client VALUES(405, 'Times Newspaper', 3);
  INSERT INTO client VALUES(406, 'FedEx', 2);

  -- WORKS_WITH
  INSERT INTO works_with VALUES(105, 400, 55000);
  INSERT INTO works_with VALUES(102, 401, 267000);
  INSERT INTO works_with VALUES(108, 402, 22500);
  INSERT INTO works_with VALUES(107, 403, 5000);
  INSERT INTO works_with VALUES(108, 403, 12000);
  INSERT INTO works_with VALUES(105, 404, 33000);
  INSERT INTO works_with VALUES(107, 405, 26000);
  INSERT INTO works_with VALUES(102, 406, 15000);
  INSERT INTO works_with VALUES(105, 406, 130000);
```

## 9) ***Queries and operations***

# find all clients
```sql
    select * from client
```

# find all employees ordered by salary
```sql
    select * from employee
    order by salary desc
```
# find all employees ordered by sex and name
```sql
    select * from employee
    order by sex, first_name
```

# find the first 5 employees in the table
```sql
    select * from employee
    limit 5;
```
# find first and last names of all employees
```sql
    select employee.first_name, employee.last_name
    from employee;
```

# find the forename and the surname of all employees
```sql
    select employee.first_name as forename, employee.last_name as surname
    from employee;
```

# find out all the different genders
```sql
    SELECT distinct employee.sex from employee;
```

### 10) ***Functions***

# Task: find the number of employees / ***count***

```sql
select count(employee.emp_id) from employee
```

# Task: find the number of female employees born after 1970
```sql
  select count(employee.birth_day) from employee
  where birth_day > '1970-01-01' AND sex = 'F'
```

# Task: average salary of all employees / ***avg***
```sql
  select avg(employee.salary) as avg from employee
```

### Task: average salary of male employees
```sql
  select avg(employee.salary) from employee
  where sex = 'M';
```

# Task: sum of all employee salaries / ***sum***
```sql
  select sum(employee.salary) from employee;
```

# Task: count by column
```sql
  select count(sex) sex
  from employee
```

## 11) ***Aggregation***

-- AGGREGATION ca be used to organize the data we get from functions like sum, count, avg

### Task: count employees by sex // ***group by***
```sql
  select count(sex), sex
  from employee
  group by sex
```

### Task: total sales per employee
```sql
  select sum(works_with.total_sales), emp_id
  from works_with
  group by emp_id
```

### Task: total spending per client
```sql
  select sum(works_with.total_sales), client_id
  from works_with
  group by client_id
```

## 12) Wildcards / ***LIKE***

-- % = any char
-- _ = single character

### Task: clients whose name includes "LLC"
```sql
  SELECT client.client_id from client
  WHERE client_name  LIKE '%LLC%';
```

### Task: single-character wildcard (will not match multi-char before LLC)
-- WILL NOT WORK BECAUSE THERE IS MORE THAN ONE CHAR BEFORE LLC
```sql
  SELECT client_id from client
  WHERE client_name like '_LLC';
```

### Task: branch suppliers in the label business
```sql
  SELECT supplier_name from branch_supplier
  WHERE supplier_name LIKE '%label%'
  OR supplier_name LIKE '% Label%';
```

### Task: employees born in October
```sql
  Select employee.first_name from employee
  where birth_day::text LIKE '____-10-__';
```

## 13) ***Unions***

-- union is a special sl operator that we can use to combine the results of multiple select statements
-- to make it work both select queries must have the same amount of columns
-- and both selects has to be of the same data type

### Task: list employees and branch names
```sql
  select employee.first_name from employee
  union
  select branch.branch_name from branch;
```

### Task: example that fails (different column counts)
-- ERROR - different number of cols
```sql
  select employee.first_name, last_name from employee
  union
  select branch.branch_name from branch;
```

### Task: valid 2-column union (names with branch_id)
```sql
  SELECT client_name, client.branch_id from client
  union
  select branch_name, branch.branch_id
  from branch
```

### Task: list of all money spent or earned by the company
```sql
  select salary from employee
  union
  select total_sales from works_with;
```

## 14) ***Joins***

-- JOINS are used to combine information from different tables based on a related column between them
-- to test them we are going to introduce a new branch into our branch table with some null values

### Task: setup (optional) add branch with null values
                                                    ```sql
                                                      INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);
                                                      SELECT * FROM branch
                                                    ```

                                                    ### Task: find all branches and the names of their managers
-- In this task we can take advantage of the fact that table employee and table branch both share the same column - with id of an employee, in case of branch this is gonna be a branch manager.

                                                    ### Task: INNER JOIN (standard join)
-- ***INNER JOIN***, OR GENERAL JOIN OR JUST JOIN - the standard one - Join will give as a result if both values in
left and right table are present and if they share the same employee.id
```sql
  Select employee.emp_id, employee.first_name, branch.branch_name
  FROM employee
  JOIN branch
  ON employee.emp_id = branch.mgr_id;
```

                                                    ### Task: ***LEFT JOIN*** (all employees, branch may be null)
-- LEFT JOIN - print all values from left hand side table
```sql
  Select employee.emp_id, employee.first_name, branch.branch_name
  FROM employee
  left JOIN branch
  ON employee.emp_id = branch.mgr_id;
```

                                                    ### Task: ***RIGHT JOIN*** (all branches, employee may be null)
-- RIGHT JOIN - print all values from right hand side table - branch, even if branch has no mgr_id
-- This will print all the values even if there is no employee assigned to this branch (null)
```sql
  Select employee.emp_id, employee.first_name, branch.branch_name
  FROM employee
  right JOIN branch
  ON employee.emp_id = branch.mgr_id;
```

                                                    ## 15) ***Nested queries***

                                                    ### Task: employees who sold over 30000 to a single client
```sql
  SELECT employee.last_name from employee
  WHERE emp_id in (
    SELECT employee.emp_id FROM works_with
    where works_with.total_sales > 30000
  )
```

                                                    ### Task: same via JOIN
-- Same via JOIN
```sql
  SELECT last_name, total_sales FROM employee
  JOIN works_with
  ON employee.emp_id = works_with.emp_id
  WHERE works_with.total_sales > 30000;
```

                                                    ### Task: clients handled by the branch managed by Michael Scott (id = 102)
```sql
  select client.client_name from client
  where client.branch_id = (
    select branch.branch_id from branch
    where branch.mgr_id = 102
    limit 1
  )
```

                                                    ### Task: same via JOIN
-- Same via JOIN
```sql
  select client.client_name, branch.branch_id from client
  join branch
  on client.branch_id = branch.branch_id
  where branch.mgr_id = 102
```

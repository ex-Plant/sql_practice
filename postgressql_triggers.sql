-- TRIGGER is a block of SQL code, that we can define and that will be executed after certain operation gets performed on the db
  CREATE table trigger_test (
  message VARCHAR(100)
  );
-- In Postgres (and therefore Supabase) you can’t just put SQL inline inside CREATE TRIGGER — you must first ***create a
-- trigger function***, then bind it to a trigger.

-- CREATING FUNCTION
-- 🔎 Explanation:
-- log_new_employee() is a Postgres function, written in PL/pgSQL (LANGUAGE plpgsql).
-- Inside, we just run the
-- INSERT INTO trigger_test ....
-- RETURN NEW; is required for BEFORE INSERT triggers so Postgres knows what row to insert.
-- - when we are deleting a row we return OLD
-- - Postgres uses $$ ... $$ as a way to wrap function bodies
-- - we need to define language

CREATE OR REPLACE function log_new_emp()
  RETURNS TRIGGER AS
  $$
    BEGIN
      INSERT INTO trigger_test(message)
      VALUES('added new employee');
      RETURN NEW;
    END;
  $$ LANGUAGE plpgsql;

-- CREATING INSERT TRIGGER
  CREATE TRIGGER my_trigger
  BEFORE INSERT ON employee
  FOR EACH ROW EXECUTE function log_new_emp();

--  ✅ Now every time we insert an employee, trigger_test table should be updated as well


-- add new val to employee table and check if trigger_test table was updated
  insert into employee values(109, 'Jhonny', 'Walker', null, 'M', 1000000, Null, Null);
  select * from trigger_test


-- # CREATE ANOTHER FOO
-- notice we are referencing a value from a NEW ROW
   CREATE OR REPLACE function foo()
   RETURNS TRIGGER AS
   $$
     BEGIN
     insert into trigger_test
     values('test', NEW.first_name);
     RETURN NEW;
     END;
   $$ LANGUAGE plpgsql;


-- CREATE BEFORE TRIGGER
  CREATE TRIGGER test_trigger
  BEFORE INSERT ON employee
  FOR each ROW EXECUTE function foo()

-- INSERT VALS AND CHECK IF TRIGGER TEST WAS UPDATED
  insert into employee values(110, 'Jhonny', 'Bravo', null, 'M', 900000, Null, Null);
  select * from trigger_test

-- # Example: Log whenever someone deletes a row from a table
-- # Create table
    CREATE TABLE delete_logs(
         log varchar(200)
    )

--  Create foo
      CREATE OR replace function log_delete()
      RETURNS TRIGGER AS
      $$
      BEGIN
        INSERT INTO delete_logs
        values('row deleted || OLD.emp_id');
        RETURN OLD;
        END
      $$ language plpgsql;

-- CREATE BEFORE DELETE TRIGGER
  CREATE trigger delete_trigger
  before delete on employee
  FOR EACH ROW execute function log_delete();

-- # DELETE ROW AND CHECK IF TRIGGER TEST WAS UPDATED
  delete from employee
  where emp_id = 110;
  select * from delete_logs;

-- WE can add triggers BEFORE or AFTER some operation
-- we can use trigger on delete, update or insert
-- we can use conditional logic to determine the exact behavior of the trigger


-- # create update logs table
  create table update_logs(
    id bigint generated ALWAYS AS IDENTITY primary key,
    log VARCHAR(100)
  )

-- # update function with conditional logic
      create or replace function update_foo()
      returns trigger as
      $$ begin
      if new.sex = 'F' then
      insert into update_logs(log) values('female added');
      elseif  new.sex = 'M' then
      insert into update_logs(log) values('male added');
      else insert into update_logs(log) values('sex is missing');
      end if;
      RETURN NEW;
      end
      $$ language plpgsqlzx

--     # create after update trigger
  create trigger update_trigger
  AFTER update on employee
  for each row execute function update_foo();
  update employee
  set sex = 'X'
  where emp_id = 110;

-- # drop trigger
      DROP TRIGGGER my_trigger_name

-- ### Triggers: Key points
-- Always:
--   1. Write the trigger function (RETURNS TRIGGER … LANGUAGE plpgsql).
--   2. Attach the function to the table using CREATE TRIGGER … EXECUTE FUNCTION ….
--     - Use `NEW.column` for INSERT/UPDATE triggers.
-- - Use `OLD.column` for DELETE triggers.
--

-- Example: Prevent empty task titles
  CREATE TABLE tasks (
     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
     title TEXT NOT NULL
 );
   CREATE OR REPLACE FUNCTION prevent_empty_title()
   RETURNS TRIGGER AS $$
   BEGIN
     -- Check if title is null or just empty string
     IF NEW.title IS NULL OR NEW.title = '' THEN
       RAISE EXCEPTION 'Task title cannot be empty!';
     END IF;
     RETURN NEW; -- allow the row if valid
   END;
   $$ LANGUAGE plpgsql;

      CREATE TRIGGER validate_task_title
      BEFORE INSERT ON tasks
      FOR EACH ROW
      EXECUTE FUNCTION prevent_empty_title();

      INSERT INTO tasks (title) VALUES ('');
--     - ❌ ERROR:  P0001: Task title cannot be empty! // CONTEXT:  PL/pgSQL function prevent_empty_title() line 5 at RAISE


-- Example: Autofill created_at on insert
  CREATE TABLE posts (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title TEXT NOT NULL,
    created_at TIMESTAMPTZ
  );

  CREATE OR REPLACE FUNCTION autofill_created_at()
  RETURNS TRIGGER AS $$
  BEGIN
    -- If created_at is null, set it to NOW()
    IF NEW.created_at IS NULL THEN
      NEW.created_at := NOW();
    END IF;
    RETURN NEW;  -- always return NEW for BEFORE INSERT triggers
  END;
  $$ LANGUAGE plpgsql;

   CREATE TRIGGER set_created_at
   BEFORE INSERT ON posts
   FOR EACH ROW
   EXECUTE FUNCTION autofill_created_at();


  insert into posts(title) values('stop using backticks!!');
  select * from posts;

-- ### ***DROP triggers***
  DROP TRIGGER IF EXISTS validate_task_title ON tasks;
  DROP TRIGGER IF EXISTS my_trigger ON employee;

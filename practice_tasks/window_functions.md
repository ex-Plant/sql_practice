```sql
    SELECT 
        month,
        total_revenue_cents,
        prev_month_cents,
        IIF(prev_month_cents IS NULL, NULL,  total_revenue_cents - prev_month_cents) AS change_cents,
        IIF(prev_month_cents IS NULL OR prev_month_cents = 0, NULL, ROUND((total_revenue_cents - prev_month_cents) * 100.0 / prev_month_cents)) as pct_change_pct,
        SUM(total_revenue_cents) OVER (order by month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3m_cents,
        CASE
        WHEN prev_month_cents IS NULL THEN 'n/a'
        WHEN prev_month_cents > total_revenue_cents THEN 'down'
        WHEN prev_month_cents < total_revenue_cents THEN 'up'
        WHEN prev_month_cents = total_revenue_cents THEN 'flat'
        END AS trend
        FROM(
            SELECT 
                month,
                total_revenue_cents,
                LAG(total_revenue_cents, 1, NULL) over (ORDER BY MONTH) as prev_month_cents
                FROM (
                    SELECT substr(order_date, 1, 7) as month, 
                    SUM(amount_cents) as total_revenue_cents
                    FROM orders
                    WHERE status = "paid"
                    GROUP BY month
                )
  )
```





🧭 General Approach: Handling Complex / Nested SQL Queries

Start with the core dataset (base layer):

	- Identify the raw table(s) and filters you need.

	SELECT
	  substr(order_date, 1, 7) AS month,
	  SUM(amount_cents) AS total_revenue_cents
	FROM orders
	WHERE status = 'paid'
	GROUP BY month;

	- 🧩 This layer gives you one row per month with the main metric.


2.Add window functions (middle layer):


	- Use window functions to look across rows.

	- Example:

	LAG(total_revenue_cents) OVER (ORDER BY month)



	- You might also add rolling sums or averages here.


3.
Compute derived or conditional columns (outer layer):


	- Subtract, divide, or apply conditions (CASE, IIF, etc.) on the already computed columns.

	- This level handles logic like growth %, trend, etc.


✅ Rule of thumb:

If something depends on a calculated alias (e.g. prev_month_cents), move it one layer out.


---

🪟 Window Functions — “Look Across Rows Without Grouping”
Window functions are SQL’s superpower for analytics.

Basic syntax

	function_name(expression)
	OVER (
	  PARTITION BY some_column   -- optional: define groups
	  ORDER BY another_column    -- defines row ordering for the window
	  ROWS BETWEEN n PRECEDING AND CURRENT ROW -- optional: rolling window
	)

Common examples

Function	Purpose	Example
LAG(col, 1)	Access previous row’s value	Compare with last month
LEAD(col, 1)	Access next row’s value	Compare with next month
SUM(col) OVER (…)	Running / rolling total	Rolling 3‑month revenue
AVG(col) OVER (…)	Running average	Moving average

Key idea


Unlike aggregates (SUM, COUNT), window functions don’t collapse rows — they add context to each row.

Example

	LAG(total_sales) OVER (ORDER BY month)

→ adds a column with the previous month’s total alongside the current month.
---

🧱 CASE and IIF — SQL’s Conditional Logic


SQL doesn’t have if/else — it uses CASE expressions (and sometimes IIF() in SQLite).

CASE (standard, portable across databases)

	CASE
	  WHEN condition1 THEN result1
	  WHEN condition2 THEN result2
	  ELSE fallback
	END AS column_name

IIF (SQLite shorthand)

	IIF(condition, true_value, false_value)

Example: Labeling trends

	CASE
	  WHEN prev_month_cents IS NULL THEN 'n/a'
	  WHEN total_revenue_cents > prev_month_cents THEN 'up'
	  WHEN total_revenue_cents < prev_month_cents THEN 'down'
	  ELSE 'flat'
	END AS trend


---

🧮 Handling NULLs and Comparisons

- In SQL, NULL means “unknown”, not a value.

- You cannot use = to compare to NULL → use IS NULL or IS NOT NULL.

- Arithmetic with NULL always yields NULL:
    - 5 + NULL → NULL


- To prevent errors or misleading output:
    - Use defaults in functions (LAG(..., default_value))
    - Or handle NULL explicitly with IIF/CASE.

📈 Rolling and Aggregated Calculations
To compute a moving 3‑month total or average:


	SUM(total_revenue_cents) 
	OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

This says:

“Sum the current month and the two before it (a 3‑month rolling window).”



---

🎯 Step‑By‑Step Thought Pattern for Complex Queries

1.


Start small:

Write the simplest aggregation query. Check it works.



2.
Layer in analytics:

Add calculated columns (like LAG(), SUM OVER()).



3.
Add derived logic:

Compute diffs, percentages, and trend labels at the highest layer.



4.
Verify each stage:


	- Run each subquery alone to see what it outputs.

	- Once it looks right, embed it in the next layer.


5.
Keep it readable:


	- Add line breaks and aliases.

	- Comment each section for maintainability.



---

🧠 Mindset Shift: Declarative vs Imperative


Front‑end devs think in sequences (“do X, then Y, then Z”).

SQL is declarative — you describe the shape of your desired result, and the database figures out how to build it.

When things nest deeply, think in data transformations:

each subquery produces a new dataset — not a “function call,” but a data layer.


---

TL;DR Checklist for Your Notes


✅ Build queries layer by layer: base → window → final calculations

✅ Use window functions (LAG, SUM OVER) to access other rows

✅ Handle NULLs safely with IS NULL, IIF, or CASE

✅ Compute rolling windows via ROWS BETWEEN ...

✅ Avoid referencing an alias in the same layer — move it one level out

✅ Think data shapes, not instructions — you tell SQL what you want, not how to do it.



# Monthly Revenue Trends (Window Functions)
Your analytics team wants a month-over-month revenue trends report for paid orders. They need running comparisons and a rolling window to see momentum.

Write a single SQL query that returns one row per month with the following columns, in this exact order:

month — the month in YYYY-MM format
total_revenue_cents — total cents of paid orders in that month
prev_month_cents — total cents from the previous month (NULL for the first month)
change_cents — total_revenue_cents - prev_month_cents (NULL for the first month)
pct_change_pct — percentage change from previous month, rounded to the nearest integer (NULL when previous is NULL or 0)
rolling_3m_cents — rolling sum of the last 3 months (including the current month)
trend — a label based on change vs previous month: "up", "down", "flat", or "n/a" (for the first month)
Additional requirements:

Only include rows where status = 'paid'
Sort the results by month ascending
You should use SQL window functions as the primary tool. Common Table Expressions (CTEs) and CASE expressions are welcome.
Hints:

Extract the month with substr(order_date, 1, 7).
Use LAG(...) OVER (ORDER BY month) to access the previous month’s value.
Use SUM(...) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) for a 3-month rolling sum.
Round the percent change with ROUND(...).
Example (illustrative):

If January has 20000 and February has 20000, then for February: prev_month_cents = 20000, change_cents = 0, pct_change_pct = 0, trend = "flat", and rolling_3m_cents for February is January + February.


data
```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  order_date TEXT NOT NULL, -- YYYY-MM-DD
  amount_cents INTEGER NOT NULL,
  status TEXT NOT NULL
);

-- January
INSERT INTO orders VALUES (1, '2023-01-05', 12000, 'paid');
INSERT INTO orders VALUES (2, '2023-01-20', 8000, 'paid');
INSERT INTO orders VALUES (3, '2023-01-25', 5000, 'refunded');

-- February
INSERT INTO orders VALUES (4, '2023-02-02', 15000, 'paid');
INSERT INTO orders VALUES (5, '2023-02-18', 5000, 'paid');
INSERT INTO orders VALUES (6, '2023-02-28', 2000, 'refunded');

-- March
INSERT INTO orders VALUES (7, '2023-03-07', 30000, 'paid');
INSERT INTO orders VALUES (8, '2023-03-22', 3000, 'refunded');

-- April
INSERT INTO orders VALUES (9, '2023-04-03', 10000, 'paid');

-- May
INSERT INTO orders VALUES (10, '2023-05-11', 12000, 'paid');
INSERT INTO orders VALUES (11, '2023-05-19', 13000, 'paid');

-- June
INSERT INTO orders VALUES (12, '2023-06-09', 25000, 'paid');
INSERT INTO orders VALUES (13, '2023-06-21', 4000, 'refunded');
```

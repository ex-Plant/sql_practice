Boot.dev
Dashboard
Courses
Training
Billing
Community
Leaderboard

Toggle notifications
gem bag
Acolyte
Level 31
user avatarprofile role frame

sharpshooter armor
sharpshooter
8

streak embers

daily streak
14
Explain difficulty

xp potions
chest
Skip
On-Time Couriers (CTE)
A food-delivery app wants a quick report on how reliably each courier delivers orders on time.

Use a Common Table Expression (CTE) to label each delivered order as on-time or late, then summarize by courier.

What to know:

A CTE lets you build a temporary named result to use in the main query. It starts with WITH name AS (...).
A CASE expression lets you compute values based on conditions: CASE WHEN condition THEN value ELSE other END.
Write a query to return the following columns in this exact order:

courier — the courier's name
total_deliveries — number of delivered orders per courier
on_time_deliveries — number of delivered orders where delivered_at <= promised_by
on_time_rate_pct — the on-time percentage as a whole number (rounded to the nearest integer)
Additional requirements:

Only include orders with status = 'delivered' when computing the metrics.
Only include couriers that have at least 3 delivered orders (total_deliveries >= 3).
Sort results by on_time_rate_pct in descending order, then by courier in ascending order.
High-level steps:

Create a CTE (for example delivered) that selects delivered orders and adds an on_time flag using a CASE expression: 1 if on time, 0 if late.
From that CTE, join to couriers to get the courier name.
Group by courier to compute counts and the rounded percentage.
Example of the on-time rule:

If promised_by = '2023-05-01 12:00' and delivered_at = '2023-05-01 11:59' or '2023-05-01 12:00', it is on time.
If delivered_at = '2023-05-01 12:01', it is late.
Tip:

You can compute the percentage with something like ROUND(100.0 * SUM(on_time) / COUNT(*)).

Boots
Spellbook
Boots
Need help? I, Boots the Undercaffeinated and Overfed, can assist... for a price.


Start Voice Chat
002_main.sql
001_up.sql
1


Submit

Run

Solution

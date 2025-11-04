/* 💥Task💥
City Driver Activity
A ride-sharing ops team wants a quick summary of activity by city. Use SQL JOINs to combine cities, drivers, and their trips.

Write a single SELECT query that returns the following columns in this order:

city — the city name
country — the city country code
drivers_in_city — the number of distinct drivers in the city
completed_trips — the number of trips with status completed in the city
load_label — use a CASE expression: "busy" if completed_trips >= 3, otherwise "normal"
Requirements:

Join the cities table to drivers, and join drivers to trips.
Only include cities that have at least 2 drivers and at least 1 completed trip.
Sort the results by completed_trips descending, then by city ascending.
Tip: When joining trips, drivers with no trips should still count toward drivers_in_city. Consider a LEFT JOIN from drivers to trips. */

-- Create tables
CREATE TABLE cities (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  country TEXT NOT NULL
);

CREATE TABLE drivers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  city_id INTEGER NOT NULL
);

CREATE TABLE trips (
  id INTEGER PRIMARY KEY,
  driver_id INTEGER NOT NULL,
  status TEXT NOT NULL
);

-- Cities
INSERT INTO cities (id, name, country) VALUES (1, 'Austin', 'US');
INSERT INTO cities (id, name, country) VALUES (2, 'Boston', 'US');
INSERT INTO cities (id, name, country) VALUES (3, 'Denver', 'US');
INSERT INTO cities (id, name, country) VALUES (4, 'Paris', 'FR');

-- Drivers
INSERT INTO drivers (id, name, city_id) VALUES (1, 'Alice', 1); -- Austin
INSERT INTO drivers (id, name, city_id) VALUES (2, 'Ben', 1);   -- Austin
INSERT INTO drivers (id, name, city_id) VALUES (3, 'Cara', 2);  -- Boston
INSERT INTO drivers (id, name, city_id) VALUES (4, 'Dan', 3);   -- Denver
INSERT INTO drivers (id, name, city_id) VALUES (5, 'Eve', 3);   -- Denver
INSERT INTO drivers (id, name, city_id) VALUES (6, 'Frank', 3); -- Denver
INSERT INTO drivers (id, name, city_id) VALUES (7, 'Gina', 4);  -- Paris
INSERT INTO drivers (id, name, city_id) VALUES (8, 'Hank', 4);  -- Paris

-- Trips
INSERT INTO trips (id, driver_id, status) VALUES (1, 1, 'completed');
INSERT INTO trips (id, driver_id, status) VALUES (2, 1, 'completed');
INSERT INTO trips (id, driver_id, status) VALUES (3, 1, 'canceled');
INSERT INTO trips (id, driver_id, status) VALUES (4, 2, 'completed');
INSERT INTO trips (id, driver_id, status) VALUES (5, 3, 'completed');
INSERT INTO trips (id, driver_id, status) VALUES (6, 4, 'completed');
INSERT INTO trips (id, driver_id, status) VALUES (7, 4, 'canceled');
INSERT INTO trips (id, driver_id, status) VALUES (8, 5, 'completed');
INSERT INTO trips (id, driver_id, status) VALUES (9, 6, 'canceled');
INSERT INTO trips (id, driver_id, status) VALUES (10, 7, 'canceled');

-- ✅ Solutions
SELECT
  cities.name as city, cities.country,
  COUNT(DISTINCT(drivers.id)) as drivers_in_city,
  SUM(CASE WHEN trips.status = 'completed' THEN 1 ELSE 0 END ) as completed_trips,
  CASE WHEN SUM(CASE WHEN trips.status = "completed" THEN 1 ELSE 0 END) >= 3
    THEN 'busy' ELSE 'normal' END AS load_label
  FROM cities
JOIN drivers ON drivers.city_id = cities.id
JOIN trips ON trips.driver_id = drivers.id
GROUP BY cities.name

HAVING COUNT(DISTINCT drivers.id) >= 2
AND SUM(CASE WHEN trips.status = 'completed' THEN 1 ELSE 0 END) >= 1
ORDER BY completed_trips DESC, cities.name ASC

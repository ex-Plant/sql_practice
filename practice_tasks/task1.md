# DIFFICULT TASK
    Your music analytics team wants to find which artists have a broad international audience among your active listeners.
    Active listeners are users who have played at least 2 tracks in total.
    
    ❗ *Write a single SQL query that returns the following columns:*
    
    - artist_name — the artist's name
      - listener_countries — the number of unique country codes of active users who played this artist
      - total_plays — the total number of plays from active users for this artist
      *Requirements:*
    
    Only include plays from active users (users with at least 2 total plays in the plays table).
    Use joins between plays, tracks, artists, and users.
    Group by artist.
    Only return artists where:
    listener_countries is at least 2
    total_plays is at least 3
    Sort the results by listener_countries in descending order, then by artist_name in ascending order.
    Hint:
    Use a subquery to find the active users (group by user_id in plays and filter with HAVING COUNT(*) >= 2).

```SQL
    -- CREATE TABLE users (
    --   id INTEGER PRIMARY KEY,
    --   name TEXT NOT NULL,
    --   country_code TEXT NOT NULL
    -- );
    
    -- CREATE TABLE artists (
    --   id INTEGER PRIMARY KEY,
    --   name TEXT NOT NULL
    -- );
    
    -- CREATE TABLE tracks (
    --   id INTEGER PRIMARY KEY,
    --   title TEXT NOT NULL,
    --   artist_id INTEGER NOT NULL
    -- );
    
    -- CREATE TABLE plays (
    --   id INTEGER PRIMARY KEY,
    --   user_id INTEGER NOT NULL,
    --   track_id INTEGER NOT NULL,
    --   played_at DATE NOT NULL
    -- );
```



# Solution from bootcamp
```SQL
    -- SELECT
    --   a.name AS artist_name,
    --   COUNT(DISTINCT u.country_code) AS listener_countries,
    --   COUNT(*) AS total_plays
    -- FROM plays AS p
    -- JOIN tracks AS t ON p.track_id = t.id
    -- JOIN artists AS a ON t.artist_id = a.id
    -- JOIN users AS u ON p.user_id = u.id
    -- WHERE p.user_id IN (
    --   SELECT user_id
    --   FROM plays
    --   GROUP BY user_id
    --   HAVING COUNT(*) >= 2
    -- )
    -- GROUP BY a.name
    -- HAVING COUNT(DISTINCT u.country_code) >= 2
    --    AND COUNT(*) >= 3
    -- ORDER BY listener_countries DESC, artist_name ASC;
```



# SOLUTION
```sql
    WITH active_users AS (
    SELECT
    user_id
    FROM plays
    GROUP BY user_id
    HAVING COUNT(*) >= 2
    )
    
    select
    artists.name as artist_name,
    count(distinct(users.country_code)) as listener_countries,
    count(plays.played_at) as total_plays
    from artists
    left join tracks
    on tracks.artist_id = artists.id
    join plays
    on tracks.id = plays.track_id
    join users
    on users.id = plays.user_id
    -- where users.id in (
    
    -- select user_id from plays  
    -- group by user_id
    -- having count(*) >= 2
    -- )
    
    join active_users
    on active_users.user_id = users.id
    
    group by artists.id
    having listener_countries >= 2 AND total_plays >= 3
    order by artist_name desc
    
    -- select * from plays;
    -- select * from users;
    -- select * from plays;
    -- select * from artists;
```

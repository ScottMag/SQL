CREATE UNIQUE INDEX iunc_staff__manager_id ON dbo.staff (manager_id, staff_id) -- without it it will be very slow
go
WITH cte AS (
    SELECT s.staff_id, s.staff_name, 1 AS Level, s.manager_id, CAST(s.staff_id AS VARCHAR(max)) AS path
      FROM staff AS s
     WHERE s.manager_id IS NULL
    UNION ALL -- not just UNION, since UNION makes an implicit DISTICT which doesn't help here (there are per definition no duplicates) but would slow down the query a lot
    -- Recursive part
    SELECT s.staff_id, s.staff_name, Level + 1, s.manager_id, CONCAT_WS(', ', path, s.staff_id) AS path
    FROM staff  AS s
    JOIN cte AS d
    ON s.manager_id = d.staff_id
    )
SELECT TOP (100000) 
       c.staff_id, c.staff_name, c.Level, c.path, c.manager_id
     , COUNT(*) OVER (PARTITION BY c.manager_id)          AS peers_same_manager
     , COUNT(*) OVER (PARTITION BY c.Level)               AS total_peers_same_level -- the wording of the task says same level AND same manager, but this would it make equal to the number before and in the example is only grouped by the Level
  FROM cte AS  c
 ORDER BY total_peers_same_level DESC, c.Level ASC, c.staff_id ASC
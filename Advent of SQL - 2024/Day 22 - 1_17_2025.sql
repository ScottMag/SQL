SELECT COUNT(DISTINCT e.id) AS numofelveswithsql
--SELECT *
FROM elves AS e
CROSS APPLY STRING_SPLIT(e.skills, ',') AS ss
WHERE ss.value = 'SQL'
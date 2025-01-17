WITH SUB AS (SELECT wr.request_id
             , CAST(wr.url AS NVARCHAR(255)) AS URL
             , IIF(ss.value = 'utm_source=advent-of-sql', 1, 0) AS is_aos
             , CAST(ss.value AS NVARCHAR(255)) AS parameter
             , LEFT(ss.value, CHARINDEX('=', ss.value) -1) AS parameter_name
             , SUBSTRING(ss.value, CHARINDEX('=', ss.value) + 1, 8000) AS parameter_value
          FROM web_requests AS wr
         CROSS APPLY STRING_SPLIT(SUBSTRING(wr.url, CHARINDEX('?', wr.url) + 1, 8000), '&') AS ss
        )

SELECT
       sub.url
     , COUNT(DISTINCT sub.parameter_name ) AS number_of_parameters
     , sub.request_id
	 --SELECT *
  FROM  sub
 GROUP BY sub.url, sub.request_id
 HAVING MAX(sub.is_aos) = 1
 ORDER BY number_of_parameters DESC, sub.url ASC;
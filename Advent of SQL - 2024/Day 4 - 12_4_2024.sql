 SELECT calc.toy_id
     , calc.toy_name
     , STRING_AGG(IIF(calc.status = 'new', calc.tag, NULL), ',')     AS added_tags 
     , STRING_AGG(IIF(calc.status = 'equal', calc.tag, NULL), ',')   AS unchanged_tags  
     , STRING_AGG(IIF(calc.status = 'missing', calc.tag, NULL), ',') AS removed_tags  
     , SUM(IIF(calc.status = 'new', 1, 0))                           AS added_tags_count
     , SUM(IIF(calc.status = 'equal', 1, 0))                         AS unchanged_tags_count
     , SUM(IIF(calc.status = 'missing', 1, 0))                       AS removed_tags_count
  FROM (SELECT tp.toy_id, tp.toy_name, pr.Value AS tag 
          FROM dbo.toy_production AS tp
         OUTER APPLY OPENJSON(tp.previous_tags) AS pr
       --OUTER APPLY STRING_SPLIT(tp.previous_tags, ',') AS pr -- pre-SQL-2022-version
       ) AS prev
  FULL OUTER JOIN
        (SELECT tp.toy_id, tp.toy_name, nt.Value AS tag 
          FROM dbo.toy_production AS tp
         OUTER APPLY OPENJSON(tp.new_tags) AS nt
       --OUTER APPLY STRING_SPLIT(tp.new_tags, ',') AS nt -- pre-SQL-2022-version
       ) AS curr
    ON curr.toy_id = prev.toy_id
   AND curr.tag    = prev.tag
 CROSS APPLY ( -- get intermediate results so that I don't have to repeat the ISNULL etc. multiple times at other places in the statement
              SELECT ISNULL(prev.toy_id, curr.toy_id)     AS toy_id
                   , ISNULL(prev.toy_name, curr.toy_name) AS toy_name
                   , ISNULL(prev.tag, curr.tag)           AS tag
                   , CASE WHEN prev.tag IS NOT NULL AND curr.tag IS NOT NULL THEN 'equal'
                          WHEN prev.tag IS     NULL AND curr.tag IS NOT NULL THEN 'new'
                          WHEN prev.tag IS NOT NULL AND curr.tag IS     NULL THEN 'missing'
                     END AS status
             ) AS calc
 GROUP BY calc.toy_id, calc.toy_name
 ORDER BY added_tags_count DESC -- you can order by a result column alias without repeating its formula and without specifying a table alias (would not exists in this case)
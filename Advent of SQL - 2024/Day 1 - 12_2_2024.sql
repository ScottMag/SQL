SELECT TOP (5) CONCAT_WS(',', sub.name
                            , sub.primary_wish
                            , sub.backup_wish
                            , sub.favorite_color
                            , sub.color_count
                            , sub.gift_complexity
                            , sub.workshop_assignement)
  FROM (
        SELECT c.name
             , JSON_VALUE(wl.wishes, '$.first_choice')  AS primary_wish
             , JSON_VALUE(wl.wishes, '$.second_choice') AS backup_wish
             , JSON_VALUE(wl.wishes, '$.colors[0]')     AS favorite_color
             , cc.color_count
             , CASE tc.difficulty_to_make WHEN 1 THEN 'Simple'
                                          WHEN 2 THEN 'Moderate'
                                                 ELSE 'Complex'
               END + ' Gift' AS gift_complexity
             , CASE tc.category WHEN 'outdoor'     THEN 'Outside'
                                WHEN 'educational' THEN 'Learning'
                                                   ELSE 'General'
               END + ' Workshop' AS workshop_assignement
          FROM dbo.children AS c
         INNER JOIN dbo.wish_lists AS wl
            ON wl.child_id = c.child_id
         CROSS APPLY (SELECT COUNT(*) color_count
                        FROM OPENJSON(wl.wishes, '$.colors') AS oj
                     ) AS cc
         INNER JOIN dbo.toy_catalogue AS tc
            ON tc.toy_name = JSON_VALUE(wl.wishes, '$.first_choice')
        ) AS sub
 ORDER BY sub.name, sub.primary_wish
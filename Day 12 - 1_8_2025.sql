SELECT TOP 1 *
  FROM (
        SELECT sub.*
             , DENSE_RANK() OVER (ORDER BY sub.overall_rank DESC) AS ranked_rank
          FROM ( -- this subselect is the most important, the outer selects are just to get the first line of the second group, which is the correct answer
                SELECT TOP(500) -- for PROD remove the TOP and the ORDER BY, they are just for testing purposes, so that you can run the subquery alone)
                     gd.gift_name, gd.price
                     , gr.requests
                     , CAST(PERCENT_RANK() OVER (ORDER BY gr.requests)  AS DECIMAL(5,2)) AS overall_rank 
                  FROM (SELECT gr.gift_id, COUNT(*) AS requests -- (if possible) group first before joining to a lookup table
                          FROM dbo.gift_requests AS gr
                         GROUP BY gr.gift_id
                       ) AS gr
                 INNER JOIN dbo.gifts AS gd
                    ON gd.gift_id = gr.gift_id
                  ORDER BY overall_rank DESC, gd.gift_name -- remove it when taking the whole query productive
              ) AS sub
      ) AS rr
 WHERE rr.ranked_rank = 2 -- the solution wants the second group
 ORDER BY rr.gift_name    -- within the group it wants the alphabetical first gift
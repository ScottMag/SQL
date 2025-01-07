SELECT TH.FIELD_NAME, TH.HARVEST_YEAR, TH.SEASON, TH.TREES_HARVESTED, CALC.QUARTER,
       CAST(AVG(CAST(TH.TREES_HARVESTED AS DECIMAL(9, 4))) OVER (PARTITION BY TH.FIELD_NAME, TH.HARVEST_YEAR 
                                                                     ORDER BY CALC.QUARTER DESC
                                                                      ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
                                                                ) AS DECIMAL (9, 2)) AS  THREE_SEASON_MOVING_AVG
FROM DBO.TREEHARVESTS AS TH
CROSS APPLY (SELECT CASE TH.SEASON WHEN 'Spring' THEN 1
                                   WHEN 'Summer' THEN 2
                                   WHEN 'Fall'   THEN 3
                                   WHEN 'Winter' THEN 4
                    END AS QUARTER) AS CALC
ORDER BY  THREE_SEASON_MOVING_AVG DESC
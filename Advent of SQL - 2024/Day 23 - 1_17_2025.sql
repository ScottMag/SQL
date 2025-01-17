SELECT MIN(sub.value) AS gap_start
     , MAX(sub.value) AS gap_end
     , STRING_AGG(sub.value, ',')           AS missing_numbers 
     , sub.temp_grp
     , DENSE_RANK() OVER (ORDER BY sub.temp_grp) AS ordered_group
  FROM (
        SELECT gs.value
             , LAG(gs.value, 1) OVER (ORDER BY gs.value)        AS prev_value
             , gs.value - DENSE_RANK() OVER (ORDER BY gs.value) AS temp_grp -- this is the main trick and otherwise most difficult part, it returns a (meaningless) value for each gap_group 
          FROM GENERATE_SERIES(1, 10000) AS gs
         WHERE NOT EXISTS (SELECT * FROM dbo.sequence_table AS st WHERE gs.value = st.id)
      ) AS sub
 GROUP BY sub.temp_grp
 ORDER BY sub.temp_grp
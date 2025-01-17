WITH cte AS (
             SELECT w.workshop_id, w.workshop_name, w.timezone, w.business_start_time, w.business_end_time
                  , pt.utc_offset
                  , CAST(DATETIMEOFFSETFROMPARTS(2024, 12, 23, DATEPART(HOUR, w.business_start_time), DATEPART(MINUTE, w.business_start_time), 0, 0, pt.utc_offset_hour, pt.utc_offset_minutes, 0) AT TIME ZONE 'UTC' AS TIME) AS business_start_time_utc
                  , CAST(DATETIMEOFFSETFROMPARTS(2024, 12, 23, DATEPART(HOUR, w.business_end_time  ), DATEPART(MINUTE, w.business_end_time  ), 0, 0, pt.utc_offset_hour, pt.utc_offset_minutes, 0) AT TIME ZONE 'UTC' AS TIME) AS business_end_time_utc
               FROM Workshops AS w
              INNER JOIN (SELECT pt.time_zone, pt.utc_offset, pt.utc_offset_minutes, pt.utc_offset_hour
                               , ROW_NUMBER() OVER (PARTITION BY pt.time_zone ORDER BY pt.is_dst) AS rn -- prever time without summertime
                            FROM TIMEZONES AS pt
                         ) AS pt
                 ON pt.time_zone = w.timezone
                AND pt.rn        = 1
             )
     , times AS ( -- List of every 15 min frame between 00:00 and 23:45 (since there are a few timezones with 15 or 45 minutes)
             SELECT TIMEFROMPARTS(h.value, m.minute, 0, 0, 0) AS possible_time_start
                  , DATEADD(HOUR, 1, TIMEFROMPARTS(h.value, m.minute, 0, 0, 0)) AS possible_time_end
               FROM GENERATE_SERIES(0, 23) AS h
              CROSS JOIN (VALUES (0), (15), (30), (45)) AS m(minute)
             )
SELECT t.possible_time_start, t.possible_time_end
      , c.*    
  FROM times t
 CROSS APPLY (SELECT COUNT(*) AS number_fitting_zones, STRING_AGG(c.workshop_name, ', ') WITHIN GROUP (ORDER BY c.utc_offset, c.workshop_name) AS workshop_list
                FROM cte AS c 
               WHERE t.possible_time_start BETWEEN c.business_start_time_utc AND c.business_end_time_utc
                 AND t.possible_time_end   BETWEEN c.business_start_time_utc AND c.business_end_time_utc
             ) AS c
 ORDER BY c.number_fitting_zones DESC, t.possible_time_start
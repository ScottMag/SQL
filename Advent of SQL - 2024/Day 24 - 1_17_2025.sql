SELECT s.song_title
     , COUNT(*)       AS total_plays
     , SUM(calc.skip) AS total_skips
  FROM dbo.user_plays AS up
 INNER JOIN dbo.songs AS s
    ON s.song_id = up.song_id
 CROSS APPLY (SELECT IIF(s.song_duration = up.duration, 0, 1) AS skip) AS calc
 GROUP BY s.song_title
 ORDER BY total_plays DESC, total_skips ASC
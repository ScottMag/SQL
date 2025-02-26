SELECT A.REINDEER_NAME,
	   CAST(AVG_SPEED AS DECIMAL(5,2)) AS AVG_SPEED
FROM (SELECT DISTINCT REINDEER_NAME,
			          EXERCISE_NAME,
					  AVG(SPEED_RECORD) AS AVG_SPEED,
					  ROW_NUMBER() OVER(PARTITION BY REINDEER_NAME ORDER BY AVG(SPEED_RECORD) DESC) AS RNK 
	  FROM REINDEERS R
	  INNER JOIN TRAINING_SESSIONS T
	  ON R.REINDEER_ID = T.REINDEER_ID
	  WHERE R.REINDEER_NAME <> 'Rudolph'
	  GROUP BY REINDEER_NAME, EXERCISE_NAME
) A
WHERE A.RNK = 1
ORDER BY AVG_SPEED DESC;
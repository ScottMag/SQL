SELECT 'TRANSACTIONHISTORY' AS TABLE_NAME,
		MIN(TRANSACTIONID) AS TRANS_ID_BEGIN,
		MAX(TRANSACTIONID) AS TRANS_ID_END
FROM PRODUCTION.TRANSACTIONHISTORY

UNION

SELECT 'TRANSACTIONHISTORYARCHIVE' AS TABLE_NAME,
	   MIN(TRANSACTIONID) AS TRANS_ID_BEGIN,
	   MAX(TRANSACTIONID) AS TRANS_ID_END
FROM PRODUCTION.TRANSACTIONHISTORYARCHIVE;

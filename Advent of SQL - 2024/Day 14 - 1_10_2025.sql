SELECT [RECORD_DATE] ,
	   J1.VALUE AS RECEIPT_DETAILS 
FROM SANTARECORDS
cross apply OPENJSON([cleaning_receipts], '$') j1 
cross apply OPENJSON(j1.value, '$') WITH (garment nvarchar(200) '$.garment', color nvarchar(50) '$.color' ) j2 
where j2.garment ='suit' 
and j2.color = 'green'
ORDER BY RECORD_DATE DESC
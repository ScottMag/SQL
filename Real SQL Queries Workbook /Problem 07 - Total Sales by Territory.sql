SELECT DISTINCT ST.TERRITORYID,
			    ST.NAME AS TERRITORY_NAME,
				ST.COUNTRYREGIONCODE,
				SUM(SUBTOTAL) AS SALES,
				SUM(TAXAMT) AS TAXES
FROM SALES.SALESORDERHEADER SOH
LEFT JOIN SALES.SALESTERRITORY ST
ON ST.TERRITORYID = SOH.TERRITORYID
GROUP BY ST.TERRITORYID,
			    ST.NAME,
				ST.COUNTRYREGIONCODE
ORDER BY 1;

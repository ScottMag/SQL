SELECT TOP 1 C.child_id,
	   C.name,
	   C.age,
	   C.CITY,
	   G.GIFT_ID,
	   G.NAME,
	   G.PRICE,
	   AVG(PRICE) AS AVG
FROM CHILDREN C
INNER JOIN GIFTS G
ON C.CHILD_ID = G.CHILD_ID
GROUP BY C.child_id,
	   C.name,
	   C.age,
	   C.CITY,
	   G.GIFT_ID,
	   G.NAME,
	   G.PRICE
HAVING PRICE > (SELECT AVG(PRICE) FROM GIFTS)
ORDER BY PRICE ASC
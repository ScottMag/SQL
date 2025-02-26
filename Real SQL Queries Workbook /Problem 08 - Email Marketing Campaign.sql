SELECT C.CUSTOMERID,
	   P.FIRSTNAME,
	   P.LASTNAME,
	   E.EMAILADDRESS
FROM SALES.CUSTOMER C
INNER JOIN PERSON.PERSON P
ON P.BUSINESSENTITYID = C.PERSONID
INNER JOIN PERSON.EMAILADDRESS E
ON P.BUSINESSENTITYID = E.BUSINESSENTITYID
ORDER BY 1 ASC;

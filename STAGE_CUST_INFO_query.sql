SELECT
    RTRIM(CONVERT(CHAR(15), customer.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(50), customer.LastNameFirst)) AS "FULLNAME",
	RTRIM(CONVERT(CHAR(25), customer.FirstName)) AS "FIRSTNAME",
	RTRIM(CONVERT(CHAR(25), customer.AltName)) AS "MIDDLENAME",
	RTRIM(CONVERT(CHAR(50), customer.Surname)) AS "LASTNAME",
	RTRIM(CONVERT(CHAR(5), customer.Title)) AS "NAMETITLE",
	"NAMESUFFIX" = 
		CASE
			WHEN customer.AltName in ('JR', 'SR','II','III','IV','ESQ') THEN customer.AltName
			ELSE ''
		END,
	"DBA" = 
		CASE
			WHEN customer.Surname LIKE '%DBA%' THEN RIGHT(CHARINDEX('DBA', customer.Surname) + 3, 35)
			WHEN customer.FirstNameFirst LIKE '%DBA%' THEN RIGHT(CHARINDEX('DBA', customer.FirstNameFirst ) + 3, 35)
			WHEN customer.AltName LIKE '%DBA%' THEN RIGHT(CHARINDEX('DBA', customer.AltName) + 3, 35)
			ELSE ''
		END,
	"CUSTTYPE" = 
		CASE
			WHEN customer.Class IN ('Customer', 'No Service', 'Senior','Write Offs', 'Bankruptcy - Res','Conversion Finals') THEN 0
			ELSE 1
		END,
	"ACTIVECODE" = 
		CASE
			WHEN customer.Status = 'A' THEN 0
			ELSE 1
		END,
	'' AS "MOTHERMAIDENNAME",
	'' AS "EMPLOYERNAME",
	'' AS "EMPLOYERPHONE",
	'' AS "EMPLOYERPHONEEXT",
	'' AS "OTHERIDTYPE1",
	'' AS "OTHERIDVALUE1",
	'' AS "OTHERIDTYPE2",
	'' AS "OTHERIDVALUE2",
	'' AS "OTHERIDTYPE3",
	'' AS "OTHERIDVALUE3",
	CONVERT(CHAR(10),GETDATE(), 126) AS "UPDATEDATE" -- YYYY-MM-DD 
FROM
    VW_CUSTOMER customer
ORDER BY CUSTOMERID
SELECT DISTINCT
	RTRIM(CONVERT(CHAR(15), customer.customer_id)) AS "CUSTOMERID",
	1 AS "ADDRESSSEQ",
	RTRIM(CONVERT(CHAR(35), customer.FirstNameFirst)) AS "MAILINGNAME",
	'' AS "INCAREOF",
	RTRIM(CONVERT(CHAR(35), mailAddr.Address_line_1)) AS "ADDRESS1",
	RTRIM(CONVERT(CHAR(35), mailAddr.Address_line_2)) AS "ADDRESS2",
	RTRIM(CONVERT(CHAR(24), mailAddr.City)) AS "CITY",
	"STATE" = 
		CASE
			WHEN mailAddr.State = 'TEXAS' THEN 'TX' -- Correct Texas
			WHEN mailAddr.State = 'NE' THEN 'NV' -- Correct Nevada
			ELSE LEFT(mailAddr.State,2)
		END,
	"COUNTRY" = 
		CASE
			WHEN addrAll.Country IN ('AT','AU','CA','CH','CR','DE','FR','GU','IC','IS','IT','MX','NL','NZ','SA','SK','SP','UK','US') THEN  addrAll.Country
			WHEN addrAll.Country = 'COSTA RICA' THEN 'CS'
			ELSE 'US' -- Default to US
		END,
	RTRIM(CONVERT(CHAR(15), mailAddr.Zip)) AS "POSTALCODE",
	CONVERT(CHAR(10),GETDATE(), 126) AS "UPDATEDATE"
FROM 
	vw_customer customer
LEFT JOIN
	vw_mailing_address mailAddr
ON 
	mailAddr.customer_id = customer.customer_id
LEFT JOIN
	vw_address_all addrAll
ON
	addrAll.customer_id = customer.customer_id
WHERE 
	mailAddr.Address_line_1 IS NOT NULL AND
	customer.FirstNameFirst NOT LIKE '%CREATED IN ERROR%'

ORDER BY CUSTOMERID ASC
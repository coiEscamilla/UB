SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' AS '~CUSTOMERID~',
	1 AS '~ADDRESSSEQ~',
	'~' + LEFT(REPLACE(REPLACE(customer.FirstNameFirst,'"',''), ',', ''),35) + '~' AS '~MAILINGNAME~',
	'~~' AS '~INCAREOF~',
	'~' + LEFT(REPLACE(REPLACE(mailAddr.Address_line_1,',',''),'"',''), 35) + '~' AS '~ADDRESS1~',
	'~' + LEFT(REPLACE(REPLACE(mailAddr.Address_line_2,',',''),'"',''), 35) + '~' AS '~ADDRESS2~',
	'~' + LEFT(mailAddr.City, 24) + '~' AS '~CITY~',
	'~STATE~' = 
		CASE
			WHEN mailAddr.State = 'TEXAS' THEN 'TX' -- Correct Texas
			WHEN mailAddr.State = 'NE' THEN 'NV' -- Correct Nevada
			ELSE LEFT(mailAddr.State,2)
		END,
	'~COUNTRY~' = 
		CASE
			WHEN addrAll.Country IN ('AT','AU','CA','CH','CR','DE','FR','GU','IC','IS','IT','MX','NL','NZ','SA','SK','SP','UK','US') THEN '~' + addrAll.Country + '~'
			WHEN addrAll.Country = 'COSTA RICA' THEN 'CS'
			ELSE '~US~' -- Default to US
		END,
	'~' + LEFT(mailAddr.Zip, 15) + '~' AS '~POSTALCODE~',
	CONVERT(CHAR(10),GETDATE(), 126) AS '~UPDATEDATE~'
FROM 
	vw_customer customer
JOIN
	vw_mailing_address mailAddr
ON 
	mailAddr.customer_id = customer.customer_id
JOIN
	vw_address_all addrAll
ON
	addrAll.customer_id = customer.customer_id
WHERE 
	mailAddr.Address_line_1 IS NOT NULL AND
	customer.FirstNameFirst NOT LIKE '%CREATED IN ERROR%'

ORDER BY [~CUSTOMERID~] ASC
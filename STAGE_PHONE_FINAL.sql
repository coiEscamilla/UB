SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' AS '~CUSTOMERID~',
	1 AS '~ADDRESSSEQ~',
	'~' + LEFT(customer.LastNameFirst,35) + '~' AS '~MAILINGNAME~',
	'~~' AS '~INCAREOF~',
	'~' + LEFT(mailAddr.Address_line_1, 35) + '~' AS '~ADDRESS1~',
	'~' + LEFT(mailAddr.Address_line_2, 35) + '~' AS '~ADDRESS2~',
	'~' + LEFT(mailAddr.City, 24) + '~' AS '~CITY~',
	'~' + LEFT(mailAddr.State, 2) + '~' AS '~STATE~',
	'~COUNTRY~' = 
		CASE
			WHEN addrAll.Country IN ('AT','AU','CA','CH','CR','DE','FR','GU','IC','IS','IT','MX','NL','NZ','SA','SK','SP','UK','US') THEN '~' + addrAll.Country + '~'
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
LEFT JOIN
	vw_address_all addrAll
ON
	addrAll.customer_id = customer.customer_id
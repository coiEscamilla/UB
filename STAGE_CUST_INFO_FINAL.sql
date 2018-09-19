SELECT
    '~'+ LEFT(customer.customer_id, 15) + '~' AS '~CUSTOMERID~',
	'~'+ LEFT(customer.LastNameFirst, 50) + '~' AS '~FULLNAME~',
	'~'+ LEFT(customer.FirstName, 25) + '~' AS '~FIRSTNAME~',
	'~'+ LEFT(customer.AltName, 25) + '~' AS '~MIDDLENAME~',
	'~'+ LEFT(customer.Surname, 50) + '~' AS '~LASTNAME~',
	'~'+ LEFT(customer.Title, 5) + '~' AS '~NAMETITLE~',
	'~' + '' + '~' AS '~DBA~',
	customer.Class AS '~CUSTTYPE~',
	1 AS '~ACTIVECODE~',
	'~' + '' + '~' AS '~MOTHERMAIDENNAME~',
	'~' + '' + '~' AS '~EMPLOYERNAME~',
	'' AS '~EMPLOYERPHONE~',
	'' AS '~EMPLOYERPHONEEXT~',
	'' AS '~OTHERIDTYPE1~',
	'~' + '' + '~' AS '~OTHERIDVALUE1~',
	'' AS '~OTHERIDTYPE2~',
	'~' + '' + '~' AS '~OTHERIDVALUE2~',
	'' AS '~OTHERIDTYPE3~',
	'~' + '' + '~' AS '~OTHERIDVALUE3~',
	CONVERT(CHAR(10),GETDATE(), 126) AS '~UPDATEDATE~' -- YYYY-MM-DD 
FROM
    VW_CUSTOMER CUSTOMER
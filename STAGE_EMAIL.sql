/****************************************************
			STAGE_EMAIL.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
Last Update: August 15, 2018               


------------------------------------------------------
Purpose:
	Extract email addresses from Inhance to place in
	a staging table for Systems & Software enQuesta v6   
	                         
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	Export results set as a CSV file. Include headers.
	With your text editor, replace the "~" with a single
	double-quote (") so CSV will know what is a string

	Designed to be exported as a .CSV
------------------------------------------------------
Assumptions:
	EMAILCODE will always be 1 (personal) from Inhance
------------------------------------------------------
HISTORY:
	August 15, 2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:
	
****************************************************/
SELECT
	'~' + LEFT(primaryemail.customer_id, 15) + '~' AS '~CUSTOMERID~',
	'~' + LEFT(primaryemail.p_email_address, 254) + '~' AS '~EMAILADDRESS~',
	1 AS '~EMAILCODE~',
	1 AS '~PRIORITY~',
	CONVERT(char(10), GetDate(),126) AS '~UPDATEDATE~'
FROM
	vw_customer primaryemail
WHERE 
	(primaryemail.p_email_address LIKE '%@%' AND primaryemail.p_email_address LIKE '%.%')
	AND LEN(primaryemail.p_email_address) > 0

UNION ALL
SELECT
	'~' + LEFT(secondaryemail.customer_id, 15) + '~' AS '~CUSTOMERID~',
	'~' + LEFT(secondaryemail.s_email_address, 254) + '~' AS '~EMAILADDRESS~',
	1 AS '~EMAILCODE~',
	2 AS '~PRIORITY~',
	CONVERT(char(10), GetDate(),126) AS '~UPDATEDATE~'
FROM
	vw_customer secondaryemail
WHERE
	(secondaryemail.s_email_address LIKE '%%'AND secondaryemail.s_email_address LIKE '%.%')
	AND LEN(secondaryemail.s_email_address) > 0
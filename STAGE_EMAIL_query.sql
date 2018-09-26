/****************************************************
			STAGE_EMAIL.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------
version="1.0.1"
Last Update: September 6, 2018               
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
	September 6,2018 - v1.0.1 - add WHERE clause, comments
------------------------------------------------------
TODO:
	
****************************************************/
SELECT
	RTRIM(CONVERT(CHAR(15), primaryemail.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(254), primaryemail.p_email_address)) AS "EMAILADDRESS",
	1 AS "EMAILCODE",
	1 AS "PRIORITY",
	CONVERT(char(10), GetDate(),126) AS '~UPDATEDATE~' -- YYYY-MM-DD
FROM
	vw_customer primaryemail
WHERE 
	(primaryemail.p_email_address LIKE '%@%' AND primaryemail.p_email_address LIKE '%.%') -- email must have an '@' and '.' to be valid
	AND LEN(primaryemail.p_email_address) > 0 AND-- avoid empty emails
	primaryemail.Status = 'A' -- Only Active Accounts
UNION ALL
SELECT
	RTRIM(CONVERT(CHAR(15), secondaryemail.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(254), secondaryemail.s_email_address)) AS "EMAILADDRESS",
	1 AS "EMAILCODE",
	2 AS "PRIORITY",
	CONVERT(char(10), GetDate(),126) AS '~UPDATEDATE~' -- YYYY-MM-DD
FROM
	vw_customer secondaryemail
WHERE
	(secondaryemail.s_email_address LIKE '%@%'AND secondaryemail.s_email_address LIKE '%.%') -- email must have an '@' and '.' to be valid
	AND LEN(secondaryemail.s_email_address) > 0 AND -- avoid empty emails
	secondaryemail.Status <> 'A' -- Only active accounts
ORDER BY CUSTOMERID
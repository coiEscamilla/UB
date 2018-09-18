/****************************************************
			STAGE_PHONE.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
Last Update: August 15, 2018               
------------------------------------------------------
Purpose:
	Extract phone numbers from Inhance to place in
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
	Home phone number is primary phone number from Inhance
	Cell phone number is secondary phne number from Inhance
	Work phone number will be last
------------------------------------------------------
HISTORY:
	August 15, 2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:
	
****************************************************/
SELECT
	'~' + LEFT(home.customer_id,15) + '~' AS '~CUSTOMERID~',
	LEFT(REPLACE(home.HomePhoneNumber,' ', ''),10) AS '~PHONENUMBER~',
	1 AS '~PHONETYPE~',
    '~PHONEEXT~' =  SUBSTRING(HomePhoneNumber, 11, LEN(HomePhoneNumber)) ,                                     
	'~' + LEFT(REPLACE(home.FirstNameFirst,',',''),30) + '~' AS '~CONTACT~',
	'~' + home.Title + '~' AS '~TITLE~',
	1 AS '~PRIORITY~',
	CONVERT(char(10), GetDate(),126) AS '~UPDATEDATE~'
FROM 
	vw_customer home
WHERE 
	home.HomePhoneNumber IS NOT NULL AND
	LEN(home.HomePhoneNumber) > 9
UNION ALL 

SELECT
	'~' + LEFT(cell.customer_id,15) + '~' AS '~CUSTOMERID~',
	LEFT(REPLACE(cell.cell_phone_num, ' ', ''),10) AS '~PHONENUMBER~',
	2 AS '~PHONETYPE~',
	'~PHONEEXT~' =  SUBSTRING(cell_phone_num, 11, LEN(cell_phone_num)) , 
	'~' + LEFT(REPLACE(cell.FirstNameFirst,',',''),30) + '~' AS '~CONTACT~',
	'~' + cell.Title + '~' AS '~TITLE~',
	1 AS '~PRIORITY~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM
	vw_customer cell
WHERE
	cell.cell_phone_num IS NOT NULL AND
	LEN(cell.cell_phone_num) > 9 
UNION ALL

SELECT
	'~' + LEFT(work.customer_id,15) + '~' AS '~CUSTOMERID~',
	LEFT(REPLACE(work.WorkPhoneNumber, ' ', ''), 10) AS '~PHONENUMBER~',
	3 AS '~PHONETYPE~',
    '~PHONEEXT~' =  SUBSTRING(WorkPhoneNumber, 11, LEN(WorkPhoneNumber)) , 
	'~' + LEFT(REPLACE(work.FirstNameFirst,',',''),30) + '~'   AS '~CONTACT~',
	'~' + work.Title + '~' AS '~TITLE~',
	1 AS '~PRIORITY~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM vw_customer work
WHERE
	work.WorkPhoneNumber IS NOT NULL AND
	LEN(work.WorkPhoneNumber) > 9
ORDER BY [~CUSTOMERID~]
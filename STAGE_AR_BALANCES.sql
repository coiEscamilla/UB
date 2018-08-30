/****************************************************
			STAGE_AR_BALANCES.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
LaSt Update: August 29, 2018               


------------------------------------------------------
Purpose:
	Extract accounts receivable balances from Inhance to place in
	a staging table for Systems & Software enQuesta v6   
	                         
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	Export results set AS a CSV file. Include headers.
	With your text editor, replace the "~" with a single
	double-quote (") so CSV will know what is a string

	Designed to be exported as a .CSV
------------------------------------------------------
Details:
	APPLICATION 
		1-Electric
		2-Rental
		3-Water
		4-Sewer
		5-Gas
		6-Refuse
		8-Drainage
------------------------------------------------------
HISTORY:
	August 29,2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	'~' + LEFT(balance.customer_id,15) + '~' AS '~CUSTOMERID~',
	'~' + LEFT(locationMaint.location_id,15) + '~' AS '~LOCATIONID~',
	'~APPLICATION~' =
		CASE
			WHEN balance.description LIKE '%Energy%' THEN 1
			WHEN balance.description LIKE '%Sewer%' THEN 4
			WHEN balance.description LIKE '%Sanitation%' THEN 6
			ELSE 3
		END,
	CONVERT(CHAR(10),customerMaint.bill_due_dt, 126) AS '~BALANCEDATE~', -- YYYY-MM-DD
	CONVERT(DECIMAL(11,2),balance.Balance) AS 'BALANCE',
	'' AS '~RECEIVABLECODE~',
	CONVERT(CHAR(10),GETDATE(), 126) AS '~UPDATEDATE~' -- YYYY-MM-DD 
FROM vw_cust_bal balance
JOIN
	ub_vw_location_maint locationMaint
ON
	balance.customer_id = locationMaint.customer_id
JOIN
	ub_vw_customer_maint customerMaint
ON
	balance.customer_id = customerMaint.customer_id
ORDER BY [~CUSTOMERID~], [~LOCATIONID~]
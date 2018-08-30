/****************************************************
			STAGE_FLAT_SVCS.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
LASt Update: August 22, 2018               


------------------------------------------------------
Purpose:
	Extract Flate Rate Services from Inhance to place in
	a staging table for Systems & Software enQuesta v6   
	                         
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	Export results set AS a CSV file. Include headers.
	With your text editor, replace the "~" with a single
	double-quote (") so CSV will know what is a string

	Designed to be exported AS a .CSV
------------------------------------------------------
ASsumptions:
	
------------------------------------------------------
HISTORY:
	August 22,2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' AS '~CUSTOMERID~',
	'~'+ LEFT(meterMaint.location_id, 15) + '~' AS '~LOCATIONID~',
	3 AS '~APPLICATION~',
	99 AS '~ITEMCODE~',
	'~SERVICESTATUS~' = 
		CASE
			WHEN customer.status = 'A' THEN 0
			ELSE 1
		END,
	CONVERT(char(10), customer.CreateDate, 126) as '~INITIALSERVICEDATE~',
	'' AS '~BILLINGSTARTDATE~',
	'' AS '~BILLINGSTOPDATE~',
	99 AS '~BILLINGDRIVERRATE~',
	99 AS '~BILLINGFLATRATE~',
	99 AS '~SALESREVENUECLASS~',
	1  AS '~NUMBEROFITEMS~',
	'' AS '~SERIALNUMBER~',
	99 AS '~ITEMMAKE~',
	99 AS '~ITEMTYPE~',
	99 AS '~ITEMMODEL~',
	CONVERT(CHAR(10),GETDATE(), 126) AS '~UPDATEDATE~'
FROM 
	vw_customer customer
JOIN
	ub_vw_meter_maint meterMaint
ON 
	meterMaint.customer_id = customer.customer_id
WHERE
	meterMaint.location_id <> 1
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
	With your text editor, replace the "" with a single
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
	RTRIM(CONVERT(CHAR(15), customer.customer_id)) AS 'CUSTOMERID',
	RTRIM(CONVERT(CHAR(15), locationMaint.location_id)) AS 'LOCATIONID',
	3 AS "APPLICATION",
	rates.Application as 'ITEMCODE',
	'SERVICESTATUS' = 
		CASE
			WHEN customer.status = 'A' THEN 0
			ELSE 1
		END,
	CONVERT(char(10), customer.CreateDate, 126) as 'INITSERVICEDATE',
	'' AS 'BILLINGSTARTDATE',
	'' AS 'BILLINGSTOPDATE',
	CAST (rates.enQuesta_Rate_Driver AS INT) AS 'BILLINGDRIVERRATE',
	CAST (rates.enQuesta_Flat_Rate AS INT) AS 'BILLINGFLATRATE',
	'SALESREVENUECLASS' =
		CASE
			WHEN rates.Sales_Class = 'n/a' THEN 99 
			ELSE rates.Sales_Class
		END,
	'NUMBEROFITEMS' = 
		CASE
			WHEN locationMaint.residents > 1 THEN locationMaint.residents --multiply rates by number of residents
			ELSE 1 --Default to 1
		END,
	'' AS 'SERIALNUMBER',
	NULL AS 'ITEMMAKE',
	NULL AS 'ITEMTYPE',
	NULL AS 'ITEMMODEL',
	CONVERT(CHAR(10),GETDATE(), 126) AS 'UPDATEDATE'
FROM 
	vw_customer customer
JOIN
	ub_vw_location_maint locationMaint
ON 
	locationMaint.customer_id = customer.customer_id
JOIN
	vw_income income
ON
	income.location_id = locationMaint.location_id
JOIN
	SS_Rates_flatFile rates
ON
	income.RateCode = rates.Irving_Rate
WHERE
	locationMaint.location_id <> 1 -- Avoud warehouse rates
	AND rates.enQuesta_Flat_Rate <> 'n/a' -- Only flat rates
ORDER BY CUSTOMERID
/****************************************************
			STAGE_METERED_SVCS.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.1"
Last Update: August 27, 2018               


------------------------------------------------------
Purpose:
	Extract Metered Services from Inhance to place in
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
	APPLICATION will always be 3-Water since we bill
	water and sewage based off of water user

	SERVICETYPE
		Water Service #	| Service Description
		[0 | Normal/Domestic]
		[1 | Water Only]
		[2 | Subtraction Meter]
		[3 | Read Only]
		[4 | Fireline]
		[5 |Irrigation]
		[6 | Hydrant]
		[7 | Detector]
	Most accounts will be Normal/Domestic. 
------------------------------------------------------
HISTORY:
	August 21, 2018 - v1.0.0 - First Creation
	August 27, 2018 - v1.0.1 - Added service type logic
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' as '~CUSTOMERID~',
	'~'+ LEFT(meterMaint.location_id, 15) + '~' as '~LOCATIONID~',
	3 as '~APPLICATION~', --1-Electric, 3-Water, 4-Sewer,5-Gas
	'~SERVICETYPE~' =
		CASE
			WHEN meterMaint.alt_sort_value LIKE '%DETECTOR%' THEN 7
			WHEN meterMaint.alt_sort_value LIKE '%IRR%' THEN 5
			WHEN meterMaint.alt_sort_value LIKE '%HYDRANT%' THEN 6
			ELSE 0 -- Default to 0, or "Normal/Domestic"
		END,
	'~'+LEFT(meterMaint.meter_num, 12) + '~' as '~METERNUMBER~',
	1 AS '~METERREGISTER~',
	'~SERVICESTATUS~' = 
		CASE
			WHEN locationMaint.status = 'A' THEN 0
			ELSE 1
		END,
	CONVERT(char(10), meterMaint.install_dt, 126) as '~INITIALSERVICEDATE~',
	CONVERT(char(10),meterMaint.install_dt, 126) as '~BILLINGSTARTDATE~',
	1 AS '~BILLINGRATE~',
	99 as '~SALESCLASS~',
	0 AS '~READSEQUENCE~',
	NULL as '~LASTREADDATE~',
	1.00 as '~MULTIPLIER~',
	meterMaint.latitude as '~LATITUDE~',
	meterMaint.longitude as '~LONGITUDE~',
	'~'+''+'~' as '~HHCOMMENTS~',
	'~'+''+'~' as '~SERVICECOMMENTS~',
	'~'+''+'~' as '~STOPESTIMATE~',
	'' as '~LOCATIONCODE~',
	'' as '~INSTRUCTIONCODE~',
	'~'+''+'~' as '~TAMPERCODE~',
	'' as 'AWCVALUE',
	CONVERT(char(10),GETDATE(), 126) as '~UPDATEDATE~'
FROM 
	vw_customer customer
JOIN
	ub_vw_meter_maint meterMaint
ON 
	meterMaint.customer_id = customer.customer_id
JOIN
	ub_vw_location_maint locationMaint
ON
	customer.customer_id = locationMaint.customer_id
WHERE
	locationMaint.status = 'A' AND
	locationMaint.location_id <> 1
--ORDER BY
--	customer.customer_id
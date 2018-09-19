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

	Export results set AS a CSV file. Include headers.
	With your text editor, replace the "~" with a single
	double-quote (") so CSV will know what is a string

	Designed to be exported AS a .CSV
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
	September 18, 2018 - v1.0.2 - Added GIS data,
	SERVICESTATUS, and REMOVEDDATE
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' AS '~CUSTOMERID~',
	'~'+ LEFT(meterMaint.location_id, 15) + '~' AS '~LOCATIONID~',
	3 AS '~APPLICATION~', --1-Electric, 3-Water, 4-Sewer,5-Gas
	1 AS '~SERVICENUMBER~',
	'~SERVICETYPE~' =
		CASE
			WHEN meterMaint.alt_sort_value LIKE '%DETECTOR%' THEN 7
			WHEN meterMaint.alt_sort_value LIKE '%IRR%' THEN 5
			WHEN meterMaint.alt_sort_value LIKE '%HYDRANT%' THEN 6
			ELSE 0 -- Default to 0, or "Normal/Domestic"
		END,
	'~'+LEFT(meterMaint.meter_num, 12) + '~' AS '~METERNUMBER~',
	1 AS '~METERREGISTER~',
	'~SERVICESTATUS~' = 
		CASE -- TODO: Verify this logic
			WHEN customer.Status = 'I' THEN 1 -- Service Off, meter is present (assumption)
			WHEN meter.Removed IS NOT NULL THEN 2 --Service Off (meter has been removed)
			ELSE 0 -- Service is On
		END,
	CONVERT(char(10), meterMaint.install_dt, 126) AS '~INITIALSERVICEDATE~',
	CONVERT(char(10),meterMaint.install_dt, 126) AS '~BILLINGSTARTDATE~',
	1 AS '~BILLINGRATE~',
	99 AS '~SALESCLASS~',
	0 AS '~READSEQUENCE~',
	CONVERT(DECIMAL(12,3),meter.CurrentReading) AS '~LASTREADING~', -- current reading is latest
	CONVERT(CHAR(10), meter.CurrentReadDate, 126) AS '~LASTREADDATE~',
	1.00 AS '~MULTIPLIER~',
	gisMeter._LATITUDE_ AS '~LATITUDE~',
	gisMeter._LONGITUDE_ AS '~LONGITUDE~',
	'~'+ LEFT(REPLACE(REPLACE(routeComment.route_comment,',',''),'"', ''),80) +'~' AS '~HHCOMMENTS~', --- ub_route_comment by ID
	'~'+''+'~' AS '~SERVICECOMMENTS~',
	'~'+''+'~' AS '~STOPESTIMATE~',
	'' AS '~LOCATIONCODE~',
	'' AS '~INSTRUCTIONCODE~',
	'~'+''+'~' AS '~TAMPERCODE~',
	'' AS 'AWCVALUE',
	CONVERT(CHAR(10),GETDATE(), 126) AS '~UPDATEDATE~',
	CONVERT(CHAR(10), meter.Removed, 126) AS '~REMOVEDDATE~'
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
JOIN
	vw_meter meter
ON
	meter.meter_id = meterMaint.meter_id AND
	meter.location_id = meterMaint.location_id
LEFT JOIN 
	SS_GIS_Meter gisMeter
ON  -- Grab LAT/LONG values if they exist
	meter.location_id = gisMeter._UB_LOCATION_ID_
LEFT JOIN 
	ub_route_comment routeComment
ON -- Grab meter comments on the location if they exist
	locationMaint.route_comment_id = routeComment.route_comment_id 
WHERE
	locationMaint.location_id <> 1 -- Avoidd warehouse meters
ORDER BY [~CUSTOMERID~], [~LOCATIONID~]
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
	With your text editor, replace the "" with a single
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
-- Grab Compound Meters from inhance
-- Compound meters are meters with a prevailing zero and the exact same meter number
WITH cte_compoundMeters
AS (
	SELECT location_id
		,meternumber
	FROM (
		SELECT location_id
			,Substring(meter_num, Patindex('%[^0]%', meter_num), Len(meter_num)) AS 'METERNUMBER'
		FROM ub_vw_meter_maint
		WHERE location_id IN (
				SELECT locationid
				FROM (
					SELECT location_id AS 'LOCATIONID'
						,Count(meter_num) AS 'MeterCount'
					FROM ub_vw_meter_maint
					WHERE location_id <> 1
					GROUP BY location_id
					) x
				WHERE metercount > 1
				)
		) y
	GROUP BY location_id
		,METERNUMBER
	HAVING Count(*) > 1
	),
	-- Create service numbers for multiple meters on the same location
	cte_serviceNumber
	AS(
		SELECT location_id
			,meter_num
			,ROW_NUMBER() OVER(PARTITION BY location_id ORDER BY meter_num ASC) AS 'SERVICENUMBER'
		FROM ub_vw_meter_maint
		WHERE location_id <> 1 -- Avoid warehouse meters
	)

SELECT DISTINCT RTRIM(CONVERT(VARCHAR(15), customer.customer_id)) AS 'CUSTOMERID'
	,RTRIM(CONVERT(CHAR(15), meterMaint.location_id)) AS 'LOCATIONID'
	,3 AS 'APPLICATION' --1-Electric, 3-Water, 4-Sewer,5-Gas
	,cte_serviceNumber.SERVICENUMBER AS 'SERVICENUMBER'
	,'SERVICETYPE' = CASE 
		WHEN meterMaint.alt_sort_value LIKE '%DETECTOR%'
			THEN 7
		WHEN meterMaint.alt_sort_value LIKE '%IRR%'
			THEN 5
		WHEN meterMaint.alt_sort_value LIKE '%HYDRANT%'
			THEN 6
		ELSE 0 -- Default to 0, or "Normal/Domestic"
		END
	,'METERNUMBER' = CASE 
		WHEN cte_compoundMeters.METERNUMBER IS NULL
			THEN RTRIM(CONVERT(CHAR(12), meterMaint.meter_num))
		ELSE Substring(meterMaint.meter_num, Patindex('%[^0]%', meterMaint.meter_num), 15) -- We need the meter numbers to be the same for a compound meter so drop prevailing '0'
		END
	,'METERREGISTER' = CASE 
		WHEN meterMaint.meter_num = cte_compoundMeters.METERNUMBER
			THEN 1 --TODO: figure out whcih is hi/lo side of pipe
		WHEN meterMaint.meter_num = ('0' + cte_compoundMeters.METERNUMBER)
			THEN 2
		ELSE 1
		END
	,'SERVICESTATUS' = CASE -- TODO: Verify this logic
		WHEN customer.STATUS = 'I'
			THEN 1 -- Service Off, meter is present (assumption)
		WHEN meterMaint.remove_dt IS NOT NULL
			THEN 2 --Service Off (meter has been removed)
		ELSE 0 -- Service is On
		END
	,CONVERT(CHAR(10), meterMaint.install_dt, 126) AS 'INITIALSERVICEDATE'
	,CONVERT(CHAR(10), meterMaint.install_dt, 126) AS 'BILLINGSTARTDATE'
	,rates.enQuesta_Rate AS 'BILLINGRATE'
	,rates.SS_Sales_Class AS 'SALESCLASS'
	,0 AS 'READSEQUENCE'
	,CONVERT(DECIMAL(12, 3), meter.CurrentReading) AS 'LASTREADING'
	,-- current reading is latest
	CONVERT(CHAR(10), meter.CurrentReadDate, 126) AS 'LASTREADDATE'
	,1.00 AS 'MULTIPLIER'
	,gisMeter._LATITUDE_ AS 'LATITUDE'
	,gisMeter._LONGITUDE_ AS 'LONGITUDE'
	,RTRIM(CONVERT(CHAR(80), routeComment.route_comment)) AS 'HHCOMMENTS'
	,'' AS 'SERVICECOMMENTS'
	,'' AS 'STOPESTIMATE'
	,'' AS 'LOCATIONCODE'
	,'' AS 'INSTRUCTIONCODE'
	,'' AS 'TAMPERCODE'
	,'' AS 'AWCVALUE'
	,CONVERT(CHAR(10), GETDATE(), 126) AS 'UPDATEDATE'
	,CONVERT(CHAR(10), meterMaint.remove_dt, 126) AS 'REMOVEDDATE'
FROM vw_customer customer
INNER JOIN ub_vw_meter_maint meterMaint ON meterMaint.customer_id = customer.customer_id
INNER JOIN vw_meter meter ON meterMaint.location_id = meter.location_id
	AND meter.MeterNumber = meterMaint.meter_num
INNER JOIN ub_vw_location_maint locationMaint ON customer.customer_id = locationMaint.customer_id
INNER JOIN vw_income income ON income.location_id = meterMaint.location_id
INNER JOIN SS_Rates_flatFile rates ON rates.Irving_Rate = income.RateCode
INNER JOIN cte_serviceNumber ON cte_serviceNumber.location_id = meterMaint.location_id
	AND cte_serviceNumber.meter_num = meterMaint.meter_num
LEFT JOIN oasis_test_User.SS_GIS_Meter gisMeter ON -- Grab LAT/LONG values if they exist
	meterMaint.location_id = gisMeter._UB_LOCATION_ID_
LEFT JOIN ub_route_comment routeComment ON -- Grab meter comments on the location if they exist
	locationMaint.route_comment_id = routeComment.route_comment_id
LEFT JOIN cte_compoundMeters ON cte_compoundMeters.location_id = meterMaint.location_id
WHERE locationMaint.location_id <> 1 -- Avoid warehouse meters
	AND meter.CurrentReadDate > DATEADD(YEAR, -1, GETDATE()) -- Only data from the last year
ORDER BY [CUSTOMERID]
	,[LOCATIONID]
	,[APPLICATION]
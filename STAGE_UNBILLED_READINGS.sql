/****************************************************
			STAGE_UNBILLED_READINGS.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
LaSt Update: August 22, 2018               


------------------------------------------------------
Purpose:
	Extract Unbilled Readings from Inhance to place in
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
	Will always be 3 for water, although we 
	bill for sewage, we have no sewage meters in Inhance
		1 - Electric
		3 - Water
		4 - Sewage
		5 - Gas

	READCODE
		2  - Regular Read
		10 - Removal Reading
		11 - Final Reading

	READTYPE
		0 - Actual Read
		1 - Estimated Read
------------------------------------------------------
HISTORY:
	August 22,2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	'~'+ LEFT(customerMaint.customer_id, 15) + '~' AS '~CUSTOMERID~',
	'~'+ LEFT(meter.location_id, 15) + '~' AS '~LOCATIONID~',
	3 AS '~APPLICATION~',
	'~'+LEFT(meterMaint.meter_num, 12) + '~' AS '~METERNUMBER~',
	1 AS '~METERREGISTER~',
	2 AS '~READINGCODE~', 
	'~READINGTYPE~' = 
		CASE
			WHEN reading.Estimated LIKE '%N%' THEN 0 -- 'N' is an Actual Read
			ELSE 1                                   -- 'Y' is Estimated Read
		END,
	CONVERT(CHAR(10), meter.CurrentReadDate, 126) AS '~CURRREADDATE~',
	CONVERT(CHAR(10), meterRead.prev_dt, 126) AS '~PREVREADDATE~',
	CONVERT(DECIMAL(12,3),meter.CurrentReading) AS '~CURRREADING~',
	CONVERT(DECIMAL(12,3),(meter.CurrentReading - meter.CurrentUsage))  AS '~PREVREADING~', -- subtract the usage from the current reading to get the last reading
	'GAL' AS '~UNITOFMEASURE~',
	CONVERT(DECIMAL(12,3),meter.CurrentUsage) AS '~RAWUSAGE~',
	CONVERT(DECIMAL(12,3),(meter.CurrentUsage * meter.UsageMultiplier)) AS '~BILLINGUSAGE~',
	meter.ReadingMultiplier AS '~METERMULTIPLIER~',
	'~' + '' + '~' AS '~READERID~',
	CONVERT(CHAR(10),GETDATE(), 126) AS '~UPDATEDATE~' -- YYYY-MM-DD 

FROM 
	ub_vw_customer_maint customerMaint
JOIN
	ub_vw_meter_maint meterMaint
ON 
	meterMaint.customer_id = customerMaint.customer_id
JOIN
	vw_meter meter
ON
	meterMaint.meter_id = meter.meter_id AND
	meterMaint.location_id = meter.location_id
LEFT JOIN
	vw_reading reading
ON
	meter.meter_id = reading.meter_id AND
	meter.location_id = reading.location_id
JOIN 
	ub_meter_read meterRead
ON
	meter.meter_id = meterRead.meter_id AND
	meter.location_id = meterRead.location_id AND
	meter.CurrentReadDate = meterRead.read_dt
WHERE
	meter.location_id <> 1 AND          -- Avoid warehouse meters
	customerMaint.Status= 'A' AND       -- Only active accounts
	customerMaint.bill_due_dt IS NULL   -- We only want unbilled readings, TODO: check with Caleb
ORDER BY [~CUSTOMERID~],[~LOCATIONID~]
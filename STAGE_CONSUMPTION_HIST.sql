/****************************************************
			STAGE_CONSUMPTION_HIST.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.1"
Last Update: September 26, 2018               
------------------------------------------------------
Purpose:
	Extract consumption history from Inhance to place
	in a staging table for Systems & Software enQuesta v6                        
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	Export results set as a CSV file. Include headers.
	With your text editor, replace the "~" with a single
	double-quote (") so CSV will know what is a string

	With your text editor, replace the 'NULL' values with 
	an empty string so CSV will know what is a number

	Designed to be exported as a .CSV
------------------------------------------------------
Assumptions:
	
------------------------------------------------------
HISTORY:
	September 11, 2018 - v1.0.0  - First Creation
	September 26, 2018 - v1.0.1 - added service number field
------------------------------------------------------
TODO:
	
****************************************************/
with cte_billedDates as(
	SELECT 
		customer_id,
		location_id
	from 
		vw_trans_charges
)


SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' as '~CUSTOMERID~',
	'~'+ LEFT(meterMaint.location_id, 15) + '~' as '~LOCATIONID~',
	1 AS '~APPLICATION~', --1-Electric, 3-Water, 4-Sewer,5-Gas
	ROW_NUMBER() OVER(PARTITION BY meterMaint.location_id ORDER BY meterMaint.meter_num ASC) AS '~SERVICENUMBER~', -- If we have multiple meters at each location, assign them an incremental service number
	'~' + meterMaint.meter_num + '~' AS '~METERNUMBER~',
	meterMaint.alt_met_num AS '~METERREGISTER~',
	2 AS '~READINGCODE~',
	'~READINGTYPE~' = 
		CASE
			WHEN meterReading.Estimated LIKE '%N%' THEN 0 -- 'N' is an Actual Read
			ELSE 1                                   -- 'Y' is an Estimated Read
		END,
	CONVERT(CHAR(10), reading.ReadDate, 126) AS '~CURRREADING~',
	CONVERT(CHAR(10), meterReading.prev_dt, 126) AS '~PREVREADDATE~',
	reading.Reading AS '~CURREADING~',
	(reading.Reading - reading.Usage) AS '~PREVREADING~',
	'~GAL~' AS '~UNITOFMEASURE~',
	reading.Usage AS '~RAWUSAGE~',
	NULL AS '~BILLINGUSAGE~',
	1.0 AS '~METERMULTIPLIER~',
	charges.TransactionDate AS '~BILLEDDATE~',
	NULL AS '~THERMFACTOR~',
	'~~' AS '~READERID~',
	NULL AS '~BILLEDAMOUNT~',
	NULL AS '~BILLINGBATCHNUMBER~',
	99 AS '~BILLINGRATE~',
	99 AS '~SALESREVENUECLASS~',
	NULL AS '~HEATINGDEGREEDAYS~',
	NULL AS '~COOLINGDEGREEDAYS~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM 
	ub_vw_meter_maint meterMaint
JOIN
	vw_customer customer
ON
	customer.customer_id = meterMaint.customer_id
JOIN
	vw_reading reading
ON
	reading.location_id = meterMaint.location_id AND
	reading.meter_id = meterMaint.meter_id
JOIN
	ub_meter_read meterReading
ON
	meterReading.location_id = meterMaint.location_id  AND
	meterReading.meter_id = meterMaint.meter_id AND
	meterReading.read_dt = reading.ReadDate -- We only want the latest record from this ub_meter_read table
JOIN
	vw_trans_charges charges
ON
	charges.customer_id = customer.customer_id AND
	charges.location_id = meterMaint.location_id
WHERE
	meterMaint.location_id <> 1 -- Avoid warehouse meters
ORDER BY [~CUSTOMERID~],[~LOCATIONID~]
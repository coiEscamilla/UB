/****************************************************
			STAGE_CONSUMPTION_HIST.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
Last Update: September 11, 2018               
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
------------------------------------------------------
TODO:
	
****************************************************/
SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' as '~CUSTOMERID~',
	'~'+ LEFT(meterMaint.location_id, 15) + '~' as '~LOCATIONID~',
	3 as '~APPLICATION~', --1-Electric, 3-Water, 4-Sewer,5-Gas
	'~' + meterMaint.meter_num + '~' AS '~METERNUMBER~',
	meterMaint.alt_met_num AS '~METERREGISTER~',
	2 AS '~READINGCODE~',
	'~READTYPE~' = 
		CASE
			WHEN reading.Estimated LIKE '%N%' THEN 0 -- 'N' is an Actual Read
			ELSE 1                                   -- 'Y' is an Estimated Read
		END,
	reading.read_dt AS '~CURREADDATE~',
	reading.prev_dt AS '~PREVREADDATE~',
	reading.reading AS '~CURREADING~',
	NULL AS '~PREVREADING~',
	NULL AS '~RAWUSAGE~',
	NULL AS '~BILLINGUSAGE~',
	NULL AS '~METERMULTIPLIER~',
	NULL AS '~BILLEDDATE~',
	NULL AS '~THERMFACTOR~',
	'~~' AS '~READERID~',
	NULL AS '~BILLEDAMOUNT~',
	NULL AS '~BILLINGBATCHNUMBER~',
	NULL AS '~BILLINGRATE~',
	NULL AS '~SALESREVENUECLASS~',
	NULL AS '~HEATINGDEGREEDAYS~',
	NULL AS '~COOLINGDEGREEDAYS~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM 
	ub_vw_meter_maint meterMaint
JOIN
	vw_customer customer
ON
	meterMaint.customer_id = customer.customer_id
JOIN
	ub_meter_read reading
ON
	meterMaint.location_id = reading.location_id AND
	meterMaint.meter_id = reading.meter_id
WHERE
	meterMaint.location_id <> 1
ORDER BY [~CUSTOMERID~]
	
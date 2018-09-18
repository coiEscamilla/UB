/****************************************************
			STAGE_DEVICE.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
Last Update: September 10, 2018               
------------------------------------------------------
Purpose:
	Extract devices from Inhance to place in
	a staging table for Systems & Software enQuesta v6   
	
	Devices include Meters, Registers, and ERTs	                         
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	The SS_Meters table is a flat file CSV export created 
	by Dan McMahon. We'll use this table as a device lookup
	since Inhance is missing this information. This CSV 
	and table are subject to change.

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
	September 10, 2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:
	
****************************************************/

-- ERT Query
SELECT DISTINCT
	3 AS '~APPLICATION~',
	2 AS '~DEVICETYPE~', -- 2=ERT
	'~' + LEFT(meter.SerialNumber,12) + '~' AS '~METERNUMBER~',
	1 AS '~REGISTERNUM~',
	301 AS '~BUILTCONFIG~',
	301 AS '~INSTALLCONFIG~',
	'~Y~' AS '~BILLEDFLAG~',
	1 AS '~REGISTERCONFIG~',
	'~' + LEFT(meter.SerialNumber,12) + '~' AS '~SERIALNUMBER~',
	NULL AS '~OTHERDEVICETYPE1~',
	NULL AS '~OTHERDEVICEID1~',
	'~N~' AS '~OTHERDEVICEMARRY1~',
	NULL AS '~OTHERDEVICETYPE2~',
	NULL AS '~OTHERDEVICEID2~',
	'~N~' AS '~OTHERDEVICEMARRY2~',	
	NULL AS '~METERMAKE~',
	NULL AS '~METERSIZE~',
	NULL AS '~METERKIND~',
	NULL AS '~METERMODEL~',
	NULL AS '~DIALS~',
	NULL AS '~DEADZEROES~',
	NULL AS '~READTYPE~',
	NULL AS '~TESTCIRCLE~',
	NULL AS '~AMPS~',
	NULL AS '~VOLTS~',
	NULL AS '~FLEXFIELD1~',
	NULL AS '~FLEXFIELD2~',
	NULL AS '~FLEXFIELD3~',
	CONVERT(CHAR(10), meter.Installed, 126) AS '~INITIALINSTALLDATE~', -- YYYY-MM-DD
	CONVERT(CHAR(10), meter.Installed, 126) AS '~CURRENTINSTALLDATE~', -- YYYY-MM-DD
	NULL AS '~MULTIPLIER~',
	NULL AS '~CTNUMBER~',
	NULL AS '~VTNUMBER~',
	NULL AS '~PONUMBER~',
	NULL AS '~PODATE~',
	NULL AS '~PURCHASECOST~',
	CONVERT(CHAR(10), meter.Removed, 126) AS '~RETIREDATE~', -- YYYY-MM-DD
	NULL AS '~ASSETTAXDISTRICT~',
	'~~' AS '~BIDIRECTIONALFLAG~',
	'~~' AS '~PRIVATELYOWNED~',
	'~' + LEFT(REPLACE(REPLACE(meter.MeterLocation, ',',''),'"', ''),50) + '~' AS '~COMMENTS~',
	NULL AS '~BATTERYDATE~',
	NULL AS '~AMIFLAG~',
	NULL AS '~AMITYPE~',
	NULL AS '~IPADDRESS~',
	'~~' AS '~PROBEMETERID~',
	'~~' AS '~PROBEMETERPASSWORD~',
	'~~' AS '~PROBEMETERNAME~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM 
	vw_meter meter
WHERE 
	meter.SerialNumber IS NOT NUlL AND meter.location_id <> 1
UNION ALL

-- Register Query
SELECT DISTINCT
	3 AS '~APPLICATION~',
	1 AS '~DEVICETYPE~', -- 1 = Regster 
	'~' + LEFT(meter.AlternateMeterNumber,12) + '~' AS '~METERNUMBER~',
	1 AS '~REGISTERNUM~',
	301 AS '~BUILTCONFIG~',
	301 AS '~INSTALLCONFIG~',
	'~Y~' AS '~BILLEDFLAG~',
	1 AS '~REGISTERCONFIG~',
	'~' + LEFT(meter.AlternateMeterNumber,12) + '~' AS '~SERIALNUMBER~',
	NULL AS '~OTHERDEVICETYPE1~',
	NULL AS '~OTHERDEVICEID1~',
	'~N~' AS '~OTHERDEVICEMARRY1~',
	NULL AS '~OTHERDEVICETYPE2~',
	NULL AS '~OTHERDEVICEID2~',
	'~N~' AS '~OTHERDEVICEMARRY2~',
	NULL AS '~METERMAKE~',
	NULL AS '~METERSIZE~',
	NULL AS '~METERKIND~',
	NULL AS '~METERMODEL~',
	NULL AS '~DIALS~',
	NULL AS '~DEADZEROES~',
	NULL AS '~READTYPE~',
	NULL AS '~TESTCIRCLE~',
	NULL AS '~AMPS~',
	NULL AS '~VOLTS~',
	NULL AS '~FLEXFIELD1~',
	NULL AS '~FLEXFIELD2~',
	NULL AS '~FLEXFIELD3~',
	CONVERT(CHAR(10), meter.Installed, 126) AS '~INITIALINSTALLDATE~',
	CONVERT(CHAR(10), meter.Installed, 126) AS '~CURRENTINSTALLDATE~',
	NULL AS '~MULTIPLIER~',
	NULL AS '~CTNUMBER~',
	NULL AS '~VTNUMBER~',
	NULL AS '~PONUMBER~',
	NULL AS '~PODATE~',
	NULL AS '~PURCHASECOST~',
	CONVERT(CHAR(10), meter.Removed, 126) AS '~RETIREDATE~',
	NULL AS '~ASSETTAXDISTRICT~',
	'~~' AS '~BIDIRECTIONALFLAG~',
	'~~' AS '~PRIVATELYOWNED~',
	'~' + LEFT(REPLACE(REPLACE(meter.MeterLocation, ',',''),'"', ''),50) + '~' AS '~COMMENTS~',
	NULL AS '~BATTERYDATE~',
	NULL AS '~AMIFLAG~',
	NULL AS '~AMITYPE~',
	NULL AS '~IPADDRESS~',
	'~~' AS '~PROBEMETERID~',
	'~~' AS '~PROBEMETERPASSWORD~',
	'~~' AS '~PROBEMETERNAME~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM 
	vw_meter meter
WHERE 
	meter.AlternateMeterNumber IS NOT NULL AND meter.location_id <> 1
UNION ALL

-- Meter Query
SELECT DISTINCT
	3 AS '~APPLICATION~',
	0 AS '~DEVICETYPE~', -- 0 = Meter
	'~' + LEFT(meter.MeterNumber,12) + '~' AS '~METERNUMBER~',
	1 AS '~REGISTERNUM~',
	301 AS '~BUILTCONFIG~',
	301 AS '~INSTALLCONFIG~',
	'~Y~' AS '~BILLEDFLAG~',
	1 AS '~REGISTERCONFIG~',
	'~' + LEFT(meter.MeterNumber, 12) + '~' AS '~SERIALNUMBER~',
	'~OTHERDEVICETYPE1~' = 
		CASE -- Check to see if this meter has a register
			WHEN meter.AlternateMeterNumber IS NULL THEN NULL
			WHEN LEN(meter.AlternateMeterNumber) < 1 THEN NULL
			ELSE 1
		END,
	'~' + LEFT(meter.AlternateMeterNumber,12) + '~' AS '~OTHERDEVICEID1~',
	'~N~' AS '~OTHERDEVICEMARRY1~',
	'~OTHERDEVICETYPE2~' = 
		CASE -- Check to see if this meter has an ERT
			WHEN meter.SerialNumber IS NULL THEN NULL
			WHEN LEN(meter.SerialNumber) < 1 THEN NULL
			ELSE 2
		END,
	'~' + LEFT(meter.SerialNumber, 12) + '~' AS '~OTHERDEVICEID2~',
	'~N~' AS '~OTHERDEVICEMARRY2~',
	'~METERMAKE~' = 
		CASE
			WHEN deviceLookup.Make_ IS NULL THEN 99 -- Default
			ELSE deviceLookup.Make_
		END,
	'~METERSIZE~' = 
		CASE
			WHEN deviceLookup.Meter_Size_Index IS NULL THEN 12-- 12=VARIOUS in Device Config
			ELSE deviceLookup.Meter_Size_Index
		END,
	NULL AS '~METERKIND~',
	'~METERMODEL~' = 
		CASE  
			WHEN deviceLookup.meter_id_num IS NULL THEN 99 -- Default
			ELSE deviceLookup.meter_id_num END,
	'~DIALS~' = 
		CASE
			WHEN deviceLookup.Total_of_dials IS NULL THEN 9 -- Deafault
			ELSE deviceLookup.Total_of_dials
		END,
	'~DEADZEROES~' = 
		CASE
			WHEN deviceLookup.Dead_Zeros_S_S IS NULL THEN 0 -- Default
			ELSE deviceLookup.Dead_Zeros_S_S
		END,
	'~READTYPE~' = 
		CASE -- 'M' is a manual read, 'I' is an instrument read
			WHEN meter.Handheld ='M' THEN 0
			ELSE 1
		END,
	NULL AS '~TESTCIRCLE~',
	NULL AS '~AMPS~',
	NULL AS '~VOLTS~',
	NULL AS '~FLEXFIELD1~',
	NULL AS '~FLEXFIELD2~',
	NULL AS '~FLEXFIELD3~',
	CONVERT(CHAR(10), meter.Installed, 126) AS '~INITIALINSTALLDATE~',
	CONVERT(CHAR(10), meter.Installed, 126) AS '~CURRENTINSTALLDATE~',
	meter.ReadingMultiplier AS '~MULTIPLIER~',
	NULL AS '~CTNUMBER~',
	NULL AS '~VTNUMBER~',
	NULL AS '~PONUMBER~',
	NULL AS '~PODATE~',
	NULL AS '~PURCHASECOST~',
	CONVERT(CHAR(10), meter.Removed, 126) AS '~RETIREDATE~',
	NULL AS '~ASSETTAXDISTRICT~',
	'~~' AS '~BIDIRECTIONALFLAG~',
	'~~' AS '~PRIVATELYOWNED~',
	'~' + LEFT(REPLACE(REPLACE(meter.MeterLocation, ',',''),'"', ''),50) + '~' AS '~COMMENTS~',
	NULL AS '~BATTERYDATE~',
	'~AMIFLAG~' = 
		CASE --If we have a meter with a serial number, it's an AMI type
			WHEN LEN(meter.SerialNumber) = 0 THEN '~N~'
			ELSE '~Y~'	 
		END,
	NULL AS '~AMITYPE~',
	NULL AS '~IPADDRESS~',
	'~~' AS '~PROBEMETERID~',
	'~~' AS '~PROBEMETERPASSWORD~',
	'~~' AS '~PROBEMETERNAME~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM
	vw_meter meter
JOIN
	ub_vw_meter_maint meterMaint
ON -- Grab the Meter Maintenance table for the model_id field
	meterMaint.location_id = meter.location_id AND
	meterMaint.meter_id = meter.meter_id
LEFT JOIN
	oasis_test_User.SS_Meters deviceLookup
ON -- Grab SS_Meters as a device lookup for fields S&S enQuesta needs
	deviceLookup.model_id = meterMaint.model_id
	
WHERE
	meter.MeterNumber IS NOT NULL AND meter.location_id <> 1
ORDER BY [~DEVICETYPE~] DESC -- We need ERTs and Registers to be fed into the system first before meters

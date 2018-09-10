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
SELECT
	3 AS '~APPLICATION~',
	2 AS '~DEVICETYPE~', -- 2=ERT
	'~' + meter.SerialNumber + '~' AS '~METERNUMBER~',
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
	'~' + LEFT(meter.MeterLocation,50) + '~' AS '~COMMENTS~',
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
SELECT
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
	'~' + LEFT(meter.MeterLocation,50) + '~' AS '~COMMENTS~',
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
SELECT
	3 AS '~APPLICATION~',
	0 AS '~DEVICETYPE~', -- 0 = Meter
	'~' + LEFT(meter.MeterNumber,12) + '~' AS '~METERNUMBER~',
	1 AS '~REGISTERNUM~',
	301 AS '~BUILTCONFIG~',
	301 AS '~INSTALLCONFIG~',
	'~Y~' AS '~BILLEDFLAG~',
	1 AS '~REGISTERCONFIG~',
	'~' + LEFT(meter.MeterNumber, 12) + '~' AS '~SERIALNUMBER~',
	1 AS '~OTHERDEVICETYPE1~',
	'~' + LEFT(meter.AlternateMeterNumber,12) + '~' AS '~OTHERDEVICEID1~',
	'~N~' AS '~OTHERDEVICEMARRY1~',
	2 AS '~OTHERDEVICETYPE2~',
	'~' + LEFT(meter.SerialNumber, 12) + '~' AS '~OTHERDEVICEID2~',
	'~N~' AS '~OTHERDEVICEMARRY2~',
	NULL AS '~METERMAKE~',
	NULL AS '~METERSIZE~',
	NULL AS '~METERKIND~',
	NULL AS '~METERMODEL~',
	NULL AS '~DIALS~',
	NULL AS '~DEADZEROES~',
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
	'~' + LEFT(meter.MeterLocation,50) + '~' AS '~COMMENTS~',
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
WHERE
	meter.MeterNumber IS NOT NULL AND meter.location_id <> 1
ORDER BY [~DEVICETYPE~] DESC -- We need ERTs and Registers to be fed into the system first before meters
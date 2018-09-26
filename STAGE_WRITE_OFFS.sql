/****************************************************
			STAGE_WRITE_OFFS.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
LaSt Update: August 29, 2018               


------------------------------------------------------
Purpose:
	Extract write-offs from Inhance to place in
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
		1-Electric
		2-Rental
		3-Water
		4-Sewer
		5-Gas
		6-Refuse
		8-Drainage
------------------------------------------------------
HISTORY:
	August 29,2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	RTRIM(CONVERT(CHAR(15), writeOffs.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(15), locationMaint.location_id)) AS "LOCATIONID",
	"APPLICATION" =
		CASE
			WHEN writeOffs.description LIKE '%Energy%' THEN 1
			WHEN writeOffs.description LIKE '%Sewer%' THEN 4
			WHEN writeOffs.description LIKE '%Sanitation%' THEN 6
			ELSE 3
		END,
	NULL AS "CHARGEDATE",
	CONVERT(CHAR(10),writeOffs.date, 126) AS "WRITEOFFDATE",
	CONVERT(DECIMAL(11,2), writeOffs.total_written_off) AS "WRITEOFFAMOUNT",
	CONVERT(DECIMAL(11,2), writeOffs.amount) AS "AMOUNTREMAINING",
	NULL AS "RECEIVABLECODE",
	CONVERT(CHAR(10),GETDATE(), 126) AS "UPDATEDATE" -- YYYY-MM-DD 

FROM 
	vw_write_off writeOffs
JOIN
	ub_vw_location_maint locationMaint
ON
	writeOffs.customer_id = locationMaint.customer_id
WHERE 
	locationMaint.location_id <> 1 -- Ignore warehouse meters
ORDER BY CUSTOMERID, LOCATIONID
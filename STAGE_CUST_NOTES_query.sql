/****************************************************
			STAGE_CUST_NOTES.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
Last Update: August 24, 2018               


------------------------------------------------------
Purpose:
	Extract Customer Notes from Inhance to place in
	a staging table for Systems & Software enQuesta v6   
	                         
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	Export results set as a CSV file. Include headers.
	With your text editor, replace the "#~#"with a single
	double-quote (") so CSV will know what is a string

	Designed to be exported as a .CSV
------------------------------------------------------
Assumptions:
	APPLICATION will always be 3-Water since we bill
	water and sewage based off of water user
------------------------------------------------------
HISTORY:
	August 24,2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT	
	RTRIM(CONVERT(CHAR(15), contact.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(15), locationMaint.location_id)) AS "LOCATIONID",
	3 AS "APPLICATION", --1-Electric, 3-Water, 4-Sewer,5-Gas
	CONVERT(char(10), contact.contact_dt, 126) AS "NOTEDATE", -- YYYY-MM-DD
	99 AS "NOTETYPE",
	"WORKORDERNUMBER" = 
		CASE
			WHEN contact.wo_num = NULL THEN ''
			ELSE contact.wo_num
		END,
	RTRIM(CONVERT(CHAR(4000), contact.note)) AS "NOTEDATA", 
	CONVERT(char(10),GETDATE(), 126) AS "UPDATEDATE" -- YYYY-MM-DD
FROM 
	vw_contact contact
JOIN
	ub_vw_location_maint locationMaint
ON
	contact.customer_id = locationMaint.customer_id
WHERE
	locationMaint.status = 'A' AND      -- only active accounts
	locationMaint.location_id <> 1 AND  -- Exclude warehouse accounts
	LEN(contact.note) > 0 AND           -- Make sure we have a note
	contact.note <> 'Null' AND          -- make sure it's not filled in with "Null"
	contact.contact_dt > DATEADD(year, -1, GetDate()) -- Only need data for the last 12 months
ORDER BY CUSTOMERID, LOCATIONID ASC
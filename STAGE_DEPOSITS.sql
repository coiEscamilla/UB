/****************************************************
			STAGE_DEPOSITS.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------

version="1.0.0"
LaSt Update: August 29, 2018               


------------------------------------------------------
Purpose:
	Extract deposit balances from Inhance to place in
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

	DEPOSITSTATUS
		0-Active, Deposit Held
		1-Paid/Refunded
		90-Pending

	DEPOSITKIND
		Dep Kind #	Description
		0	Cash
		1	Residential Deposit           
		2	Commercial Deposit            
		3	Fire Hydrant Deposit          
		4	Contractor's Deposit          
		5	Commercial (1.5" & 2" Meters) 
		6	Commercial (4" Meters)        
		7	Commercial (8" Meters)        
		8	Commercial (12" Meters)       
		9	Commercial (5/8-3/4-1" Meters)
		10	Commercial (3" Meters)        
		11	Commercial (6" Meters)        
		12	Commercial (10" Meters)       
		13	Residential Deposit - Builder 

------------------------------------------------------
HISTORY:
	August 29,2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:

****************************************************/

SELECT DISTINCT
	'~' + LEFT(deposits.customer_id,15) + '~' AS '~CUSTOMERID~',
	'~' + LEFT(locationMaint.location_id,15) + '~' AS '~LOCATIONID~',
	3 AS '~APPLICATION~',
	'~DEPOSITSTATUS~' =
		CASE
			WHEN deposits.close_dt IS NOT NULL THEN 0  -- No close date so the deposit is Active/Deposit Held
			ELSE 1                                     -- We have a "Closed Date" so the deposit has need Paid/Refunded 
		END,
	deposits.deposit_type_id AS '~DEPOSITKIND~',
	CONVERT(CHAR(10),deposits.dt_received, 126) AS '~DEPOSITDATE~', -- YYYY-MM-DD
	CONVERT(DECIMAL(11,2),deposits.orig_deposit) AS '~DEPOSITAMOUNT~',
	'~~' AS '~DEPOSITBILLEDFLAG~',
	'' AS '~DEPOSITACCRUEDINTEREST~',
	'' AS '~DEPOSITINTERESTCALCDATE~',
	CONVERT(CHAR(10),deposits.last_consider_dt, 126) AS '~UPDATEDATE~' -- YYYY-MM-DD

FROM ub_deposit deposits
JOIN
	ub_vw_location_maint locationMaint
ON
	deposits.customer_id = locationMaint.customer_id
ORDER BY [~CUSTOMERID~],[~LOCATIONID~]
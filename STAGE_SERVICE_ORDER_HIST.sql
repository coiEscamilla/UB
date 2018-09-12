/****************************************************
			STAGE_SERVICE_ORDER_HIST.sql
filepath:
\\departments\32\UB Software Replacement\Conversion\sql
------------------------------------------------------
version="1.0.1"
Last Update: September 6, 2018               
------------------------------------------------------
Purpose:
	Extract work order history from Inhance to place in
	a staging table for Systems & Software enQuesta v6 
------------------------------------------------------
Instructions:
	Run against OASIS (Principal, Synchronized)
	located on SRVCH-SQLDB1\WATER, SQL Server 2008 R2

	Export results set as a CSV file. Include headers.
	With your text editor, replace the "~" with a single
	double-quote (") so CSV will know what is a string

	Designed to be exported as a .CSV
------------------------------------------------------
Assumptions:

------------------------------------------------------
HISTORY:
	September 12, 2018 - v1.0.0  - First Creation
------------------------------------------------------
TODO:
	
****************************************************/
SELECT DISTINCT
	'~'+ LEFT(customer.customer_id, 15) + '~' as '~CUSTOMERID~',
	'~'+ LEFT(meterMaint.location_id, 15) + '~' as '~LOCATIONID~',
	3 AS '~APPLICATION~',
	CONVERT(CHAR(10), workOrder.CreateDate, 126) AS '~CREATEDDATE~',
	CONVERT(CHAR(10), workOrder.WOStartDate, 126) AS '~SCHEDULEDDATE~',
	CONVERT(CHAR(10), workOrder.CompletionDate, 126) AS '~COMPLETEDDATE~',
	workOrder.JobType AS  '~WORKORDERTYPE~',
	LEFT(workOrder.WorkOrderNumber,8) AS '~WORKORDERNUMBER~',
	workOrder.Status AS '~WORKORDERSTATUS~',
	'~~' AS '~METERNUMBER~',
	NULL AS '~RESOLUTIONCODE~',
	workOrder.JobDescription AS '~WORKORDERNOTES~',
	CONVERT(char(10), GetDate(),126)  AS '~UPDATEDATE~'
FROM 
	ub_vw_meter_maint meterMaint
JOIN
	vw_customer customer
ON
	customer.customer_id = meterMaint.customer_id
JOIN
	vw_WorkOrder workOrder
ON
	workOrder.customer_id = customer.customer_id
WHERE 
	meterMaint.location_id <> 1 -- Avoid warehouse transactions
ORDER BY [~CUSTOMERID~], [~LOCATIONID~], [~COMPLETEDDATE~]
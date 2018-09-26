
-- Inhance drops location IDs from inactive accounts. 
-- We'll need to use the transaction table to get the last
-- location ID before the service address was removed
with CTE_TransactionsLocation AS (
	SELECT 
		customer_id,
		location_id
	FROM 
		vw_gen_tran
	WHERE 
		Description = 'Service Address Removed' AND
		TransactionDate > DATEADD(year, -1, GETDATE())
)

-- QUERY: Accounts with location IDs
SELECT DISTINCT
	RTRIM(CONVERT(CHAR(15), customer.AccountNumber)) AS "ACCOUNTNUMBER",
    RTRIM(CONVERT(CHAR(15), customer.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(15), locationMaint.location_id)) AS "LOCATIONID",
	"ACTIVECODE" =
		CASE
			WHEN customer.Status = 'A' THEN 0 -- "0" is Active Code
			WHEN customer.Status = 'I' THEN 2 -- "2" is Inactive Code
			WHEN customer.BillingCycleNumber = '20101' AND customer.BillingStatus = 'Final' THEN 1
			ELSE 2 -- Default to inactive
		END,
	"STATUSCODE" =
		CASE
			WHEN customer.BillingStatus = 'Disconnect' THEN 1
			WHEN customer.BillingStatus = 'Paid Final-CA' THEN 11
			WHEN customer.BillingStatus = 'Final Write Offs' THEN 11
			WHEN customer.BillingStatus = 'Final Collections' THEN 11
			ELSE 0
		END,
	1 AS "ADDRESSSEQ",
	"PENALTYCODE" = 
		CASE
			WHEN customer.Penalizable = 'Y' THEN 1
			ELSE 0
		END,
	"TAXCODE" = 
		CASE
			WHEN locationMaint.loc_class = 'S' THEN 0 -- No tax on sewage
			ELSE 1 -- Tax it all
		END,
	"TAXTYPE" = 
		CASE
			WHEN customer.Class IN ('Customer','Residential','Rural Residential','Senior') THEN 1
			WHEN customer.Class IN ('Apartment','Commercial', 'Hydrant','Rural Apartment','Rural Commercial','Hotel/Motel','Rural Hotel/Motel', 'Private Fire', 'Conversion Finals','Bankruptcy - Com') THEN 2
			WHEN customer.Class IN ('CITY Property', 'Government Property') THEN 3
			WHEN customer.Class IN ('Industrial','Rural Industrial','Large Industrial') THEN 4
			ELSE 1
		END,
	1 AS "ARCODE",
	1 AS "BANKCODE",
	CONVERT(CHAR(10), customer.CreateDate, 126) AS "OPENDATE",
	CONVERT(CHAR(10), customer.LockDate, 126) AS "TERMINATEDDATE",
	"DWELLINGUNITS" =
		CASE
			WHEN locationMaint.residents > 0 THEN CAST (locationMaint.residents as int)
			ELSE 1 -- At least one familty unit
		END,
	0 as "STOPSHUTOFF",
	"STOPPENALTY" =
		CASE
			WHEN customer.Penalizable = 'Y' THEN 0 -- "0" = Penalizable
			ELSE 2 -- "2" = Not Penalizable
		END,
	CONVERT(CHAR(10), customer.FinalNoticeDueDate, 126) AS "DUEDATE",
	NULL AS "SICCODE",
	NULL AS "BUNCHCODE",
	CONVERT(CHAR(10), customer.LockDate, 126) AS "SHUTOFFDATE",
	'' AS "PIN",
	"DEFERREDDUEDATE" = 
		CASE
			WHEN customer.Class = 'Senior' THEN CONVERT(CHAR(10), customer.FirstNoticeDueDate + 10, 126) -- Seniors get 10 extra days to pay their bills
			ELSE NULL
		END,
	NULL AS "LASTNOTICECODE",
	NULL AS "LASTNOTICEDATE",
	NULL AS "CASHONLY",
	'' AS "NEMLASTTRUEUPDATE",
	'' AS "NEMNEXTTRUEUPDATE",
	CONVERT(CHAR(10),GETDATE(), 126) AS "UPDATEDATE" -- YYYY-MM-DD 
FROM 
	vw_customer customer
JOIN
	ub_vw_location_maint locationMaint
ON
	locationMaint.customer_id = customer.customer_id
UNION ALL
-- QUERY: Accounts with NO location IDs, grab location ID from transactions table
SELECT DISTINCT
	RTRIM(CONVERT(CHAR(15), customer.AccountNumber)) AS "ACCOUNTNUMBER",
    RTRIM(CONVERT(CHAR(15), customer.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(15), CTE_TransactionsLocation.location_id)) AS "LOCATIONID",
	"ACTIVECODE" =
		CASE
			WHEN customer.Status = 'A' THEN 0 -- "0" is Active Code
			WHEN customer.Status = 'I' THEN 2 -- "2" is Inactive Code
			WHEN customer.BillingCycleNumber = '20101' AND customer.BillingStatus = 'Final' THEN 1
			ELSE 2 -- Default to inactive
		END,
	"STATUSCODE" =
		CASE
			WHEN customer.BillingStatus = 'Disconnect' THEN 1
			WHEN customer.BillingStatus = 'Paid Final-CA' THEN 11
			WHEN customer.BillingStatus = 'Final Write Offs' THEN 11
			WHEN customer.BillingStatus = 'Final Collections' THEN 11
			ELSE 0
		END,
	1 AS "ADDRESSSEQ",
	"PENALTYCODE" = 
		CASE
			WHEN customer.Penalizable = 'Y' THEN 1
			ELSE 0
		END,
	0 AS "TAXCODE",
	"TAXTYPE" = 
		CASE
			WHEN customer.Class IN ('Customer','Residential','Rural Residential','Senior') THEN 1
			WHEN customer.Class IN ('Apartment','Commercial', 'Hydrant','Rural Apartment','Rural Commercial','Hotel/Motel','Rural Hotel/Motel', 'Private Fire', 'Conversion Finals','Bankruptcy - Com') THEN 2
			WHEN customer.Class IN ('CITY Property', 'Government Property') THEN 3
			WHEN customer.Class IN ('Industrial','Rural Industrial','Large Industrial') THEN 4
			ELSE 1
		END,
	1 AS "ARCODE",
	1 AS "BANKCODE",
	CONVERT(CHAR(10), customer.CreateDate, 126) AS "OPENDATE",
	CONVERT(CHAR(10), customer.LockDate, 126) AS "TERMINATEDDATE",
	1 AS "DWELLINGUNITS",
	0 as "STOPSHUTOFF",
	"STOPPENALTY" =
		CASE
			WHEN customer.Penalizable = 'Y' THEN 0 -- "0" = Penalizable
			ELSE 2 -- "2" = Not Penalizable
		END,
	CONVERT(CHAR(10), customer.FinalNoticeDueDate, 126) AS "DUEDATE",
	NULL AS "SICCODE",
	NULL AS "BUNCHCODE",
	CONVERT(CHAR(10), customer.LockDate, 126) AS "SHUTOFFDATE",
	'' AS "PIN",
	"DEFERREDDUEDATE" = 
		CASE
			WHEN customer.Class = 'Senior' THEN CONVERT(CHAR(10), customer.FirstNoticeDueDate + 10, 126) -- Seniors get 10 extra days to pay their bills
			ELSE NULL
		END,
	NULL AS "LASTNOTICECODE",
	NULL AS "LASTNOTICEDATE",
	NULL AS "CASHONLY",
	'' AS "NEMLASTTRUEUPDATE",
	'' AS "NEMNEXTTRUEUPDATE",
	CONVERT(CHAR(10),GETDATE(), 126) AS "UPDATEDATE" -- YYYY-MM-DD 
FROM 
	vw_customer customer
JOIN
	CTE_TransactionsLocation
ON
	CTE_TransactionsLocation.customer_id = customer.customer_id
ORDER BY CUSTOMERID, LOCATIONID
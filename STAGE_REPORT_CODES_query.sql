SELECT
    RTRIM(CONVERT(CHAR(15), customer.customer_id)) AS "CUSTOMERID",
	RTRIM(CONVERT(CHAR(15), locationMaint.location_id)) AS "LOCATIONID",
	"REPORTCODEFIELD" = 
		CASE
			WHEN customer.Class LIKE '%Senior%' THEN 2
		END,
	"REPORTCODEVALUE" = 
		CASE
			WHEN customer.Class LIKE '%Senior%' THEN 2
		END,
	CONVERT(CHAR(10),GETDATE(), 126) AS "ACTIVEDATE", -- YYYY-MM-DD 
	CONVERT(CHAR(10),GETDATE(), 126) AS "UPDATEDATE" -- YYYY-MM-DD 		
FROM 
	vw_customer customer
JOIN
	ub_vw_location_maint locationMaint
ON
	locationMaint.customer_id = customer.customer_id
WHERE
	customer.Class LIKE '%Senior%' AND
	customer.Status = 'A'
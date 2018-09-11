SELECT DISTINCT
	maint.customer_id,
	maint.location_id,
	vw_income.RateCode,
	maint.status,
	vw_income.Description,
	maint.CustomerName,
	maint.location_addr
FROM
 ub_vw_location_maint maint
JOIN
	vw_income
ON
	vw_income.location_id = maint.location_id
WHERE 
	vw_income.RateCode IN ('DWU1','DWU1R','DWUDt','DWULg','DWUMR','DWUMu')
ORDER BY 
	RateCode, customer_id,maint.location_id
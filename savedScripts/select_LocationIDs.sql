SELECT DISTINCT
	locMaint.location_id AS 'LOCATIONID',
	customer.FirstNameFirst AS 'NAME',
	locMaint.location_addr AS 'ADDRESS'
FROM vw_customer customer
JOIN
	ub_vw_location_maint locMaint
ON
	customer.customer_id = locMaint.customer_id
WHERE locMaint.location_id <> 1
--AND customer.Status = 'A'
ORDER BY LOCATIONID
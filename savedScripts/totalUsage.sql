
SELECT DISTINCT TOP 100
	customerMaint.customer_id,
	customer.FirstNameFirst as 'Name',
	customerMaint.location_addr as 'Address',
	SUM(reading.Usage) AS 'USAGE'
FROM ub_vw_customer_maint customerMaint
JOIN 
	ub_vw_meter_maint meterMaint
ON
	customerMaint.customer_id = meterMaint.location_id
JOIN vw_customer customer ON customer.customer_id = customerMaint.customer_id
JOIN 
	vw_reading reading
ON 
	meterMaint.location_id = reading.location_id AND 
	meterMaint.meter_id = reading.meter_id
WHERE
	 reading.ReadDate > DATEADD(DAY, -365, GETDATE())
GROUP BY customerMaint.customer_id, customer.FirstNameFirst, customerMaint.location_addr
ORDER BY USAGE DESC

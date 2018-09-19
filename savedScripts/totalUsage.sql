-- Select the top 30 consumers from Inhance

SELECT DISTINCT TOP 30 
	customer.customer_id, 
	customer.FirstNameFirst,
	SUM(reading.Usage) AS 'USAGE'
FROM vw_customer customer
JOIN 
	ub_vw_meter_maint meterMaint
ON
	customer.customer_id = meterMaint.location_id
JOIN 
	vw_reading reading
ON 
	meterMaint.location_id = reading.location_id AND 
	meterMaint.meter_id = reading.meter_id
WHERE
	 reading.ReadDate > DATEADD(DAY, -365, GETDATE())
GROUP BY customer.customer_id, customer.FirstNameFirst
ORDER BY USAGE DESC

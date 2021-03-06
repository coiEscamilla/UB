
-- Duplicate ERTs
select
	customer_name as 'Name',
	location_addr as 'Address',
	serial_num as 'ERTNumber'
FROM ub_vw_meter_maint 
WHERE
	location_addr NOT IN ('warehouse', 'FIRE HYDRANT METER') AND
	serial_num IN (
		select
			meter.serial_num
		from ub_vw_meter_maint meter
		JOIN
		ub_vw_location_maint locationMaint
		ON
		locationMaint.location_id = meter.location_id
		where meter.location_id <> 1 and locationMaint.status = 'A'
		group by serial_num
		Having Count(*) > 1
)
ORDER BY serial_num

-- duplicate registers
select
	customer_name as 'Name',
	location_addr as 'Address', 
	alt_met_num as 'RegisterNumber'
from 
	ub_vw_meter_maint meterMaint
where
	meterMaint.location_addr NOT IN ('warehouse', 'FIRE HYDRANT METER') AND
	alt_met_num IN(
		select
			meter.alt_met_num
		from 
			ub_vw_meter_maint meter
		JOIN
		ub_vw_location_maint locationMaint
		ON
		locationMaint.location_id = meter.location_id
		where meter.location_id <> 1 and locationMaint.status = 'A'
		group by alt_met_num
		Having Count(*) > 1
)
ORDER BY RegisterNumber


-- Duplicate Meters
select
	customer_name as 'Name',
	location_addr as 'Address',
	meter_num as 'MeterNumber'
FROM ub_vw_meter_maint 
WHERE
	location_addr NOT IN ('warehouse', 'FIRE HYDRANT METER') AND
	meter_num IN (
		select
			meter.meter_num
		from ub_vw_meter_maint meter
		JOIN
		ub_vw_location_maint locationMaint
		ON
		locationMaint.location_id = meter.location_id
		where meter.location_id <> 1 and locationMaint.status = 'A'
		group by meter_num
		Having Count(*) > 1
)
ORDER BY serial_num
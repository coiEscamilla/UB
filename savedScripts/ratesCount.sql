SELECT 
    RateCode, 
    COUNT(RateCode)
FROM 
    vw_income
GROUP BY 
    RateCode
ORDER BY
    RateCode

select top 10 *
from ub_meter_read
where meter_id = 20444

select top 100 *
from ub_vw_meter_maint
where meter_num = 'p019893124'

select top 10 * 
from vw_meter
where MeterNumber = 'p019893124'



select meter_type,
count(meter_type)
from vw_meter
group by meter_type
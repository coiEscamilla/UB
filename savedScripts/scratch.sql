

select
	FirstNameFirst,
	LEFT(FirstNameFirst,CHARINDEX('/',FirstNameFirst) - 1) AS 'temp1',
	SUbSTRING(
		FirstNameFirst,
		CHARINDEX('/',FirstNameFirst) + 1,
		LEN(FirstNameFirst)
		) AS 'temp2'
from vw_customer
where FirstNameFirst like '%/%'


-- GL Codes?
  select distinct
	CoaString,
	CoaAcctDescr,
	LineDescr,
	Count(CoaString) as TOTALS
  from vw_gl_litm
  GROUP BY CoaString, CoaAcctDescr,LineDescr
  ORDER BY CoaString



	--select distinct
--	state,
--	count(state) as Totals
--from vw_mailing_address
--group by State
--order by state

--select distinct
--	Country,
--	count(Country) as Totals
--from vw_address_all
--group by Country
--order by Country


select * from vw_mailing_address addr
JOIN
	vw_address_all addrAll
ON
	addr.address_id = addrAll.address_id
where addr.State IN ('AE', 'ARIZONA', 'BRITISH COLUMBI', 'COSTA RICA', 'FINLAND','IW','JAPAN','KA','KANSAS','LOUISIANA','MARYLAND',
'ML','NADU','NB','NEV','ON','ONTARIO','ONTERIO','SANTA MARIE', 'SK','TS','UK','WC')
ORDER BY addr.State



SELECT
	account_num as 'Account Number',
	first_name as 'First Name',
	customer_name 'Customer Name',
	alt_name as 'Alternative Name',
	Surname as 'Last Name'
FROM ub_vw_customer
WHERE ub_vw_customer.status = 'A' AND (first_name like '%/%' OR Surname LIKE '%/%')
ORDER BY account_num


select * from vw_gen_tran
where customer_id = '56386'
ORDER BY TransactionDate

select * from ub_vw_location_maint where location_id = '40429'
select * from vw_customer where customer_id = '123040'

select * from vw_gen_tran
where account_num = '525821' AND Description = 'Service Address Removed'
order by TransactionDate

select * from vw_payment_detail where AccountNumber = '43829201004    '

select * from vw_customer where AccountNumber ='43829201004    '


exec sp_columns vw_write_off

select top 100 *
from vw_customer
where vw_customer.Status = 'I'
order by FirstNoticeDueDate DESC



select 
CUSTOMERID, 
LOCATIONID,
APPLICATION,
 SERVICENUMBER,
 METERNUMBER, 
 METERREGISTER
from(
	SELECT DISTINCT
		customer.customer_id as "CUSTOMERID",
		meterMaint.location_id as "LOCATIONID",
		3 as "APPLICATION", --1-Electric, 3-Water, 4-Sewer,5-Gas
		ROW_NUMBER() OVER(PARTITION BY meterMaint.location_id ORDER BY meterMaint.meter_num ASC) AS "SERVICENUMBER", -- If we have multiple meters at each location, assign them an incremental service number
		meterMaint.meter_num AS "METERNUMBER",
		1 AS "METERREGISTER"
	FROM 
		ub_vw_meter_maint meterMaint
	JOIN
		vw_customer customer
	ON
		customer.customer_id = meterMaint.customer_id
) X
WHERE  SERVICENUMBER = 2

--[Error]|2018-09-28T10:01:09|File: Allowable Changes Threshold 10.00 % has been violated.  File is attempting to update 17921 of 45830 records.  Aborting Import.
--[Error]|2018-09-28T10:00:18|Row 703: Duplicate value for ServicePointId: 10335601001
--[Error]|2018-09-28T10:00:18|Row 704: Duplicate value for ServicePointId: 10335601001
--[Error]|2018-09-28T10:00:18|Row 5569: Duplicate value for ServicePointId: 11752101003
--[Error]|2018-09-28T10:00:18|Row 5570: Duplicate value for ServicePointId: 11752101003
--[Error]|2018-09-28T10:00:18|Row 8358: Duplicate value for ServicePointId: 12534201001
--[Error]|2018-09-28T10:00:18|Row 8359: Duplicate value for ServicePointId: 12534201001
--[Error]|2018-09-28T10:00:18|Row 30234: Duplicate value for ServicePointId: 40716001014
--[Error]|2018-09-28T10:00:18|Row 30235: Duplicate value for ServicePointId: 40716001014
--[Error]|2018-09-28T10:00:18|Row 32072: Duplicate value for ServicePointId: 41632901004
--[Error]|2018-09-28T10:00:18|Row 32073: Duplicate value for ServicePointId: 41632901004
--[Error]|2018-09-28T10:00:18|Row 32557: Duplicate value for ServicePointId: 41810101010
--[Error]|2018-09-28T10:00:18|Row 32558: Duplicate value for ServicePointId: 41810101010
--[Error]|2018-09-28T10:00:18|Row 33402: Duplicate value for ServicePointId: 42018201009
--[Error]|2018-09-28T10:00:18|Row 33403: Duplicate value for ServicePointId: 42018201009
--[Error]|2018-09-28T10:00:18|Row 36288: Duplicate value for ServicePointId: 42816801002
--[Error]|2018-09-28T10:00:18|Row 36289: Duplicate value for ServicePointId: 42816801002
--[Error]|2018-09-28T10:00:18|Row 37178: Duplicate value for ServicePointId: 43131601001
--[Error]|2018-09-28T10:00:18|Row 37179: Duplicate value for ServicePointId: 43131601001
--[Error]|2018-09-28T10:00:18|Row 37356: Duplicate value for ServicePointId: 43210601004
--[Error]|2018-09-28T10:00:18|Row 37357: Duplicate value for ServicePointId: 43210601004
--[Error]|2018-09-28T10:00:18|Row 39950: Duplicate value for ServicePointId: 43619501001
--[Error]|2018-09-28T10:00:18|Row 39951: Duplicate value for ServicePointId: 43619501001
--[Error]|2018-09-28T10:00:18|Row 40463: Duplicate value for ServicePointId: 43817001008
--[Error]|2018-09-28T10:00:18|Row 40464: Duplicate value for ServicePointId: 43817001008
--[Error]|2018-09-28T10:00:18|Row 40575: Duplicate value for ServicePointId: 43828201006
--[Error]|2018-09-28T10:00:18|Row 40576: Duplicate value for ServicePointId: 43828201006
--[Error]|2018-09-28T10:00:18|Row 40821: Duplicate value for ServicePointId: 43852901001
--[Error]|2018-09-28T10:00:18|Row 40822: Duplicate value for ServicePointId: 43852901001
--[Error]|2018-09-28T10:00:18|Row 40942: Duplicate value for ServicePointId: 43865101004
--[Error]|2018-09-28T10:00:18|Row 40943: Duplicate value for ServicePointId: 43865101004
--[Error]|2018-09-28T10:00:18|Row 42755: Duplicate value for ServicePointId: 44133301002
--[Error]|2018-09-28T10:00:18|Row 42756: Duplicate value for ServicePointId: 44133301002
--[Error]|2018-09-28T10:00:18|Row 43280: Duplicate value for ServicePointId: 44186201003
--[Error]|2018-09-28T10:00:18|Row 43281: Duplicate value for ServicePointId: 44186201003
--[Error]|2018-09-28T10:00:18|Row 44315: Duplicate value for ServicePointId: 44411901001
--[Error]|2018-09-28T10:00:18|Row 44316: Duplicate value for ServicePointId: 44411901001
--[Error]|2018-09-28T10:00:18|Row 44353: Duplicate value for ServicePointId: 44416101001
--[Error]|2018-09-28T10:00:18|Row 44354: Duplicate value for ServicePointId: 44416101001
--[Error]|2018-09-28T10:00:18|Row 45373: Duplicate value for ServicePointId: 44650901002
--[Error]|2018-09-28T10:00:18|Row 45374: Duplicate value for ServicePointId: 44650901002
--[Error]|2018-09-28T10:00:18|Row 45838: Duplicate value for ServicePointId: 44701501001
--[Error]|2018-09-28T10:00:18|Row 45839: Duplicate value for ServicePointId: 44701501001

select 
	meterMaint.location_id,
	locationMaint.parcel_num, 
	meterMaint.serial_num, 
	meterMaint.customer_name, 
	meterMaint.location_addr
from ub_vw_meter_maint meterMaint
JOIN
	ub_vw_location_maint locationMaint
ON
	locationMaint.location_id = meterMaint.location_id
WHERE 
	parcel_num IN ('10335601001','11752101003','12534201001','40716001014','41632901004',
	'41810101010','42018201009','42816801002','43131601001','43210601004',
	'43619501001','43817001008','43828201006','43852901001','43865101004',
	'44133301002','44186201003','44411901001','44416101001','44650901002','44701501001')
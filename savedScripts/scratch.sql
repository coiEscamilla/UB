

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


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
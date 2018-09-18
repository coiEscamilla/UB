

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


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

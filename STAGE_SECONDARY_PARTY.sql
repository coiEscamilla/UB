--No secondary party info in inhance
SELECT "CUSTOMERID" = left('', 8)
     ,  "ACCOUNTNUMBER" = left('', 15)
     ,  "LOCATIONID" = left('', 15)
     ,  "SEDONDARYCUSTOMERID" = left('',8)
     ,  "SECONDARYPARTYTYPE" = left('', 2)
     ,  "PRIORITY" = left('', 1)
     ,  "ADDRESSSEQ" = left('', 4)
     ,  "STARTDATE" = left('', 8)
     ,  "STOPDATE" = left('', 8)
     ,  "UPDATEDATE" = left('', 8)
FROM
FROM ub_customer

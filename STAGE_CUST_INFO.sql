SELECT "CUSTOMERID" = left(coalesce(ub_customer.customer_id,''), 8)
     ,  "FULLNAME" = left(coalesce(coalesce(first_name, '')+' '+coalesce(surname,''),'BLANK'), 50) --This is required so if no name populate with BLANK for now
     ,  "FIRSTNAME" = left(coalesce(first_name,''), 25)
     ,  "MIDDLENAME" = left(coalesce('',''), 25)
     ,  "LASTNAME" = left(coalesce(surname,''), 50)
     ,  "NAMETITLE" = left(coalesce(title,''), 5)
     ,  "NAMESUFFIX" = left(coalesce('',''), 5)
     ,  "DBA" = left(coalesce(surname,''), 35)
     ,  "CUSTTYPE" =coalesce(CASE
                                 WHEN class_id IN ('1','2','4','9','15','29','32','28') THEN 0
                                 WHEN class_id IN ('5','6','7','8','10','11','12','13','14','30','31','33','34','35') THEN 1
                             END, '1')
     ,  "ACTIVECODE" = CASE
                           WHEN status = 'A' THEN 0 -- need logic for final status: 0,1,2,4,7,50

                           WHEN status = 'I' THEN 1
                       END
                     ,  "SSNTINCODE" = LEFT(ISNULL('',''), 1)

                     ,  "SSNTIN" = LEFT(ISNULL(govern_tag,''), 9)

                     ,  "DRIVERLICENSE" = LEFT(ISNULL(verify,''), 16)

                     ,  "DRIVERLICENSE STATE" = LEFT(ISNULL('',''), 2)

                     ,  "DRIVERLICENSE Exp Year" = LEFT(ISNULL('',''), 4)

                     ,  "MOTHERMAIDENNAME" = left(isnull('',''), 15)
                     ,  "EMPLOYERNAME" = left(isnull('',''), 35)
                     ,  "EMPLOYERPHONE" = left(isnull('',''), 10)
                     ,  "EMPLOYERPHONEEXT" = left(isnull('',''), 5)
                     ,  "OTHERIDTYPE1" = left(isnull('',''), 2)
                     ,  "OTHERIDVALUE1" = left(isnull('',''), 15)
                     ,  "OTHERIDTYPE2" = left(isnull('',''), 2)
                     ,  "OTHERIDVALUE2" = left(isnull('',''), 15)
                     ,  "OTHERIDTYPE3" = left(isnull('',''), 2)
                     ,  "OTHERIDVALUE3" = left(isnull('',''), 15)
                     ,  "UPDATEDATE" = left(isnull('',''), 8)
FROM ub_customer
--WHERE status = 'A'

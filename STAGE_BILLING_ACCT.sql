--query to set taxable status
with ts_check as (
	--change to pull off of rate_id instead of description
	select location_id
	, TAX = MAX(CASE WHEN DESCRIPTION like 'Service/Sales Tax%' then 1 ELSE 0 END)
	, Sanitation = MAX(case when description like 'Service/Sanitation%' then 1 else 0 end)  
from vw_income group by location_id  ) 

, tax_exempt as (

	select location_id
	, TAXABLE = CASE WHEN Sanitation = 1 and TAX = 0 then 0
			ELSE 1 
			END	
	from ts_check
)

--LOGIC for ACTIVECODE
--Caleb, 
--I want to follow up on the final pending status for S&S as it relates to our final cycle accounts.  Below is a layout which should make it easier for you to determine if an account is FINAL PENDING OR INACTIVE.
--
--Final Pending
--
--Cycle                                     Account Status                  Billing Status                     S&S
--
--20101                                    Inactive                                Final                                       1 (Final Pending)
--20101                                    Inactive                                Final Paid                             2 (Inactive)
--
--
SELECT DISTINCT "ACCOUNTNUMBER" = left('', 15)
              ,  "CUSTOMERID" = left(uc.customer_id, 8)
              ,  "LOCATIONID" = left(usla.location_id, 15)
              ,  "ACTIVECODE" = CASE
                                    WHEN status = 'A' THEN 0 -- need logic for final status: 0,1,2,4,7,50; see email above

                                    WHEN status = 'I' THEN 2
                                END 
                              ,  "STATUSCODE" = CASE status_level
                                                    WHEN 30 THEN 0 --Normal 	== Normal 
                                                    WHEN 40 THEN 0 --First Notice 	== Normal 
                                                    WHEN 55 THEN 0 --Trsf Final Balances == Normal 
                                                    WHEN 80 THEN 0 --Paid Final 	== Normal 
                                                    WHEN 80 THEN 0 --Final 	== Normal 
                                                    WHEN 90 THEN 0 --Final Bill 	== Normal 
                                                    WHEN 45 THEN 1 --Disconnect 	== Disconnect 
                                                    WHEN 90 THEN 11 --Paid Final-CA	== Collections 
                                                    WHEN 400 THEN 11 --Final Write Offs == Collections

                                                END
                                              ,  "ADDRESSSEQ" = left('1',2) --ub_itron_temp.sequence; ub_read_result_temp.sequence -- only seq in reading route 
                                              ,  "PENALTYCODE" = penalty_flg -- case when penalty_flg = 0 then 0 else '' end --see 1-99 Penalty rates to be configured in enquesta (see data mapping doc) 
                                              ,  "TAXCODE" = te.taxable -- Either 0 or 1, discuss with Dana 
                                              ,  "TAXTYPE" = CASE
                                                                 WHEN ucc.class_name IN ('Customer'
                                                                                       ,  'Residential'
                                                                                       ,  'Rural Residential'
                                                                                       ,  'Senior') THEN 1 --'Municipal' --going to go with this for now

                                                                 WHEN ucc.class_name IN ('Apartment'
                                                                                       ,  'Commercial'
                                                                                       ,  'Hydrant'
                                                                                       ,  'Rural Apartment'
                                                                                       ,  'Rural Commercial'
                                                                                       ,  'Hotel/Motel'
                                                                                       ,  'Rural Hotel/Motel'
                                                                                       ,  'Private Fire'
                                                                                       ,  'Conversion Finals'
                                                                                       ,  'Bankruptcy - Com') THEN 2
                                                                 WHEN ucc.class_name IN ('CITY Property'
                                                                                       ,  'Government Property') THEN 3
                                                                 WHEN ucc.class_name IN ('Industrial'
                                                                                       ,  'Rural Industrial'
                                                                                       ,  'Large Industrial') THEN 4
                                                             END
                                                           ,  "ARCODE" = left('', 4)
                                                           ,  "BANKCODE" = left('', 4) --might not be necessary

                                                           ,  "OPENDATE" = dbo.ss_formatdate(uc.creation_dt)
                                                           ,  "TERMINATEDDATE" = coalesce(dbo.ss_formatdate(uc.final_dt), '')
                                                           ,  "DWELLINGUNITS" = left(coalesce(convert(varchar(MAX),vl.equivalentlivingunit), ''), 4)
                                                           ,  "STOPSHUTOFF" = ''
                                                           ,  "STOPPENALTY" = left((CASE
                                                                                        WHEN uc.penalty_flg = 0 THEN 0
                                                                                        ELSE 2
                                                                                    END) , 1)
                                                           ,  "DUEDATE" = left('', 8)
                                                           ,  "SICCODE" = left('', 6)
                                                           ,  "BUNCHCODE" = left('', 2)
                                                           ,  "SHUTOFFDATE" = left('', 8)
                                                           ,  "PIN" = left('', 10)
                                                           ,  "DEFERREDDUEDATE" = left('', 8)
                                                           ,  "LASTNOTICECODE" = left('', 2)
                                                           ,  "LASTNOTICEDATE" = left('', 8)
                                                           ,  "CASHONLY" = left('', 1)
                                                           ,  "NEMLASTTRUEUPDATE" = left('', 8)
                                                           ,  "NEMNEXTTRUEUPDATE" = left('', 8)
                                                           ,  "MISCARDIVISION" = left('', 2)
                                                           ,  "UPDATEDATE" = left('', 8)
FROM ub_customer uc
JOIN ub_service_location usl ON usl.customer_id = uc.customer_id
JOIN ub_serv_loc_addr usla ON usla.location_id = usl.location_id
JOIN ub_billing_status ubs ON ubs.billing_status_id = uc.billing_status_id
JOIN ub_class ucc ON ucc.class_id = uc.class_id
JOIN vw_income vi ON vi.location_id = usla.location_id
JOIN vw_location vl ON vl.location_id = usla.location_id
JOIN tax_exempt te on te.location_id = usla.location_id
--WHERE uc.status = 'A' --for ACTIVECODE -- need to confirm with SMEs

--"0-Active
--1-Final (Pending)
--2-Inactive
--4-Written Off
--7-Defunct
--50-Never Active (Interim)"
 --for STATUSCODE: -- need to confirm with SMEs
--"0-Normal
--1-Shut Off (Non Payment)
--3-Bankrupt
--10-Seasonal
--11-Collections"
 --ub_billing_status -- Map these to status code
--billing_status_id,status_level,descr,fixed_flg
-------------------,------------,-----,---------
--1,100,Final,0
--2,200,Final Bill,0
--3,999,Final Collections,0
--4,400,Final Write Offs,0
--5,80,Paid Final,0
--6,50,Refunded Final Credit,0
--7,45,Disconnect,0
--8,30,Normal,0
--9,250,Final Bill Second Notice,0
--10,10,Draft Account,0
--11,20,CITY Property,0
--12,15,Government Property,0
--13,90,Paid Final-CA,0
--14,900,Adjusted,0
--15,300,Collect Plus Fee,0
--16,40,First Notice,0
--17,55,Trsf Final Balance,NULL
--18,950,Void Request,NULL
 --TAXTYPE #	TAXTYPE Description
--0	Residential
--1	Commercial
--2	Industrial
--3	Municipal

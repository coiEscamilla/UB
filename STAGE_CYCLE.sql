--Change where clause to filter on cycle number
SELECT "CYCLENUMBER" = CASE
                           WHEN billing_num = '0' THEN '99'
                           ELSE billing_num
                       END
                     ,  "CYCLEDESC" = billing_cycle_descr
FROM ub_billing_cycle
WHERE billing_cycle_descr IN ('CYCLE 1             '
                            ,  'CYCLE 2             '
                            ,  'CYCLE 3             '
                            ,  'CYCLE 4             '
                            ,  'NEW SERVICE LOCATION'
                            ,  'CYCLE 25 COI        '
                            ,  'CYCLE 23 ISD        '
                            ,  'CYCLE 3 DRAFTS      '
                            ,  'CYCLE 1 DRAFTS      '
                            ,  'CYCLE 2 DRAFTS      '
                            ,  'CYCLE 4 DRAFTS      '
                            ,  'GRAND PRAIRIE       '
                            ,  'LAS COLINAS HOA     '
                            ,  'FIRE HYDRANTS       ') -- keep these for customer_info --'FINAL 1 2010        ','FINAL 2 2010        ','FINAL 3 2010        ','FINAL 4 2010        ',

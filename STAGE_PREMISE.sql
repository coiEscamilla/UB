--Arithabort necessary to run CTE
SET arithabort ON;

--CTEs extract granular fields
WITH street_abbreviations AS (
	SELECT abbr
   FROM (
         VALUES ('ALY'),('ANX'),('ARC'),('AVE'),('BCH'),('BG'),('BGS'),('BLF'),('BLFS'),('BLVD'),('BND'),('BR'),('BRG'),('BRK'),('BRKS'),('BTM'),('BYP'),('BYU'),('CIR'),('CIRCLE'),('CIRS'),('CLB'),('CLF'),('CLFS'),('CMN'),('CMNS'),('COR'),('CORS'),('CP'),('CPE'),('CRES'),('CRK'),('CRSE'),('CRST'),('CSWY'),('CT'),('CTR'),('CTRS'),('CTS'),('CURV'),('CV'),('CVS'),('CYN'),('DL'),('DM'),('DR'),('DRS'),('DV'),('EST'),('ESTS'),('EXPY'),('EXT'),('EXTS'),('FALL'),('FLD'),('FLDS'),('FLS'),('FLT'),('FLTS'),('FRD'),('FRDS'),('FRG'),('FRGS'),('FRK'),('FRKS'),('FRST'),('FRY'),('FT'),('FWY'),('GDN'),('GLN'),('GLNS'),('GRN'),('GRNS'),('GRV'),('GRVS'),('GTWY'),('HBR'),('HBRS'),('HL'),('HLS'),('HOLW'),('HTS'),('HVN'),('HWY'),('INLT'),('IS'),('ISLE'),('ISS'),('JCT'),('JCTS'),('KNL'),('KNLS'),('KY'),('KYS'),('LAND'),('LCK'),('LCKS'),('LDG'),('LF'),('LGT'),('LGTS'),('LK'),('LKS'),('LN'),('LNDG'),('LOOP'),('MALL'),('MDW'),('MDWS'),('MEWS'),('ML'),('MLS'),('MNR'),('MNRS'),('MSN'),('MT'),('MTN'),('MTNS'),('MTWY'),('NCK'),('OPAS'),('ORCH'),('OVAL'),('OVERLOOK'),('PARK'),('PASS'),('PATH'),('PIKE'),('PKWY'),('PL'),('PLN'),('PLNS'),('PLZ'),('PNE'),('PNES'),('PR'),('PRT'),('PRTS'),('PSGE'),('PT'),('PTS'),('RADL'),('RAMP'),('RD'),('RDG'),('RDGS'),('RDS'),('RIV'),('RNCH'),('ROW'),('RPD'),('RPDS'),('RST'),('RTE'),('RUE'),('RUN'),('SHL'),('SHLS'),('SHR'),('SHRS'),('SKWY'),('SMT'),('SPG'),('SPGS'),('SPUR'),('SQ'),('SQS'),('ST'),('STA'),('STRA'),('STRM'),('STS'),('TER'),('TPKE'),('TRAK'),('TRCE'),('TRFY'),('TRL'),('TRLR'),('TRWY'),('TUNL'),('UN'),('UNS'),('UPAS'),('VIA'),('VIS'),('VL'),('VLG'),('VLGS'),('VLY'),('VLYS'),('VW'),('VWS'),('WALK'),('WALL'),('WAY'),('WAYS'),('WL'),('WLS'),('XING'),('XRD'),('XRDS')) AS street_abbreviations(abbr)
	)
   ,  suite AS (
	SELECT location_id
        ,  suite = dbo.fulltrim(CASE
                                    WHEN patindex('% #%', location_addr) = 0 THEN ''
                                    ELSE substring(location_addr, patindex('% #%', location_addr)+1, len(location_addr)-1)
                                END)
   FROM ub_serv_loc_addr
   )
   ,  directional AS (
	SELECT location_id
        ,  directional = CASE
                             WHEN patindex('% [NSEW]', location_addr) = 0 THEN ''
                             ELSE substring(location_addr, patindex('% [NSEW]', location_addr)+1, 1)
                         END
   FROM ub_serv_loc_addr
   )
   ,  numeral AS (
	SELECT location_id
        ,  numeral = dbo.fulltrim(CASE
                                      WHEN patindex('% [A-Z]%', location_addr) = 0 THEN ''
                                      ELSE substring(location_addr, 1, patindex('% [A-Z]%', location_addr))
                                  END)
   FROM ub_serv_loc_addr
   )
   ,  type_process AS (
	SELECT s.location_id
        ,  extracted = dbo.fulltrim(replace(replace(replace(location_addr, d.directional, ''), n.numeral, ''), su.suite, ''))
   FROM ub_serv_loc_addr s
   JOIN directional d ON d.location_id = s.location_id
   JOIN numeral n ON n.location_id = s.location_id
   JOIN suite su ON su.location_id = s.location_id
   )
   ,  type_process2 AS (
	SELECT tp.location_id
        ,  extracted2 = dbo.fulltrim(split.splitcolumn)
   FROM type_process tp CROSS apply dbo.udf_split_based_on_multiple_delimiters(tp.extracted, ' ') AS split
   )
   ,  TYPE AS (
	SELECT tp2.location_id
        ,  valid_type = max(sub.valid_type)
   FROM type_process2 tp2
   JOIN
     (SELECT tp3.location_id
           ,  valid_type = CASE
                               WHEN extracted2 IN
                                      (SELECT abbr
                                       FROM street_abbreviations) THEN extracted2
                               ELSE ''
                           END
      FROM type_process2 tp3) sub ON sub.location_id = tp2.location_id
   GROUP BY tp2.location_id
   ) 
   , street AS (
	SELECT s.location_id
        ,  street = dbo.fulltrim(replace(replace(replace(replace(location_addr, d.directional, ''), n.numeral, ''),t.valid_type, ''), su.suite, ''))
   FROM ub_serv_loc_addr s
   JOIN directional d ON d.location_id = s.location_id
   JOIN numeral n ON n.location_id = s.location_id
   JOIN TYPE t ON t.location_id = s.location_id
   JOIN suite su ON su.location_id = s.location_id
   )
SELECT DISTINCT "LOCATIONID" = left(usla.location_id, 15)
              ,  "STREETNUMBER" = left(n.numeral, 5)
              ,  "STREETNUMBERSUFFIX" = left('', 8)
              ,  "STREETNAME" = left(s.street + ' ' + t.valid_type, 24)
              ,  "DESIGNATORTYPE" = left('', 8)
              ,  "DESIGNATORNUMBER" = left('', 5)
              ,  "ADDITIONALDESC" = left('', 15)
              ,  "TOWN" = left(ul.city, 23)
              ,  "STATE" = left(ul.state, 2)
              ,  "ZIPCODE" = left(ul.postal_code, 5)
              ,  "ZIPCODE+4" = ''
              ,  "OWNERCUSTOMERID" = left(uc.customer_id, 8)
              ,  "PROPERTYCLASS" = CASE
                                       WHEN ucc.class_name IN ('Customer'
                                                             ,  'Residential'
                                                             ,  'Rural Residential'
                                                             ,  'Senior') THEN 1 --'Municipal'

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
                                 ,  "TAXDISTRICT" = left('', 2) --??

                                 ,  "BILLINGCYCLE" = left(ubc.billing_num, 4)
                                 ,  "READINGROUTE" = left(ug.book, 4) --book/seq?

                                 ,  "SERVICEAREA" = left('', 4) --GIS

                                 ,  "SERVICEFACILITY" = left(coalesce('',''), 2)
                                 ,  "PRESSUREDISTRICT" = left(coalesce('',''), 4)
                                 ,  "LATITUDE" = coalesce('','') --13,10)
                                 ,  "LONGITUDE" = coalesce('','')-- 13,10)
                                 ,  "MAPNUMBER" = left(coalesce('',''), 8)
                                 ,  "PARCELID" = left(coalesce('',''), 24)
                                 ,  "PARCELAREATYPE" = left(coalesce('',''), 1)
                                 ,  "PARCELAREA" = coalesce('','')--, 15,6)
                                 ,  "IMPERVIOUSSQUAREFEET" = coalesce('','')--, 11,2)
                                 ,  "SUBDIVISION" = left(coalesce('',''), 5)
                                 ,  "GISID" = left(coalesce('',''), 8)
                                 ,  "FOLIOSEGMENT1" = left(coalesce('',''), 8)
                                 ,  "FOLIOSEGMENT2" = left(coalesce('',''), 8)
                                 ,  "FOLIOSEGMENT3" = left(coalesce('',''), 8)
                                 ,  "FOLIOSEGMENT4" = left(coalesce('',''), 8)
                                 ,  "FOLIOSEGMENT5" = left(coalesce('',''), 8)
                                 ,  "PROPERTYUSECLASSIFICATION1" = left(coalesce('',''), 2)
                                 ,  "PROPERTYUSECLASSIFICATION2" = left(coalesce('',''), 2)
                                 ,  "PROPERTYUSECLASSIFICATION3" = left(coalesce('',''), 2)
                                 ,  "PROPERTYUSECLASSIFICATION4" = left(coalesce('',''), 2)
                                 ,  "PROPERTYUSECLASSIFICATION5" = left(coalesce('',''), 2)
                                 ,  "UPDATEDATE" = left(coalesce('',''), 8)
FROM street s
JOIN directional d ON d.location_id = s.location_id
JOIN numeral n ON n.location_id = s.location_id
JOIN TYPE t ON t.location_id = s.location_id
JOIN suite su ON su.location_id = s.location_id
JOIN ub_serv_loc_addr usla ON usla.location_id = s.location_id
JOIN ub_service_location usl ON usl.location_id = usla.location_id
JOIN ub_locale ul ON ul.locale_id = usl.locale_id
JOIN ub_customer uc ON uc.customer_id = usl.customer_id
JOIN ub_class ucc ON uc.class_id = ucc.class_id
JOIN ub_billing_cycle ubc ON ubc.billing_cycle_id = uc.billing_cycle_id
JOIN ub_group ug ON ug.location_id = usl.location_id --select


-- union meters + registers + erts
WITH meters AS
  (SELECT "APPLICATION" = left(isnull('3',''), 1) --if sewer(4) do we need to add registers?

        ,  "DEVICETYPE" = left(isnull('0',''), 1) --need to configure remote kinds

        ,  "METERNUMBER" = left(isnull(ub.meternumber,''), 12)
        ,  "SERIALNUMBER" = left(isnull(ub.serialnumber,''), 12)
        ,  "OTHERDEVICETYPE1" = '1'--this would be ERT?

        ,  "OTHERDEVICEID1" = left(isnull(ub.serialnumber,''), 12)
        ,  "OTHERDEVICEMARRY1" = left(isnull('',''), 1)
        ,  "OTHERDEVICETYPE2" = '2' --this would be Register?

        ,  "OTHERMETERNUMBER2" = left(isnull(uvlm.alt_met_num,''), 12)
        ,  "OTHERDEVICEMARRY2" = left(isnull('',''), 1)
        ,  "METACONFIG" = left(isnull('',''), 2) --add logic to populate this

        ,  "INITIALINSTALLDATE" = dbo.ss_formatdate(max(installed))
        ,  "CURRENTINSTALLDATE" = dbo.ss_formatdate(max(installed))
        ,  "MULTIPLIER" = left('1', 6) --6,6; we will have to import decode_matrix to get this,''), otherwise 1

        ,  "CTNUMBER" = left(isnull('',''), 12) --electric only

        ,  "VTNUMBER" = left(isnull('',''), 12)
        ,  "PONUMBER"= left(isnull('',''), 8) --n/a

        ,  "PODATE	      "= left(isnull('',''), 8) --n/a

        ,  "PURCHASECOST	      "= left(isnull('',''), 9) --9,''),2

        ,  "RETIREDATE	      "= dbo.ss_formatdate(max(scrapped))
        ,  "ASSETTAXDISTRICT" = left(isnull('',''),2)
        ,  "BIDIRECTIONALFLAG  "= left(isnull('',''), 1) --see ub_meter_model.dial_read_direction; irving_vw_mdi.DistrictFlowDirection

        ,  "PRIVATELYOWNED      "= left(isnull('',''), 1) --n/a?

        ,  "COMMENTS	      "= left(isnull('',''), 50) --n/a

        ,  "BATTERYDATE	      "= dbo.ss_formatdate(max(uem.battery_install_dt))
        ,  "AMIFLAG	      "= left(isnull('',''), 1) --logic based on model?

        ,  "AMITYPE	      "= left(isnull('',''), 4) --logic based on model?

        ,  "IPADDRESS	      "= left(isnull('',''), 50) --how to get this?

        ,  "PROBEMETERID	      "= left(isnull('',''), 20) --what is probe meter?

        ,  "PROBEMETERPASSWORD "= left(isnull('',''), 20) -- ''

        ,  "PROBEMETERNAME     "= left(isnull('',''), 4) -- ''

        ,  "UPDATEDATE     "= left(isnull('',''), 8) -- ''

    FROM dbo.vw_meter ub --left join  ub_meter_model umm on umm.model_id = ub.model_id
    LEFT JOIN ub_vw_meter_maint uvlm ON uvlm.location_id = ub.location_id
    LEFT JOIN ub_equip_mxu uem ON uem.model_id = uvlm.model_id
   WHERE ub.location_id <> 1
     AND scrapped IS NULL
   GROUP BY meternumber
          ,  serialnumber
          ,  uvlm.alt_met_num)
   ,  erts AS
  (SELECT "APPLICATION" = left(isnull('3',''), 1) --if sewer(4) do we need to add registers?

        ,  "DEVICETYPE" = left(isnull('1',''), 1) --need to configure remote kinds

        ,  "METERNUMBER" = left(isnull('',''), 12)
        ,  "SERIALNUMBER" = left(isnull('',''), 12)
        ,  "OTHERDEVICETYPE1" = ''--this would be Meter (as a back reference)?

        ,  "OTHERDEVICEID1" = left(isnull('',''), 12)
        ,  "OTHERDEVICEMARRY1" = left(isnull('',''), 1)
        ,  "OTHERDEVICETYPE2" = '' --this would be Register?

        ,  "OTHERMETERNUMBER2" = left(isnull('',''), 12)
        ,  "OTHERDEVICEMARRY2" = left(isnull('',''), 1)
        ,  "METACONFIG" = left(isnull('',''), 2) --add logic to populate this

        ,  "INITIALINSTALLDATE" = dbo.ss_formatdate(max(installed))
        ,  "CURRENTINSTALLDATE" = dbo.ss_formatdate(max(installed))
        ,  "MULTIPLIER" = left('1', 6) --6,6; we will have to import decode_matrix to get this,''), otherwise 1

        ,  "CTNUMBER" = left(isnull('',''), 12) --electric only

        ,  "VTNUMBER" = left(isnull('',''), 12)
        ,  "PONUMBER"= left(isnull('',''), 8) --n/a

        ,  "PODATE	      "= left(isnull('',''), 8) --n/a

        ,  "PURCHASECOST	      "= left(isnull('',''), 9) --9,''),2

        ,  "RETIREDATE	      "= dbo.ss_formatdate(max(scrapped))
        ,  "ASSETTAXDISTRICT" = left(isnull('',''),2)
        ,  "BIDIRECTIONALFLAG  "= left(isnull('',''), 1) --see ub_meter_model.dial_read_direction; irving_vw_mdi.DistrictFlowDirection

        ,  "PRIVATELYOWNED      "= left(isnull('',''), 1) --n/a?

        ,  "COMMENTS	      "= left(isnull('',''), 50) --n/a

        ,  "BATTERYDATE	      "= dbo.ss_formatdate(max(uem.battery_install_dt))
        ,  "AMIFLAG	      "= left(isnull('',''), 1) --logic based on model?

        ,  "AMITYPE	      "= left(isnull('',''), 4) --logic based on model?

        ,  "IPADDRESS	      "= left(isnull('',''), 50) --how to get this?

        ,  "PROBEMETERID	      "= left(isnull('',''), 20) --what is probe meter?

        ,  "PROBEMETERPASSWORD "= left(isnull('',''), 20) -- ''

        ,  "PROBEMETERNAME     "= left(isnull('',''), 4) -- ''

        ,  "UPDATEDATE     "= left(isnull('',''), 8) -- ''

   FROM dbo.vw_meter ub --left join  ub_meter_model umm on umm.model_id = ub.model_id
LEFT JOIN ub_vw_meter_maint uvlm ON uvlm.location_id = ub.location_id
   LEFT JOIN ub_equip_mxu uem ON uem.model_id = uvlm.model_id
   WHERE ub.location_id <> 1
     AND scrapped IS NULL
   GROUP BY meternumber
          ,  serialnumber
          ,  uvlm.alt_met_num)
   ,  regs AS
  (SELECT "APPLICATION" = left(isnull('3',''), 1) --if sewer(4) do we need to add registers?

        ,  "DEVICETYPE" = left(isnull('2',''), 1) --need to configure remote kinds

        ,  "METERNUMBER" = left(isnull(uvlm.alt_met_num,''), 12)
        ,  "SERIALNUMBER" = left(isnull('',''), 12)
        ,  "OTHERDEVICETYPE1" = ''--this would be Meter (as a back reference)?

        ,  "OTHERDEVICEID1" = left(isnull('',''), 12)
        ,  "OTHERDEVICEMARRY1" = left(isnull('',''), 1)
        ,  "OTHERDEVICETYPE2" = '' --this would be Register?

        ,  "OTHERMETERNUMBER2" = left(isnull('',''), 12)
        ,  "OTHERDEVICEMARRY2" = left(isnull('',''), 1)
        ,  "METACONFIG" = left(isnull('',''), 2) --add logic to populate this

        ,  "INITIALINSTALLDATE" = dbo.ss_formatdate(max(installed))
        ,  "CURRENTINSTALLDATE" = dbo.ss_formatdate(max(installed))
        ,  "MULTIPLIER" = left('1', 6) --6,6; we will have to import decode_matrix to get this,''), otherwise 1

        ,  "CTNUMBER" = left(isnull('',''), 12) --electric only

        ,  "VTNUMBER" = left(isnull('',''), 12)
        ,  "PONUMBER"= left(isnull('',''), 8) --n/a

        ,  "PODATE	      "= left(isnull('',''), 8) --n/a

        ,  "PURCHASECOST	      "= left(isnull('',''), 9) --9,''),2

        ,  "RETIREDATE	      "= dbo.ss_formatdate(max(scrapped))
        ,  "ASSETTAXDISTRICT" = left(isnull('',''),2)
        ,  "BIDIRECTIONALFLAG  "= left(isnull('',''), 1) --see ub_meter_model.dial_read_direction; irving_vw_mdi.DistrictFlowDirection

        ,  "PRIVATELYOWNED      "= left(isnull('',''), 1) --n/a?

        ,  "COMMENTS	      "= left(isnull('',''), 50) --n/a

        ,  "BATTERYDATE	      "= dbo.ss_formatdate(max(uem.battery_install_dt))
        ,  "AMIFLAG	      "= left(isnull('',''), 1) --logic based on model?

        ,  "AMITYPE	      "= left(isnull('',''), 4) --logic based on model?

        ,  "IPADDRESS	      "= left(isnull('',''), 50) --how to get this?

        ,  "PROBEMETERID	      "= left(isnull('',''), 20) --what is probe meter?

        ,  "PROBEMETERPASSWORD "= left(isnull('',''), 20) -- ''

        ,  "PROBEMETERNAME     "= left(isnull('',''), 4) -- ''

        ,  "UPDATEDATE     "= left(isnull('',''), 8) -- ''

   FROM dbo.vw_meter ub --left join  ub_meter_model umm on umm.model_id = ub.model_id
LEFT JOIN ub_vw_meter_maint uvlm ON uvlm.location_id = ub.location_id
   LEFT JOIN ub_equip_mxu uem ON uem.model_id = uvlm.model_id
   WHERE ub.location_id <> 1 --exclude warehouse
     AND scrapped IS NULL --if removed date or scrapped can filter out:
   GROUP BY meternumber
          ,  serialnumber
          ,  uvlm.alt_met_num)
SELECT *
FROM meters
UNION ALL
  (SELECT *
   FROM erts)
UNION ALL
  (SELECT *
   FROM regs) 
-- vw_meter

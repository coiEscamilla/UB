--Add in list of countries that Matt sent
SELECT DISTINCT "CUSTOMERID" = left(vc.customer_id, 8)
              ,  "ADDRESSSEQ" = left('', 4)
              ,  "MAILINGNAME" = left(ltrim(rtrim(replace(replace(replace(coalesce(vc.surname,''), char(13) + '' + char(10), ' '), char(9), ' '),char(ascii(',')), ' '))), 35)
              ,  "INCAREOF" = left('', 35)
              ,  "ADDRESS1" = left(left(ltrim(rtrim(replace(replace(replace(coalesce(vma.address_line_1, '') + ' ' + coalesce(vma.address_line_2, '') + ' ' + coalesce(vma.address_line_3, ''), char(13) + '' + char(10), ' '), char(9), ' '), char(ascii(',')), ' '))), 35), 35)
              ,  "ADDRESS2" = left('', 35)
              ,  "CITY" = left(ltrim(rtrim(replace(replace(replace(coalesce(vma.city,''), char(13) + '' + char(10), ' '), char(9), ' '),char(ascii(',')), ' '))), 24)
              ,  "STATE" = left(vma.state, 2)
              ,  "COUNTRY" = left(CASE
                                      WHEN vaa.country IN ('AT','AU','CA','CH','DE','FR','GU','IC','IS','IT','MX','NL','NZ','SA','SK','SP','UK','US') THEN vaa.country
                                      ELSE 'US'
                                  END, 2)
              ,  "POSTALCODE" = left(vma.zip, 15)
              ,  "UPDATEDATE" = left('',8)
FROM vw_customer vc
JOIN vw_mailing_address vma ON vma.customer_id = vc.customer_id
JOIN vw_address_all vaa ON vaa.customer_id = vc.customer_id
WHERE vc.status = 'A'

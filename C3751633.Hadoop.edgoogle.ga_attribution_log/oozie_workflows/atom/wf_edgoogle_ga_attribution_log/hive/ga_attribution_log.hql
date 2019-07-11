set hive.execution.engine = mr;
--set hive.auto.convert.join=false;
set hive.optimize.sort.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;

insert overwrite table ${DATABASE}.ga_attribution_log PARTITION(date_part)
select 
ga_client_id,
eq_id,
app_id,
rownumb,
hits_hitnumber,
hitnumb,
visitId,
visitNumber,
fullvisitorid,
visitorid,
userid,
visitStartTime,
date,
channelGrouping,
newVisits as totals_newVisits,
timeOnSite as totals_timeOnSite,
referralPath as trafficSource_referralPath,
campaign as trafficSource_campaign,
source as trafficSource_source,
medium as trafficSource_medium,
keyword as trafficSource_keyword,
adContent as trafficSource_adContent,
browser as device_browser,
browserVersion as device_browserVersion,
browserSize as device_browserSize,
operatingSystem as device_operatingSystem,
operatingSystemVersion as device_operatingSystemVersion,
isMobile as device_isMobile,
mobileDeviceBranding as device_mobileDeviceBranding,
mobileDeviceModel as device_mobileDeviceModel,
mobileInputSelector as device_mobileInputSelector,
mobileDeviceInfo as device_mobileDeviceInfo,
mobileDeviceMarketingName as device_mobileDeviceMarketingName,
flashVersion as device_flashVersion,
javaEnabled as device_javaEnabled,
screenColors as device_screenColors,
screenResolution as device_screenResolution,
deviceCategory as device_deviceCategory,
country as geoNetwork_country,
region as geoNetwork_region,
city as geoNetwork_city,
cityId as geoNetwork_cityId,
latitude as geoNetwork_latitude,
longitude as geoNetwork_longitude,
--isEntrance as hits_isEntrance,
hits_isentrance, 
hits_isexit, 
hits_referer, 
hits_page_hostname, 
hits_page_pagepath, 
hits_page_pagetitle, 
hits_appinfo_screenname, 
hits_appinfo_landingscreenname, 
hits_appinfo_exitscreenname,
date_part
from (
  select 
  case when ind5.value is not null then ind5.value else ind5_group.value end as ga_client_id,
  case when ind7.value is not null then ind7.value else ind7_group.value end as eq_id,
  case when ind8.value is not null then ind8.value else ind8_group.value end as app_id,
  ga_hitnumb_log_${TMP_TABLE_TYPE}.*
  from ${TMP_DATABASE}.ga_hitnumb_log_${TMP_TABLE_TYPE}
  left join ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} ind5 
  on ga_hitnumb_log_${TMP_TABLE_TYPE}.hitnumb = ind5.hitnumb and ga_hitnumb_log_${TMP_TABLE_TYPE}.date_part = ind5.date_part and ind5.index = 5 and ind5.value is not null
  left join ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} ind7
  on ga_hitnumb_log_${TMP_TABLE_TYPE}.hitnumb = ind7.hitnumb and ga_hitnumb_log_${TMP_TABLE_TYPE}.date_part = ind7.date_part and ind7.index = 7 and ind7.value is not null
  left join ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} ind8
  on ga_hitnumb_log_${TMP_TABLE_TYPE}.hitnumb = ind8.hitnumb and ga_hitnumb_log_${TMP_TABLE_TYPE}.date_part = ind8.date_part  and ind8.index = 8 and ind8.value is not null 
  left join (select ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part, ga_customdimensions_log_${TMP_TABLE_TYPE}.fullvisitorid, ga_customdimensions_log_${TMP_TABLE_TYPE}.value
                   from ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} left join (select fullvisitorid, date_part, count(distinct value) from ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} where 1=1 and index = 5 and value is not null   group by fullvisitorid, date_part having count(distinct value) = 1) ind5_list on ga_customdimensions_log_${TMP_TABLE_TYPE}.fullvisitorid = ind5_list.fullvisitorid 
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part = ind5_list.date_part
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.index = 5
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.value is not null
                                                                   
                                                                                          where 1=1 
                                                                                          and ind5_list.fullvisitorid is not null
                                                                                          group by ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part, ga_customdimensions_log_${TMP_TABLE_TYPE}.fullvisitorid, ga_customdimensions_log_${TMP_TABLE_TYPE}.value) ind5_group
  on ga_hitnumb_log_${TMP_TABLE_TYPE}.fullvisitorid = ind5_group.fullvisitorid and ga_hitnumb_log_${TMP_TABLE_TYPE}.date_part = ind5_group.date_part   
  left join (select ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part, ga_customdimensions_log_${TMP_TABLE_TYPE}.fullvisitorid, ga_customdimensions_log_${TMP_TABLE_TYPE}.value
                   from ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} left join (select fullvisitorid, date_part, count(distinct value) from ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} where 1=1 and index = 7 and value is not null   group by fullvisitorid, date_part having count(distinct value) = 1) ind7_list on ga_customdimensions_log_${TMP_TABLE_TYPE}.fullvisitorid = ind7_list.fullvisitorid 
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part = ind7_list.date_part
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.index = 7
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.value is not null
                                                                                     
                                                                                          where 1=1 
                                                                                          and ind7_list.fullvisitorid is not null
                                                                                          group by ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part, ga_customdimensions_log_${TMP_TABLE_TYPE}.fullvisitorid, ga_customdimensions_log_${TMP_TABLE_TYPE}.value) ind7_group
  on ga_hitnumb_log_${TMP_TABLE_TYPE}.fullvisitorid = ind7_group.fullvisitorid and ga_hitnumb_log_${TMP_TABLE_TYPE}.date_part = ind7_group.date_part  
  left join (select ga_customdimensions_log_${TMP_TABLE_TYPE}.rownumb, ga_customdimensions_log_${TMP_TABLE_TYPE}.value, ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part
                   from ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} left join (select rownumb, date_part, count(distinct value) from ${TMP_DATABASE}.ga_customdimensions_log_${TMP_TABLE_TYPE} where 1=1 and index = 8 and value is not null   group by rownumb, date_part having count(distinct value) = 1) ind8_list on ga_customdimensions_log_${TMP_TABLE_TYPE}.rownumb = ind8_list.rownumb 
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part = ind8_list.date_part                                                                         
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.index = 8
                                                                                          and ga_customdimensions_log_${TMP_TABLE_TYPE}.value is not null
                                                                                          where 1=1 
                                                                                          and ind8_list.rownumb is not null
                                                                                          group by ga_customdimensions_log_${TMP_TABLE_TYPE}.rownumb, ga_customdimensions_log_${TMP_TABLE_TYPE}.value, ga_customdimensions_log_${TMP_TABLE_TYPE}.date_part) ind8_group
  on ga_hitnumb_log_${TMP_TABLE_TYPE}.rownumb = ind8_group.rownumb and ga_hitnumb_log_${TMP_TABLE_TYPE}.date_part = ind8_group.date_part  
  ) as t4;
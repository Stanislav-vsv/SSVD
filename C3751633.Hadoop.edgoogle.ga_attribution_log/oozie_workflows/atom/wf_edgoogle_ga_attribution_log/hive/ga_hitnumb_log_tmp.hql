set hive.execution.engine = mr;
insert overwrite table ${TMP_DATABASE}.GA_HITNUMB_LOG_${TMP_TABLE_TYPE}
select 
  concat (date_part, '_',fullVisitorId, '_', visitnumber) as rownumb,
  concat (date_part, '_',fullVisitorId, '_', visitnumber, '_', hits_hitnumber) AS hitnumb ,
  seq1,
  hits_hitnumber,
  visitId,
  visitNumber,
  fullvisitorid,
  visitorid,
  userid,
  visitStartTime,
  date,
  channelGrouping,
  totals.newVisits,  
  totals.timeOnSite,
  trafficSource.referralPath,
  trafficSource.campaign,
  trafficSource.source,
  trafficSource.medium,
  trafficSource.keyword,
  trafficSource.adContent,
  device.browser,
  device.browserVersion,
  device.browserSize,
  device.operatingSystem,
  device.operatingSystemVersion,
  device.isMobile,
  device.mobileDeviceBranding,
  device.mobileDeviceModel,
  device.mobileInputSelector,
  device.mobileDeviceInfo,
  device.mobileDeviceMarketingName,
  device.flashVersion,
  device.javaEnabled,
  device.screenColors,
  device.screenResolution,
  device.deviceCategory,
  geoNetwork.country,
  geoNetwork.region,
  geoNetwork.city,
  geoNetwork.cityId,
  geoNetwork.latitude,
  geoNetwork.longitude
  ,date_part
  ,hits.isEntrance[seq1]
  ,hits.isExit[seq1]
  ,hits.REFERER[seq1]
  ,hits.page.hostname[seq1]
  ,hits.page.PAGEPATH[seq1]
  ,hits.page.PAGETITLE[seq1]
  ,hits.appinfo.screenname[seq1]
  ,hits.appinfo.landingscreenname[seq1]
  ,hits.appinfo.exitscreenname[seq1]
--  ,hits.customdimensions[seq1]

from

${DATABASE}.ga_sessions_log TMP
LATERAL VIEW posexplode(hits.hitnumber) Explode_hitnumber as seq1 , hits_hitnumber
where date_part between ${LOAD_DATE_FROM} and ${LOAD_DATE_TO};
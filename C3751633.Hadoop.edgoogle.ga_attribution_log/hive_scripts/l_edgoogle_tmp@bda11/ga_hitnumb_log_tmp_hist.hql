DROP TABLE IF EXISTS ${TMP_DATABASE}.ga_hitnumb_log_tmp_hist;
CREATE TABLE ${TMP_DATABASE}.ga_hitnumb_log_tmp_hist(
	  rownumb string, 
	  hitnumb string, 
	  seq1 int, 
	  hits_hitnumber decimal(38,18), 
	  visitid decimal(38,18), 
	  visitnumber decimal(38,18), 
	  fullvisitorid string, 
	  visitorid decimal(38,18), 
	  userid string, 
	  visitstarttime decimal(38,18), 
	  date string, 
	  channelgrouping string, 
	  newvisits decimal(38,18), 
	  timeonsite decimal(38,18), 
	  referralpath string, 
	  campaign string, 
	  source string, 
	  medium string, 
	  keyword string, 
	  adcontent string, 
	  browser string, 
	  browserversion string, 
	  browsersize string, 
	  operatingsystem string, 
	  operatingsystemversion string, 
	  ismobile boolean, 
	  mobiledevicebranding string, 
	  mobiledevicemodel string, 
	  mobileinputselector string, 
	  mobiledeviceinfo string, 
	  mobiledevicemarketingname string, 
	  flashversion string, 
	  javaenabled boolean, 
	  screencolors string, 
	  screenresolution string, 
	  devicecategory string, 
	  country string, 
	  region string, 
	  city string, 
	  cityid string, 
	  latitude string, 
	  longitude string, 
	  date_part int, 
  hits_isentrance boolean, 
  hits_isexit boolean, 
  hits_referer string, 
  hits_page_hostname string, 
  hits_page_pagepath string, 
  hits_page_pagetitle string, 
  hits_appinfo_screenname string, 
  hits_appinfo_landingscreenname string, 
  hits_appinfo_exitscreenname string
--,hits_customdimensions array<struct<index:decimal(38,18),value:string>>
)
ROW FORMAT SERDE 
	  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
	STORED AS INPUTFORMAT 
	  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
	OUTPUTFORMAT 
	  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
TBLPROPERTIES ('kite.compression.type'='snappy');
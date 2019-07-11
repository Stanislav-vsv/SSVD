	CREATE TABLE ${TMP_DATABASE}.ga_customdimensions_log_tmp_hist(
	  hitnumb string, 
	  hits_hitnumber decimal(38,18), 
	  rownumb string, 
	  fullvisitorid string, 
	  --index decimal(38,18), 
	  value string, 
	  date_part int)
	partitioned by (index int)
	ROW FORMAT SERDE 
	  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
	STORED AS INPUTFORMAT 
	  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
	OUTPUTFORMAT 
	  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
TBLPROPERTIES ('kite.compression.type'='snappy');
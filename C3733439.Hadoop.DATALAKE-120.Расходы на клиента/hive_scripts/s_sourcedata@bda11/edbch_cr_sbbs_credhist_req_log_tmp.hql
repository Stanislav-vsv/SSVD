CREATE EXTERNAL TABLE ${TMP_DATABASE}.edbch_cr_sbbs_credhist_req_log_tmp(
  evnum        string,
  evtime       string,
  customer_id  string,
  channel_id   string,
  req_result   string,
  job_insert   double,
  job_update   double,
  job_request  double,
  as_of_dttm   string,
  bureau_id    string,
  chain_id     string
  )
ROW FORMAT SERDE
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
'${PATH_TO_TMP}/edbch_cr_sbbs_credhist_req_log_tmp';
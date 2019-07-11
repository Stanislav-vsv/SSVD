set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;

insert overwrite table ${DATABASE}.${TABLE_NAME} PARTITION(month_part)
select 
	TMP.*,
	from_unixtime(unix_timestamp(substr(${PARTITION_DATE},1,10), 'yyyy-MM-dd'),'yyyyMM') AS month_part
from ${TMP_DATABASE}.${TABLE_NAME}_tmp TMP;
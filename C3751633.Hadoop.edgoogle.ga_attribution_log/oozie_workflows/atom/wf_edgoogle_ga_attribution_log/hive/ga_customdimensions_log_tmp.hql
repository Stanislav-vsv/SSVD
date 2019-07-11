set hive.execution.engine = mr;
set hive.optimize.sort.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;
use ${TMP_DATABASE};
truncate table GA_customdimensions_log_${TMP_TABLE_TYPE};
insert into table ${TMP_DATABASE}.GA_customdimensions_log_${TMP_TABLE_TYPE} PARTITION(index)
SELECT
concat (date_part, '_',fullVisitorId, '_', visitnumber, '_', hits_hitnumber) AS hitnumb ,
hits_hitnumber,
concat (date_part, '_',fullVisitorId, '_', visitnumber) as rownumb,
t2.fullVisitorId,
ehcd.value,
t2.date_part,
ehcd.index
FROM 
${DATABASE}.ga_sessions_log t2
LATERAL VIEW posexplode(hits.hitnumber) Explode_hitnumber as seq1 , hits_hitnumber
LATERAL VIEW EXPLODE (hits.customdimensions[seq1]) expl_hits_customdimensions as ehcd
where  
   ehcd.index in (5,7,8) and date_part between ${LOAD_DATE_FROM} and ${LOAD_DATE_TO};
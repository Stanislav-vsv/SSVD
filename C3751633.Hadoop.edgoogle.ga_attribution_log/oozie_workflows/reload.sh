#!/usr/bin/env bash

HDFS_WF_HOME_DIR=/user/${USER}/oozie_workflows
UNIX_WF_HOME_DIR=/home/${USER}/oozie_workflows
PATCH_HOME_DIR=${PWD}

# ������� ����� ������ ����������� �� ����� � Unix
cp -Rf ${PATCH_HOME_DIR}/atom/* ${UNIX_WF_HOME_DIR}/atom
cp -Rf ${PATCH_HOME_DIR}/ctl/* ${UNIX_WF_HOME_DIR}/ctl
cp -Rf ${PATCH_HOME_DIR}/reg/* ${UNIX_WF_HOME_DIR}/reg
cp -Rf ${PATCH_HOME_DIR}/man/* ${UNIX_WF_HOME_DIR}/man

hadoop fs -put -f ${PATCH_HOME_DIR}/atom/* ${HDFS_WF_HOME_DIR}/atom
hadoop fs -put -f ${PATCH_HOME_DIR}/ctl/* ${HDFS_WF_HOME_DIR}/ctl
hadoop fs -put -f ${PATCH_HOME_DIR}/reg/* ${HDFS_WF_HOME_DIR}/reg
hadoop fs -put -f ${PATCH_HOME_DIR}/man/* ${HDFS_WF_HOME_DIR}/man
#for d in ${PATCH_HOME_DIR}/atom/*/ ; do
	#hadoop fs -mkdir ${HDFS_WF_HOME_DIR}/atom/$(basename $d)/lib
	#hadoop fs -put ${PATCH_HOME_DIR}/lib/* ${HDFS_WF_HOME_DIR}/atom/$(basename $d)/lib
#done

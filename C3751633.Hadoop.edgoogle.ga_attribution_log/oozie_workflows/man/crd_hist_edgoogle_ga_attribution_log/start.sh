#!/usr/bin/env bash

# Params to Configure 
#------------------------------------------------------------------
nameNode=hdfs://bda21 
export OOZIE_URL=http://bda21node04.moscow.alfaintra.net:11000/oozie

# Start End Load Dates
coord_start_time=2018-07-30T02:00+0300
coord_end_time=2018-07-30T02:10+0300

# Workflow Path Parameters
wf_reg_path=/user/${USER}/oozie_workflows/reg
wf_ctl_path=/user/${USER}/oozie_workflows/ctl
wf_atom_path=/user/${USER}/oozie_workflows/atom
wf_man_path=/user/${USER}/oozie_workflows/man

#------------------------------------------------------------------

# Coordinator to Run
workflow_application_path=${wf_man_path}/crd_hist_edgoogle_ga_attribution_log


echo "Run oozie job.."
# Run Oozie Job
oozie job -auth KERBEROS \
-config job.properties \
-D nameNode=${nameNode} \
-D wf_atom_path=${wf_atom_path} \
-D workflow_application_path=${workflow_application_path} \
-D coord_start_time=${coord_start_time} \
-D coord_end_time=${coord_end_time} \
-run
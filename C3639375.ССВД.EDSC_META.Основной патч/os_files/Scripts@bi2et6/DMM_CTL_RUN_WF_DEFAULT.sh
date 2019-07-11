#!/bin/ksh
# $1 - Integration Service Name
# $2 - Datamart Name
# $3 - Folder Name
# $4 - Workflow Name
# $5 - Param File Name

set -x

echo '1'
spath=`dirname $0`

cd $spath
cd ..
echo '2'
PMRootDir=`pwd`
set +x
CFGFILENAME='./ETL_Config/access_params_'$2'_'$1'.cfg'


. $CFGFILENAME


# if 4th parameter is null
if [ -z "$4" ]
then
  pmcmd startworkflow -u $INFORM_USER -p $INFORM_PWD -sv $SERVICE -d $DOMAIN -f $3 -wait $4
  PART=`echo $?`
else
  PARAM=$PMRootDir'/Param/'$5'.PARAM'
  pmcmd startworkflow -u $INFORM_USER -p $INFORM_PWD -sv $SERVICE -d $DOMAIN -paramfile $PARAM -f $3 -wait $4
  PART=`echo $?`
fi

echo $PART
if [ $PART != 0 ]; then exit 1;
fi
#!/bin/bash
#YYYYMMDD
#cd ..
#cd ..
#PMRtDir=`pwd`


# Parameters Specification
# $1 - $$P_EXTSERVICE_CODE
# $2 - $$P_EXTSERVICE_BASEURL
# $3 - $$P_START_DATE 
# $4 - $$P_END_DATE 
# $5 - $PMFolder_Name
# $6 - $PMRootDir

# Variables Check 
echo "$6"
if [ -z "$6" ]
then 
 echo 'Not enough parameters!'
 exit 1;
fi 

# Variables assignment

#P_EXTSERVICE_CODE=$1
#echo $P_EXTSERVICE_CODE
P_EXTSERVICE_CODE=$1
P_HDFS_BASE_FOLDER=$2
P_START_DATE=$3
P_END_DATE=$4
PMFolderName=$5
PMRtDir=$6
echo $PMRtDir

#P_LOADING_DATE=$P_END_DATE
P_LOADING_DATE=$P_START_DATE

TgtFolder=$PMRtDir'/'$PMFolderName'/TgtFiles'

	if ! hadoop fs -test -e $P_HDFS_BASE_FOLDER &> /dev/null
	 then
		echo "HDFS Directory $P_HDFS_BASE_FOLDER does not exist...creating"	
		hadoop fs -mkdir -p $P_HDFS_BASE_FOLDER
	elif ! hadoop fs -test -d $P_HDFS_BASE_FOLDER &> /dev/null
	then
		echo "$P_HDFS_BASE_FOLDER already exists but is not a directory" 1>&2
		exit 1;

	fi


while [[ ! $P_LOADING_DATE > $P_END_DATE ]]; do
	# Variables assignment
	echo 'Processing DATE '$P_LOADING_DATE
        #SRCFILE=$TgtFolder/$P_EXTSERVICE_CODE'_'$P_LOADING_DATE.json
	SRCFILE=$TgtFolder/$P_EXTSERVICE_CODE'_'$P_LOADING_DATE.gz
	echo "SRCFILE=$SRCFILE"

	echo 'HDFSFolder='$P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE
	# Create directory if it does not exists
	if ! hadoop fs -test -e $P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE &> /dev/null
	 then
		echo "HDFS Directory does not exist...creating"	
		hadoop fs -mkdir -p $P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE
	elif ! hadoop fs -test -d $P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE &> /dev/null
	 then
		echo "$P_HDFS_BASE_FOLDER already exists but is not a directory" 1>&2
		exit 1;
	fi


	if [ -e $SRCFILE ]; then
		if [ -f $SRCFILE ]; then
			if [ -s $SRCFILE ]; then
				echo "Moving data file to $P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE/"
				#hadoop fs -put -f $SRCFILE $P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE/$P_EXTSERVICE_CODE'.json'
				hadoop fs -put -f $SRCFILE $P_HDFS_BASE_FOLDER/date_part=$P_LOADING_DATE/$P_EXTSERVICE_CODE'.gz'
				echo "Data file upload complete. Deleting source file"
				rm $SRCFILE
				echo "Cleanup process complete"
			else
				echo "No data for given date. skipping"
			fi
		fi
	else
		echo "No data for given date. skipping"
	fi
	echo 'End of processing DATE '$P_LOADING_DATE
        P_LOADING_DATE=$(date -d "$P_LOADING_DATE + 1 day" +%Y%m%d)
done
	echo '######## Process complete!'
	
exit 0;



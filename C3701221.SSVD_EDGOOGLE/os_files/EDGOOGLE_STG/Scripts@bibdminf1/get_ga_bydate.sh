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

GOOGLE_SDK="/home/informatica/google-cloud-sdk/google-cloud-sdk/bin"
P_EXTSERVICE_CODE=$1
echo $P_EXTSERVICE_CODE
P_EXTSERVICE_BASEURL=$2
P_START_DATE=$3
P_END_DATE=$4
PMFolderName=$5
PMRtDir=$6
echo $PMRtDir

#P_LOADING_DATE=$P_END_DATE
P_LOADING_DATE=$P_START_DATE

TgtFolder=$PMRtDir'/'$PMFolderName'/TgtFiles'
DownloadFolder=$PMRtDir'/'$PMFolderName'/Download'

	echo 'DownloadFolder='$DownloadFolder
	# Create directory if it does not exists
	if [[ ! -e $DownloadFolder ]]; then
		mkdir $DownloadFolder
	elif [[ ! -d $DownloadFolder ]]; then
		echo "$DownloadFolder already exists but is not a directory" 1>&2
		exit 1;
	fi
	# Create directory if it does not exists
	if [[ ! -e $TgtFolder ]]; then
		mkdir $TgtFolder
	elif [[ ! -d $TgtFolder ]]; then
		echo "$TgtFolder already exists but is not a directory" 1>&2
		exit 1;
	fi


while [[ ! $P_LOADING_DATE > $P_END_DATE ]]; do
	# Variables assignment
	echo 'Processing date '$P_LOADING_DATE
        SOURCEURL=$P_EXTSERVICE_BASEURL'_'$P_LOADING_DATE'*.gzip'
        SRCFILES=$DownloadFolder'/'$P_EXTSERVICE_CODE'_'$P_LOADING_DATE'*.gzip'
	echo "SOURCEURL=$SOURCEURL"
	echo "SRCFILES=$SRCFILES"
	echo "Downloading Files..."
	gsutil cp $SOURCEURL  $DownloadFolder
	echo "Download complete..."

	if  ls $SRCFILES 1> /dev/null 2>&1; then
		echo "Extracting files..."	
		#gunzip -dcS gzip $SRCFILES > $TgtFolder'/'$P_EXTSERVICE_CODE'_'$P_LOADING_DATE.json
		cat $SRCFILES > $TgtFolder'/'$P_EXTSERVICE_CODE'_'$P_LOADING_DATE.gz
		echo "Extract complete. Deleting source files"
		rm $SRCFILES
		gsutil rm $SOURCEURL
		echo "End of cleanup operation"
	else
		echo "No source files for given date, skipping processing"
	fi
	echo 'Processing date '$P_LOADING_DATE' complete'
        P_LOADING_DATE=$(date -d "$P_LOADING_DATE + 1 day" +%Y%m%d)
done
	echo '######## Process complete!'
	
exit 0;

#!/bin/sh

HOST="14.14.14"
folder="/tmp/myLanScan/"
hostFile="$folder""myhost.txt"
HOST=`cat $hostFile`
FILENAME=$(date +%Y%m%d_%H)
FILEPATH="$folder"$FILENAME
LOG_PATH="$folder"$(date +%Y%m%d)"_log"
echo log path is $LOG_PATH

current=1
[ ! -f $FILEPATH ] && {
	echo no logs ,exit
	exit 1
}
IP_LIST=$(cat $FILEPATH)
echo all IPs is $IP_LIST
echo -----------------------------------
[ ! -f $LOG_PATH ] && echo "" > $LOG_PATH
echo "Time:"$(date +%F_%T) >> $LOG_PATH
until [ $current -eq 255 ]
do
	count=$(cat $FILEPATH | grep "^$HOST.$current$" -c)
	if [ $count -gt 0 ];then 
		mOutput=$HOST.$current"______________________"
		times=0
		until [ $times -eq $count ]
		do
			mOutput=$mOutput"■"
			times=$((times+1))
		done
		echo $mOutput
		echo $mOutput >> $LOG_PATH
	fi 
	current=$((current+1))
done
#用换行符隔开
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH

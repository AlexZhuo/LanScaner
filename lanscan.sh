#!/bin/sh

HOST="14.14.14"
echo start scan

while [ 1 -lt 2 ]
do

FILENAME=$(date +%Y%m%d_%H)
FILEPATH="/tmp/"$FILENAME
echo $FILEPATH
TOTAL=0
IP_LIST=""

current=1
until [ $current -eq 255 ]
do
	result=$(ping $HOST.$current -c 2 -w 2)	#每个IP发送两次，全部等待最多2秒
	loss_rate=$(echo $result | awk -F " --- " '{print $3}' | awk -F ", " '{print $3}' | cut -d "%" -f 1) # 统计丢包率
	if [ $loss_rate -lt 100 ];then
		TOTAL=$((TOTAL+1))
		echo $HOST.$current  is ONLINE !!!!!!!!!!!! TOTAL IP is $TOTAL
		[ ! -f "$FILEPATH" ] && echo "" > $FILEPATH
		echo  $HOST.$current >> $FILEPATH
		IP_LIST=$IP_LIST"\n"$HOST.$current
	else
		echo $HOST.$current  is offline
	fi
	current=$((current+1))
done
echo -e all IPs is $IP_LIST

done


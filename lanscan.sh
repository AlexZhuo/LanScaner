#!/bin/sh

HOST="14.14.14"
folder="/tmp/myLanScan/"
hostFile="$folder""myhost.txt"
if [ ! -d "$folder" ]; then
	mkdir "$folder"
fi
while getopts "h:bc" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             h)
				echo 'host ip is' $OPTARG
				HOST=$OPTARG
				echo $HOST > "$hostFile"
                ;;
             b)
                
                ;;
             c)
               
                ;;
             ?) #当有不认识的选项的时候arg为?
            echo "请使用-h参数指定网段"
        exit 1
        ;;
        esac
done

echo start scan

while [ 1 -lt 2 ]
do

FILENAME=$(date +%Y%m%d_%H)
FREENAME="free_"$(date +%Y%m%d_%H)
FILEPATH="$folder"$FILENAME
FREEPATH="$folder"$FREENAME
echo $FILEPATH
TOTAL=0
IP_LIST=""
FREE_LIST=""

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
		[ ! -f "$FREEPATH" ] && echo "" > $FREEPATH
		echo  $HOST.$current >> $FREEPATH
		FREE_LIST=$FREE_LIST"\n"$HOST.$current
		echo $HOST.$current  is offline
		
	fi
	current=$((current+1))
done
echo -e all engaged IPs is $IP_LIST
echo -e all free IPs is $FREE_LIST
done



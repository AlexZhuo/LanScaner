#!/bin/sh

HOST="14.14.14"
folder="/tmp/myLanScan/"
hostFile="$folder""myhost.txt"
HOST=`cat $hostFile`
FILENAME=$(date +%Y%m%d_) #该文件这里去掉小时数，所以不是完整的文件路径
FILEPATH="$folder"$FILENAME
LOG_PATH="$folder"$(date +%Y%m%d)"_log" #这里的输出log位置和按小时输出的log位置是同一个文件
echo log path is $LOG_PATH

current=1

[ ! -f $LOG_PATH ] && echo "" > $LOG_PATH
echo "Time:"$(date +%F_%T) >> $LOG_PATH
echo "==============DAYLY LOG=============" >> $LOG_PATH
until [ $current -eq 255 ] #遍历所有IP
	do
	ip_count=0 #某个IP在一整天所有记录中出现的次数
	for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 #统计该IP在一天内24个log中出现的次数
	do
		hourlyPath=$FILEPATH$i #指向某小时的log
		[ ! -f $hourlyPath ] && {
			#echo no log for $hourlyPath
			continue
		}
		count=$(cat $hourlyPath | grep "^$HOST.$current$" -c) #某个IP在某小时的LOG中出现的次数
		#echo IP times $HOST.$current for $hourlyPath is $count
		ip_count=$(($ip_count+$count))
		#echo now the this ip shows $ip_count times
	done

	
	if [ $ip_count -gt 0 ];then #如果该IP出现次数超过1次
		mOutput=$HOST.$current"..................."
		times=0 #这里的times是控制条长度用的
		until [ $times -eq $ip_count ]
		do
			mOutput=$mOutput"■"
			times=$((times+1))
		done
		echo $mOutput shows $ip_count times
		echo $mOutput "($ip_count times)">> $LOG_PATH
	fi 
	current=$((current+1))
done
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


	



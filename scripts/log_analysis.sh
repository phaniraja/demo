#!/bin/bash

LOG_FILE="/home/ubuntu/logfile1"
cat $LOG_FILE | awk '{print $7,$9,$NF}' | grep 200 > /home/ubuntu/logfile_200


while read -r line

do 
	url=`echo $line | awk '{print $1}'`
	status_code=`echo $line | awk '{print $2}'`
	ms=`echo $line | awk '{print $NF}'`
	sec=`expr $ms / 1000`
	echo "STATUS_CODE = $status_code URL = $url RESPONSE_TIME_SEC = $sec"

done < "logfile_200"






#num=0

#while [ "$num" -lt 100 ]
#do
#	num=`expr $num + 1`
#	echo $num
#done	 

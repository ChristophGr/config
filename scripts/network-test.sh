#!/bin/sh
URL=orf.at
IP=194.232.104.140

IP2=193.99.144.80

while [ -z $RUNNING ]; do
	DATE=`date +%F_%H:%M:%S`
	ping -c1 -w1 $IP > /dev/null || ping -c1 -w1 $IP2 > /dev/null
	if [ $? == 0 ]; then
		echo "$DATE, 1"
	else
		echo "$DATE, 0"
	fi
	sleep 1
done

function stop(){
	RUNNING="false"
	exit 1
}
trap stop SIGINT
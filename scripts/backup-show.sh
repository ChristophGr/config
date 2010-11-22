#!/bin/sh
PID=$1
echo pid is $PID

function stop(){
	echo
	echo stopping
	kill $PID
	sleep 4
	exit 1
}

trap stop SIGINT

tail -f /tmp/backup.log

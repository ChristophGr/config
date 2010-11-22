#!/bin/sh
for FILE in `find -iname '*lua'`; do
	luac -p $FILE
	if [ $? != 0 ]; then
		echo result $?
		exit 1
	fi
done
#!/bin/bash
# on_ac_power
#if [ $? == 0 ]; then
echo $0
SFILE=$HOME/.enable3d
if [ -e "$SFILE" ]; then
	sh $(dirname "$0")/compiz2.sh 3
else
	sh $(dirname "$0")/compiz2.sh 2
fi


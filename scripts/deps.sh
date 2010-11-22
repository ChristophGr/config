#!/bin/sh
function mlist(){
	yum list installed | awk '{print $1}' | grep -v "^@"
}

TMPFILE="/tmp/mdeplist"
echo > $TMPFILE

for P in `mlist`; do
	echo "### $P ###"
	yum deplist $P | grep provider | awk '{print $2}' >> $TMPFILE
done

cat $TMPFILE | sort -u > /tmp/cdeplist


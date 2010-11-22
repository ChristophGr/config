#!/bin/bash

FILE=/tmp/list.tmp
PATTERN="*.lua"

## find if there is one orig file
ORIGS=`find -iname '*.orig' | head -n 1`
if [ $ORIGS ]; then
	echo "Trailing wehitespaces have been removed."
	echo "check all .orig files and remove them."
	exit 1
fi

NEWS=`find -iname '*.new' | head -n 1`
if [ $NEWS ]; then
	echo "whitspace-trimming in progress"
	exit 1
fi

find . -path ./.git -prune -o -print | grep -v "./libs" | egrep -v "^.$" > $FILE
read SRC < $FILE
while [ $SRC ]
do
	read SRC
	if [ -z $SRC ]; then
#		echo $SRC
		break
	fi
	file=`echo $SRC | sed s/"^\.\/"//`
#	echo "\"$file\""
	file $file | grep directory > /dev/null
  if [ $? != 1 ]; then
#		echo "continue"
		continue
  fi

	if [ $SRC ]; then
		cp $SRC $SRC.orig
		cat $SRC | sed -r s/"[[:space:]]+$"// > $SRC.new
		
		mv $SRC.new $SRC
		diff $SRC $SRC.orig > /dev/null && rm $SRC.orig
	fi
		
done < $FILE
ORIGS=`find -iname '*.orig' | head -n 1`
if [ $ORIGS ]; then
		echo "Trailing whitespaces have been removed."
		find -iname '*.orig' -print | sed -r s/".orig$"//
		exit 1
fi

rm $FILE
exit 0


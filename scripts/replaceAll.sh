#!/bin/sh
PATTERN='*.xml'

function replaceAll(){
	find -iname $PATTERN | grep -v "\\.git" | while read FILE; do
		cat $FILE | sed s/"$1"/"$2"/ > ${FILE}_
		mv ${FILE}_ $FILE
	done
}
#!/bin/sh
git branch | grep -v "^*" | while read b; do
	if ! (git branch -r | grep "origin/$b") then
		git branch -d $b
	else
		echo "skip $b"
	fi
done

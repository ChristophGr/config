#!/bin/sh

if [ -z "$1" ]; then
	exit 0
fi

echo executing \"mpc $@\" >&2

case "$1" in
load | stop | random | play | clear)
	echo executing \"mpc $@\" >&2
	exit 0
	;;
add)
	if [ -z "$2" ]; then
		while read -t1 line; do
			echo "adding $line"
		done
	fi
	;;
*)

	mpc $@
	;;
esac
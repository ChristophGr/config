#!/bin/sh
i=0
for stamp in $(mpc | egrep -o "[[:digit:]]+:[[:digit:]]+"); do
	stamps[i]=$stamp
	let i=i+1
done
echo ${stamps[0]}
echo ${stamps[1]}



if [ "${stamps[1]}" == "0:00" ]; then
	exit
fi

echo ${stamps[0]} > $HOME/.mpdstate

mpc | egrep -o "#[[:digit:]]+" | egrep -o "[[:digit:]]+" >> $HOME/.mpdstate
mpc | egrep -o "random: [[:alpha:]]+" | sed s/"random: "// >> $HOME/.mpdstate

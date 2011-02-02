#!/bin/sh
function readvars(){
	read TIMESTAMP
	read NUM
	read RANDOM_STATE
	read ALBUM
}

readvars < $HOME/.mpdstate

echo $TIMESTAMP
echo $NUM
echo $RANDOM_STATE

mpc clear
if [ -z $ALBUM ]; then
	mpc load last
else
	mpc find album "$ALBUM"
	mpc find album "$ALBUM" | mpc add
	echo "playing" > $HOME/.mpdstate
	echo "$ALBUM" >> ~/.mpdstate
fi
mpc play $NUM
mpc seek $TIMESTAMP
mpc random "$RANDOM_STATE"

#!/bin/sh
function readvars(){
	read TIMESTAMP
	read NUM
	read RANDOM_STATE
}

readvars < $HOME/.mpdstate

echo $TIMESTAMP
echo $NUM
echo $RANDOM_STATE

mpc clear
mpc load last
mpc play $NUM
mpc seek $TIMESTAMP
mpc random "$RANDOM_STATE"

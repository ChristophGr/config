#!/bin/sh
synd=`pidof syndaemon`


if [ -n "$synd" ]; then
	kill $synd
	synclient TouchpadOff=1
	notify-send Touchpad -t 1500 "Touchpad is now OFF" -i /usr/share/icons/gnome/scalable/actions/gtk-cancel.svg
	touch $HOME/.touchpadoff
else
	state=`synclient -l | grep TouchpadOff | sed s/TouchpadOff// | sed 's/^[= \t]*//'`
	if [ $state == "1" ]; then
		syndaemon -t -i 2 -d
		synclient TouchpadOff=2
	fi
	notify-send Touchpad -t 1500 "Touchpad is now ON" -i /usr/share/icons/gnome/scalable/emblems/emblem-default.svg
	rm $HOME/.touchpadoff
fi

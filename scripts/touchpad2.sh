#!/bin/sh
if [ -e $HOME/.touchpadoff ]; then
	synclient TouchpadOff=1
	notify-send Touchpad -t 10000 "Touchpad is now OFF" -i /usr/share/icons/gnome/scalable/actions/gtk-cancel.svg
else
	syndaemon -t -i 2 -d
fi

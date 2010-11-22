#!/bin/bash

## mixer_applet_val_path = /apps/panel/applets/mixer_screen0/prefs/active-element
## val_usb = USB Device 0xccd:0x77 (Alsa mixer)
## val_normal = /apps/panel/applets/mixer_screen0/prefs/active-element

## /apps/panel/applets/mixer_screen0/prefs/active-track
## PCM

## hotkeys-setup:

## /desktop/gnome/sound/default_mixer_device
## * alsamixer:hw:1
## * alsamixer:hw:0
## /desktop/gnome/sound/default_mixer_tracks
## * [Speaker]
## * [Master]

#EXPRESSION="{$HOME}/.asoundrc: symbolic link to "
EXPRESSION=".*\.asoundrc\."
CURRENT=`file $HOME/.asoundrc | sed s/$EXPRESSION// | sed s/"'"//`
## echo "current: "$CURRENT


function switch {
	echo "switch: switching (or not)"
	return 0;
}

function show {
	echo "show: current profile is ${CURRENT}"
	return 0;
}

function setprofile {
	echo "setprofile: setting profile $1";
	touch ~/.asoundrc;
	rm ~/.asoundrc;
	case $1 in
		normal)
			rm ~/.asoundrc
			## for multimedia-hotkeys
			gconftool-2 -s /desktop/gnome/sound/default_mixer_device "alsamixer:hw:0" --type string
			gconftool-2 -s /desktop/gnome/sound/default_mixer_tracks "[Master]" --type list --list-type string
			## for applet
			gconftool-2 -s /apps/panel/applets/mixer_screen0/prefs/active-element "HDA Intel (Alsa mixer)" --type string
			gconftool-2 -s /apps/panel/applets/mixer_screen0/prefs/active-track "Master" --type string
			;;
		usb)
			ln -s ~/.asoundrc.usb ~/.asoundrc
			## set usb-card-level to 7% (because it's really loud on headphones)
			amixer sset Speaker 7%
			## for multimedia-hotkeys
			gconftool-2 -s /desktop/gnome/sound/default_mixer_device "alsamixer:hw:1" --type string
			gconftool-2 -s /desktop/gnome/sound/default_mixer_tracks "[Speaker]" --type list --list-type string
			## for applet
			gconftool-2 -s /apps/panel/applets/mixer_screen0/prefs/active-element "USB Device 0xccd:0x77 (Alsa mixer)" --type string
			gconftool-2 -s /apps/panel/applets/mixer_screen0/prefs/active-track "Speaker" --type string
			;;
		hdmi)
			ln -s ~/.asoundrc.hdmi ~/.asoundrc
			## for multimedia-hotkeys
			gconftool-2 -s /desktop/gnome/sound/default_mixer_device "alsamixer:hw:0" --type string
			gconftool-2 -s /desktop/gnome/sound/default_mixer_tracks "[PCM]" --type list --list-type string
			## for applet
			gconftool-2 -s /apps/panel/applets/mixer_screen0/prefs/active-element "HDA Intel (Alsa mixer)" --type string
			gconftool-2 -s /apps/panel/applets/mixer_screen0/prefs/active-track "PCM" --type string
			## TODO
			;;
	esac
	if [ $? ]
	then
		CURRENT=$1;
	fi
	show
	return $?
}



if [ $1 ]
then
	case $1 in
		switch) switch ;;
		show) show ;;
		test) aplay *.wav;;
		*) setprofile $1 ;;
	esac 
else
	show
fi


if [ $2 ]
then
	if [ $2 = "test" ]
	then
		aplay *.wav
	fi
fi

#!/bin/sh
notify-send "mpd: currently playing" "$(mpc current)" -i '/usr/share/icons/gnome/scalable/mimetypes/audio-x-generic.svg'

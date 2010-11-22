#!/bin/bash
MPD_HOME=$HOME/.mpd
MPD_PL=$MPD_HOME/playlists

mpc > /dev/null 2>&1
if [ "$?" != 0 ]; then
	echo not found, starting
	mpd
fi

mpc | grep "^\[playing\] "
if [ $? == 0 ]; then
	$(dirname $0)/mpd_save_state.sh
	mpc stop
	exit 0
fi

## options
CHOICES=$(mpc lsplaylists | grep -v ^last\$)
CHOICE=$(echo "$CHOICES
idobi
woed
resume
" | dmenu -i)

if [ "$?" != 0 ]; then
	exit $?
fi

if [ -z "$CHOICE" ]; then
	CHOICE="resume"
fi

case $CHOICE in
idobi)
	URI=http://idobi.com/services/iradio.pls
	URI_L=http://192.168.2.23:8011
	;;
woed)
	URI=http://www.woed.de/tune-in/listen.pls
	URI_L=http://192.168.2.23:8010
	;;
resume)
	$(dirname $0)/mpd_load_state.sh
	exit 0
	;;
*)
	rm "$MPD_PL/last.m3u"
	ln -s "$MPD_PL/${CHOICE}.m3u" $MPD_PL/last.m3u
	mpc clear
	mpc load "$CHOICE"
	echo ${CHOICE}
	echo "${CHOICE}" | grep -i "\.va$"
	if [ $? == 0 ]; then
		mpc random on
	else
		mpc random off
	fi
	mpc play
	exit 0
	;;
esac

mpc clear
echo URI: $URI
echo URI_L: $URI_L
if [ -e "$URI" ]; then
	GETFILE="cat "
else
	echo wget...
	GETFILE="wget -O - "
fi
echo getting populating
# $GETFILE $URI 2>/dev/null | grep '^File[0-9]*' | sed -e 's/^File[0-9]*=//'
IP=$(nslookup profalbert.dyndns.org | grep Address | tail -n1 | egrep -o "[0-9\.]+")
if [ "$IP" == "192.168.2.23" ]; then
	mpc add "$URI_L"
else
	echo server not found
fi
$GETFILE $URI 2>/dev/null | grep '^File[0-9]*' | sed -e 's/^File[0-9]*=//' | mpc add
mpc play

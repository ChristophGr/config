#!/bin/bash
## usage:
## $0 2 to disable 3d
## $0 3 to enable 3d

SFILE=$HOME/.enable3d

function is_running(){
	P=$1
	PIDL=$(ps uax | egrep "[[:space:]]$P" | grep -v grep | egrep "^$UID")
	test -n "$PIDL"
	return $?
}

function disable_3D(){
	echo resetting gconf-settings to 2D
	gconftool-2 -s /apps/panel/applets/workspace_switcher_screen0/prefs/num_rows "2" --type integer #not required anymore
	gconftool-2 -s /apps/gnome-terminal/profiles/Default/background_type "solid" --type string
#	gconftool-2 -s /apps/panel/toplevels/bottom_panel_screen0/auto_hide "false" --type boolean
#	gconftool-2 -s /apps/panel/toplevels/bottom_panel_screen0/unhide_delay "100" --type integer
#	gconftool-2 -s /apps/panel/toplevels/bottom_panel_screen0/background/type "gtk" --type string
	# replace processes
	## start metacity again
	is_running metacity || metacity --replace &

	killall cairo-dock
	local FILE=/home/profalbert/.config/cairo-dock/current_theme/cairo-dock.conf
	cat $FILE | sed -r s/"^fake transparency\=false$"/"fake transparency\=true"/ | sed -r s/"^visibility=4$"/"visibility=1"/ > "${FILE}_"
	mv "$FILE" "$FILE.bak"
	mv "${FILE}_" "$FILE"
	cairo-dock -c > /dev/null 2>&1 &
	touch $SFILE
	
	rm $SFILE -f
}

function enable_3D(){
	gconftool-2 -s /apps/gnome-terminal/profiles/Default/background_type "transparent" --type string
	# gconftool-2 -s /apps/panel/applets/workspace_switcher_screen0/prefs/num_rows "1" --type integer #not required anymore
	gconftool-2 -s /apps/panel/toplevels/bottom_panel_screen0/auto_hide "true" --type boolean
	gconftool-2 -s /apps/panel/toplevels/bottom_panel_screen0/unhide_delay "1000000" --type integer
	gconftool-2 -s /apps/panel/toplevels/bottom_panel_screen0/background/type "solid" --type string

	# replace processes
	is_running compiz || compiz-manager &

	# reconfig cairo-dock
	killall cairo-dock
	local FILE=/home/profalbert/.config/cairo-dock/current_theme/cairo-dock.conf
	cat $FILE | sed -r s/"^fake transparency\=true$"/"fake transparency\=false"/ | sed -r s/"^visibility=1$"/"visibility=4"/ > "${FILE}_"
	mv "$FILE" "$FILE.bak"
	mv "${FILE}_" "$FILE"
	cairo-dock -o > /dev/null 2>&1 &
	touch $SFILE
}

case $1 in
	3) 
		enable_3D
		;;
	2)
		disable_3D
		;;
esac

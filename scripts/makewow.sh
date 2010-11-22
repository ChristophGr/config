#!/bin/sh
WOWPATH=$1
if [ -z "$WOWPATH" ]; then
	echo "Usage: $0 <destination-path>"
fi

if [ ! -e "$WOWPATH" ]; then
	mkdir -p "$WOWPATH"
fi

ORIGWOW="/media/Data/games/World of Warcraft"

function linkall(){
	local SOURCE=$1
	local TARGET=$2
	ls -1 "$SOURCE" | while [ true ]; do
		read FILE
		if [ -z "$FILE" ]; then
			exit 0
		fi
		ln -s "$SOURCE/$FILE" "$TARGET"
	done
}

echo linking wow
linkall "$ORIGWOW" "$WOWPATH"
echo wow initialized. setting addon links

cd "$WOWPATH"
rm [Ww][Tt][Ff]
cp -r "$ORIGWOW"/[Ww][Tt][Ff] WTF
echo SET gxAPI \"opengl\" >> WTF/Config.wtf
rm [Ii]nterface
mkdir -p Interface/AddOns

echo linking addons
cd Interface/AddOns
linkall "$ORIGWOW/Interface/AddOns" .
echo "done linking addons"

echo "do local addons"
$HOME/Projects/addons/setAddonLinks.sh "$WOWPATH/Interface/AddOns"

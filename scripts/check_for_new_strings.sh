#!/bin/sh
cd Locales
mv Strings.lua Strings.lua.old
lua Babelfish.lua
diff Strings.lua.old Strings.lua > /dev/null
RESULT=$?
rm Strings.lua
mv Strings.lua.old Strings.lua
if [ $RESULT != 0 ]; then
	echo "new locales found"
	exit 1
fi
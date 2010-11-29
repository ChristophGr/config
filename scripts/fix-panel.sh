#!/bin/sh
gconftool-2 -s /apps/panel/toplevels/panel_3/size --type integer 72
sleep 3
gconftool-2 -s /apps/panel/toplevels/panel_3/size --type integer 70


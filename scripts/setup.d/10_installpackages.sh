#!/bin/sh
yum -y install thunderbird chromium thunderbird-lightning sunbird pidgin \
pidgin-otr purple-plugin_pack pidgin-latex pidgin pidgin-birthday-reminder \
vlc mplayer mencoder gecko-mediaplayer \
audacious audacious-plugins-freeworld* \
rhythmbox gstreamer-plugins-ugly gstreamer-plugins-bad gstreamer-ffmpeg \
java-1.6.0-openjdk-{devel,javadoc,plugin,src} \
ntfs-3g ntfs-config ntfsprogs ntfsprogs-gnomevfs \
gnome-games-extra crack-attack \
wget ccsm \
p7zip unrar unace \
gconf-editor system-config-services

yum -y install wine \
samba samba-client \
openoffice.org-{calc,writer,impress} lyx \
autocorr-de hunspell hyphen-de openoffice.org-writer2latex writer2latex \
eclipse maven2 \
git qgit subversion rapidsvn mercurial bzr bzr-gtk cvs\
bash-completion

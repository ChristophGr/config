#!/bin/sh
yum -y install nspluginwrapper.{i686,x86_64} alsa-plugins-pulseaudio.i686
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-i386-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
yum -y install flash-plugin

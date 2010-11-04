#!/bin/sh
gpg --keyserver pgp.mit.edu --recv-keys 0xD66B746E
gpg -a -o /etc/pki/rpm-gpg/RPM-GPG-KEY-skype --export 0xD66B746E

wget http://fedorasolved.org/multimedia-solutions/skype.repo -O /etc/yum.repos.d/skype.repo

yum -y install libXScrnSaver.i?86 libX11.i?86 libv4l.i?86 alsa-plugins-pulseaudio.i?86 qt-x11.i?86
yum -y install skype --nogpgcheck

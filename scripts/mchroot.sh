#!/bin/sh
NROOT=$1
mount -o bind /dev $NROOT/dev
mount -t proc none $NROOT/proc
cp -L /etc/resolv.conf $NROOT/etc/resolv.conf
chroot $NROOT

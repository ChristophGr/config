#!/bin/sh
crontab -l > $HOME/Documents/.contab.bak

LOGFILE="/tmp/backup.log"

HOST="backup2@profalbert.dyndns.org"
BACKUP_UUID="c5a497a5-f026-4f3a-ac93-eb9be6e8bdc7"
DEV_FILE="/dev/disk/by-uuid/$BACKUP_UUID"

BKPDIR=`date +"%Y.%b.%d_%H.%M"`

ARGS="-azuhm"
ARGS="$ARGS --delete"
ARGS="$ARGS --no-p"
ARGS="$ARGS -b "
# --backup-dir \"bkp_$BKPDIR\""
ARGS="$ARGS --include-from=$HOME/.bkplist --exclude-from=$HOME/.bkplist"

if [ -z "$DISPLAY" ]; then
	export DISPLAY=:0.0
fi

function find_mount_point(){
	local TARGET=$(ls -l $DEV_FILE | awk '{print $11}')
	echo $TARGET
	local DEV_FILE_NAME=$(echo $TARGET | egrep -o "[[:alnum:]]*")
	local REAL_DEV_FILE="/dev/$DEV_FILE_NAME"
	MOUNTPOINT=$(grep "^$REAL_DEV_FILE" /etc/mtab | awk '{print $2}')
}

function find_external_disk(){
	while [ ! -e "$DEV_FILE" ]; do
		notify-send -t 9 "Backup" "external disk not found" \
		-i /usr/share/icons/gnome/scalable/devices/drive-harddisk.svg
		echo "dev not found" >> $LOGFILE
		sleep 10
	done
	echo dev found
	find_mount_point

	while [ -z "$MOUNTPOINT" ]; do
		notify-send -t 9 "Backup" "mountpoint not found" \
		-i /usr/share/icons/gnome/scalable/devices/drive-harddisk.svg
		echo "mount-point not found" >> $LOGFILE
		sleep 10
		find_mount_point
	done
	BACKUP_DIR=$MOUNTPOINT/backup
}

notify-send -t 0 "Backup" "Backup started" \
-i /usr/share/icons/gnome/scalable/devices/drive-harddisk.svg

echo > $LOGFILE

## determine destination
ping -c 1 -W1 192.168.2.23 > /dev/null
if [ $? == 0 ]; then
	BACKUP_DIR=$HOST:bkp
else
	find_external_disk
fi

echo "make backup to $BACKUP_DIR" >> $LOGFILE

function dobackup(){
	rsync / $BACKUP_DIR/current \
		--rsh="ssh -i /home/profalbert/.ssh/id_rsa_no" $ARGS \
		--progress -v \
		--backup-dir ../bkp_$BKPDIR \
		>> $LOGFILE 2>&1
	rm -f $LOGFILE
}

dobackup &
PID=$!
echo "started rsync with pid $PID"
COMMAND=$(dirname $0)/backup-show.sh
COMMAND="$COMMAND $PID"
echo $COMMAND
gnome-terminal -e "$COMMAND"

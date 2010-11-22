#!/bin/bash

## from man rsync:
#-r, --recursive             recurse into directories
#-l, --links                 copy symlinks as symlinks
#-p, --perms                 preserve permissions
#-t, --times                 preserve modification times
#-g, --group                 preserve group
#    --devices               preserve device files (super-user only)
#    --specials              preserve special files
#-o, --owner                 preserve owner (super-user only)
#-D                          same as --devices --specials
#
#
#-a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
#
#-z, --compress              compress file data during the transfer
#    --compress-level=NUM    explicitly set compression level
#-u, --update                skip files that are newer on the receiver
#    --inplace               update destination files in-place
#    --append                append data onto shorter files
#    --append-verify         --append w/old data in file checksum
#
#		--delete                delete extraneous files from dest dirs
#
#
#-E, --executability         preserve executability
#-A, --acls                  preserve ACLs (implies -p)
#-X, --xattrs                preserve extended attributes
#
#
#-v, --verbose
#
#-b, --backup
#            With  this  option, preexisting destination files are renamed as
#            each file is transferred or deleted.  You can control where  the
#            backup  file  goes  and what (if any) suffix gets appended using
#            the --backup-dir and --suffix options.
#
#-h, --human-readable        output numbers in a human-readable format
#    --progress              show progress during transfer
#-F                          same as --filter='dir-merge /.rsync-filter'
#                            repeated: --filter='- .rsync-filter'
#    --exclude=PATTERN       exclude files matching PATTERN
#    --exclude-from=FILE     read exclude patterns from FILE
#    --include=PATTERN       don't exclude files matching PATTERN
#    --include-from=FILE     read include patterns from FILE
#    --files-from=FILE       read list of source-file names from FILE
#-m, --prune-empty-dirs      prune empty directory chains from file-list

HOST="backup2@profalbert.dyndns.org"

BKPDIR=`date +"%Y.%b.%d_%H.%M"`

ARGS="-azuhm"
ARGS="$ARGS --delete"
#ARGS="$ARGS --chmod=g+w"
ARGS="$ARGS -b "
# --backup-dir \"bkp_$BKPDIR\""
ARGS="$ARGS --include-from=$HOME/.bkplist --exclude-from=$HOME/.bkplist"

notify-send -t 0 "Backup" "Backup script started" \
-i /usr/share/icons/gnome/scalable/devices/drive-harddisk.svg

ping -c 1 -W1 192.168.2.23 > /dev/null
RESULT=$?
echo "Press Enter to start backup"
if [ "$RESULT" == "0" ]; then
	echo remote
	read
	rsync / $HOST:bkp/current --rsh="ssh -i /home/profalbert/.ssh/id_rsa_no" $ARGS \
	--progress -v \
	--backup-dir $HOST:bkp/bkp_$BKPDIR
else
	echo ext-hdd
	read
	rsync / /media/EXTERN/backup $ARGS --progress -v --backup-dir /media/extern3__/bkp_$BKPDIR
	#gnome-terminal -e backup2.sh
	#$(dirname $0)/backup2.sh
fi

RESULT=$?
echo `date` ": backup-script exit-status $RESULT" >> $HOME/.bkp.log
echo backup exited with $RESULT
read

#!/bin/sh

USER="user"
PASS="xxxxxxxxxxx"
DOMAIN="domain"

IP_ADDR_RE="[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"



registered=$(nslookup $DOMAIN 195.3.96.86 2> /dev/null | tail -n2 | grep -o $IP_ADDR_RE)
echo $registered currently registered

wget http://checkip.dyndns.org -O /tmp/updatedd_ip_check 2> /dev/null
current=`cat /tmp/updatedd_ip_check |cut -d':' -f2|cut -d'<' -f1 |cut -d' ' -f2`
rm /tmp/updatedd_ip_check

#current=$(wget -O /dev/null http://checkip.dyndns.org|sed s/[^0-9.]//g)
echo current is $current
if [ "$current" != "$registered" ] && [ `echo "$current" | grep "^$IP_ADDR_RE$"` ]; then
	echo update
	#wget -O /dev/null http://$USER:$PASS@members.dyndns.org/nic/update?hostname=$DOMAIN 2> /dev/null
else
	false
	echo no update
fi

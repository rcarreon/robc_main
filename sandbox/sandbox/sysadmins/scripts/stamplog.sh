#!/bin/bash
# /usr/local/sbin/stamplog.sh

logfile="$1"

if [ $# -lt 1 ] ; then
	echo ; echo "Usage: $0 /path/to/logfile [-v]"
	echo " -v - print visual heartbeat" ; echo
        exit 0
fi

date "+[%Y-%m-%d %H:%M:%S.%N]: arbitrary log timestamp" >> $logfile
if [ "$2" = "-v" ] ; then
	echo -n "."
fi
sleep 1
exec $0 $1 $2

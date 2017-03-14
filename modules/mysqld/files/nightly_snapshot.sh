#!/bin/bash
#
# Modified 12/15/2010 dleeds Removed manual deletion of snapshots which were
# causing issues with maintenance snapmirrors Changed to snapvault snapshot
# syntax; snapvault config keeps 7 snapshots on primary automatically rotated
# Changed ssh user to zmanda which is limited to snapshot commands
#
# Modified 1/3/2011 dleeds Redid expect code to pre and post snapshot execution
# for placing MySQL server into backup mode, due to some issues in cases where
# executing snapshot via MySQL system call was failing
#
# Added random sleep up to 15 minutes to prevent filer from exhausting
# simultaneous ssh connections and silently dropping the ssh connection.  This
# is why current snaps were skipping/missing days for no apparent reason

# Modified 4/26/2011 gstaples Get rid of the expect code. Maintain error.log
# information. Tighten up netapp device detection. Don't delay 15 minutes when
# running this script manually.

# Environment Variables
PATH="$PATH:/opt/mysql/enterprise/monitor/mysql/bin/"
DATE="`date +%Y%m%d-%H%M`"
DEVICE=$(mount | awk '$3=="/sql/data" {print $1}')

if [ -z "$DEVICE" ];then
    echo "$0: Error: no /sql/data mount" 1>&2
    exit 1
fi

NETAPP=$(echo $DEVICE | cut -d: -f 1)
VOLUME=$(echo $DEVICE | cut -d: -f 2- | awk -F "/" '{print $3}')
if [ -z "$NETAPP" -o -z "$VOLUME" ];then
    echo "$0: no device or volume on mount" 1>&2
    exit 1
fi
mysqlcmd="mysql -u backup --password=backup345  --socket=/var/lib/mysql/mysql.sock"


if ! test -t 0 ;then
   # Random sleep up to 15 minutes if stdin isn't a terminal
   MINUTES=900
   number=0
   while [ "$number" -le 0 ]
   do
     number=$RANDOM
     let "number %= $MINUTES"
   done
   sleep $number
fi

if [ -s /sql/log/error.log-old ] ;then
   # save this old file that didn't get rotated
   mv -f /sql/log/error.log-old /sql/log/error.log-old.$(date +%Y%m%d-%H%M%S)
fi

# Put MySQL into "hotbackup" mode
echo "flush tables with read lock;flush local logs;" |$mysqlcmd || exit 1
sleep 3
if [ -s /sql/log/error.log-old ] ;then
   cat /sql/log/error.log-old >> /sql/log/error.log # get back in there
   rm -f /sql/log/error.log-old
fi

# Take snapshot of MySQL data volume
echo "> Creating sv_daily snapshot on ${VOLUME} at ${DATE}"
/usr/bin/ssh -o "StrictHostKeyChecking no" -l zmanda $NETAPP "snapvault snap create ${VOLUME} sv_daily"
sleep 1

# Put MySQL back into normal mode
echo "unlock tables;" | $mysqlcmd
sleep 3

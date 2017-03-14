#!/bin/sh

PATH="$PATH:/opt/mysql/enterprise/monitor/mysql/bin/"

DATE="`date +%Y%m%d-%H%M`"
MOUNT="/sql/data"
NETAPP=$(grep "${MOUNT}" /etc/fstab | awk '{print $1}' | awk -F ":" '{print $1}')
VOLUME=$(grep "${MOUNT}" /etc/fstab | awk '{print $1}' | awk -F ":" '{print $2}' | awk -F "/" '{print $3}')

#
# Modified 12/15/2010 dleeds
# Removed manual deletion of snapshots which were causing issues with maintenance snapmirrors
# Changed to snapvault snapshot syntax; snapvault config keeps 7 snapshots on primary automatically rotated
# Changed ssh user to zmanda which is limited to snapshot commands
#
if [ ${NETAPP} != "" ]
then
        sleep 1
        echo "> Creating sv_daily snapshot on ${VOLUME} at ${DATE}"
        ssh -o "StrictHostKeyChecking no" -l zmanda $NETAPP "snapvault snap create ${VOLUME} sv_daily"
        sleep 1
else
        echo "> No NetApp volume was found at ${MOUNT}. Aborting!"
fi

#!/bin/bash

######################################################################
# atp_replicate_cron.sh
#
# This is a simple script to keep the actiontrip.com ugc in sync 
# It is called nightly to move data from prd mnt to dev mnt 
######################################################################


/bin/date >> $3
#/usr/bin/rsync --delete --exclude '.snapshot' -ahv $1/ $2 >> $3
/usr/bin/rsync --exclude '.snapshot' -ahv $1/ $2 >> $3
/bin/date >> $3
echo >> $3


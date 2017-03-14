#!/bin/bash

######################################################################
# sdc_replicate_cron.sh
#
# This is a simple script to keep the Sherdog ugc in sync 
######################################################################


/bin/date >> $3
#/usr/bin/rsync --delete --exclude '.snapshot' -ahv $1/ $2 >> $3
/usr/bin/rsync --exclude '.snapshot' -ahv $1/ $2 >> $3
/bin/date >> $3
echo >> $3

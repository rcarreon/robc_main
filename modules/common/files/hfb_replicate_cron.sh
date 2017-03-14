#!/bin/bash

######################################################################
#
# hfb_replicate_cron.sh
#
# This is a simple script to keep the hfb ugc in sync 
# It is called by nightly to move data from lax1 to lax2 
######################################################################


/bin/date >> $3
#/usr/bin/rsync --delete --exclude '.snapshot' -ahv $1/ $2 >> $3
/usr/bin/rsync --exclude '.snapshot' -ahv $1/ $2 >> $3
/bin/date >> $3
echo >> $3


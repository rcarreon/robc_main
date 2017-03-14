#!/bin/bash

######################################################################
# pbwp_replicate_cron.sh
#
# This is a simple script to keep the Pebbled Wordpress ugc in sync 
# It is called nightly to copy data from www to stg and dev 
######################################################################


/bin/date >> $3
#/usr/bin/rsync --delete --exclude '.snapshot' -ahv $1/ $2 >> $3
/usr/bin/rsync --exclude '.snapshot' -ahv $1/ $2 >> $3
/bin/date >> $3
echo >> $3


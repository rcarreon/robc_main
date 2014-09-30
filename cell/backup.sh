#!/bin/bash

date=`date`
ldate=$(date +"%d%m%Y")
location="/app/shared/baks/baka/ccity_$ldate"
ht_back=`rsync -abur  /app/shared/cell/* $location; /bin/tar -cjPf $location.tar $location; rm -rf $location`
sceed=$?
#if [[ $sceed -eq 0 ]]
#then
  #      `echo "Cherry web backup succeed at $date"| /usr/bin/mail -s "Cherry web Backup" rcarreon.gn@gmail.com`
 #       exit 0
#else
#        `echo "Cherry web backup failed at $date"| /usr/bin/mail -s "Cherry web Backup" rcarreon.gn@gmail.com`
#        exit 1
#fi

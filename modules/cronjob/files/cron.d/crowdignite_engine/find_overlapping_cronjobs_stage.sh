#!/bin/bash
OVERLAPS=/tmp/overlapping_cronjobs.txt
HOSTNAME=`hostname`
CONTACT="dev@crowdignite.com noc@evolvemediallc.com"

ps -ef | grep php | egrep ^apache | awk '{print $11}' | sort | uniq -d > $OVERLAPS

if [ -s $OVERLAPS ]; then
  echo "" >> $OVERLAPS
  echo "" >> $OVERLAPS
  uptime >> $OVERLAPS
  echo "" >> $OVERLAPS
  echo "%CPU     %MEM    cronjob" >> $OVERLAPS
  ps auxww --sort=-%cpu | grep php | egrep ^apache | head -10 | awk '{print $3,"\t",$4,"\t",$14}' >> $OVERLAPS

  mailx -s "STG STG STG ALERT:  Overlapping cronjobs on staging $HOSTNAME" $CONTACT < $OVERLAPS
fi

rm -f $OVERLAPS

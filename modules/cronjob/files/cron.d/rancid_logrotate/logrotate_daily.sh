#!/bin/bash
YESTERDAY=`date "+%Y%m%d" -d "$x day ago"`
tar zcvf /app/shared/var/logs/rancid.${YESTERDAY}.tar.gz /app/shared/var/logs/rancid.${YESTERDAY}.*
ls /app/shared/var/logs/rancid.${YESTERDAY}.*|grep -v rancid.${YESTERDAY}.tar.gz|xargs rm -f

#!/bin/bash

# Move logs for Vowpal Wabbit processing out of memory and
# onto persistent storage.

# APP_LOGS
#   lpimpression.log
#   lpclick.log
#   wclick.log

# NGX_LOGS
#   wimpression.log
#   wviewd.log
DATE=`date +%Y%m%d.%H%M`
CLASS=`uname -n | cut -c 1-3`
LOGDIR=/var/vw-log-ramdisk
DESTDIR=/app/data/vwlogs

if [ "$CLASS" == "app" ] ; then
    for VWLOG in lpimpression.log lpclick.log wclick.log; do
	if [ -f ${LOGDIR}/${VWLOG} ]; then
            mv ${LOGDIR}/${VWLOG} ${LOGDIR}/${VWLOG}.${DATE}
	    mv ${LOGDIR}/${VWLOG}.${DATE} ${DESTDIR}/${VWLOG}.${DATE}
	fi
    done
elif [ "$CLASS" == "ngx" ] ; then
    VWLOG=wimpression.log
    VWLOG2=wviewed.log
    if [ -f ${LOGDIR}/${VWLOG} ]; then
        mv ${LOGDIR}/${VWLOG} ${LOGDIR}/${VWLOG}.${DATE}
        mv ${LOGDIR}/${VWLOG}.${DATE} ${DESTDIR}/${VWLOG}.${DATE}
    fi
    if [ -f ${LOGDIR}/${VWLOG2} ]; then
        mv ${LOGDIR}/${VWLOG2} ${LOGDIR}/${VWLOG2}.${DATE}
        mv ${LOGDIR}/${VWLOG2}.${DATE} ${DESTDIR}/${VWLOG2}.${DATE}
    fi
   
fi

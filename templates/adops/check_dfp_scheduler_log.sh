#!/bin/bash

# Checks the dfp scheduler logfile.  If the logfile hasn't been modified 
# for the defined critical time, it tries to kill the running dfp scheduler,
#  and sends an alert email to the Ad Platform team.

# The dfp scheduler process looks like this:
# /bin/sh -c flock -x -n /tmp/dfp_scheduler.lock make -C /app/shared/docroots/dfp/htdocs run-scheduler

DFPLOGDIR=/app/log/dfp/apache
DFPLOG=${DFPLOGDIR}/dfp_scheduler.log
DFPCHECKLOG=${DFPLOGDIR}/dfp_check.log
#CONTACT="chris.haggstrom@evolvemediallc.com"
CONTACT="adplatform@evolvemediallc.com"
DATE=`date`

# Time (in seconds) after which log is presumed to be stale
CRITICAL_TIME=600

SECONDS_SINCE_MOD=`expr $(date +%s) - $(date +%s -r $DFPLOG)`
#echo "Number of seconds since last modification is ${SECONDS_SINCE_MOD}"

if [ ${SECONDS_SINCE_MOD} -gt ${CRITICAL_TIME} ]; then
    
    echo "DFP scheduler log appears to be stale at ${DATE}" >> ${DFPCHECKLOG}
    mailx -s "ALERT:  The DFP scheduler log is stale.  The scheduler may be stopped or wedged" ${CONTACT} < /dev/null

    # get PID
    #PID=$(/bin/ps -ef | grep apache | grep app_dfp_scheduler | grep run-scheduler | grep '/bin/sh' | grep -v grep | awk '{print $2}')
    PID=$(/bin/ps -ef | grep apache | grep dfp | grep htdocs | grep run-scheduler | grep '/bin/sh' | grep -v grep | awk '{print $2}')

    # if PID was obtained, kill the process
    if [ ! -z $PID ]; then
        echo "Current DFP scheduler PID is ${PID}" >> ${DFPCHECKLOG}
        kill -9 ${PID}

        # check for a child Console process
        sleep 5
        CONSOLEPID=$(/bin/ps -ef | grep apache | grep dfp | grep htdocs | grep DfpScheduler | grep Console | grep php | grep -v grep | awk '{print $2}')

        # if child Console process was found, kill it
        if [ ! -z ${CONSOLEPID} ]; then
            echo "Killing the child Console process with PID ${CONSOLEPID}" >> ${DFPCHECKLOG}
            kill -9 ${CONSOLEPID}
        fi
        mailx -s "RESOLVED:  The DFP scheduler has been killed and will restart in a minute" ${CONTACT} < /dev/null
    else
        echo "Could not determine the PID for the running DFP scheduler" >> ${DFPCHECKLOG}
        mailx -s "CRITICAL:  The DFP scheduler could not be restarted.  Please investigate." ${CONTACT} < /dev/null
    fi

fi

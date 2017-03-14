#!/bin/bash
CRONLOGDIR=/app/log/cronjobs
FATALERRORS=/tmp/fatal_errors.txt
HOSTNAME=`hostname`
CONTACT="dev@crowdignite.com"
DATE=`date +%Y%m%d`

# PHP Fatal errors
grep 'Fatal error' ${CRONLOGDIR}/*.log-${DATE} | sed -e 's#/app/log/cronjobs/#\n#' > ${FATALERRORS}
# VW malformed exmaples, (the second line, is the actual line of input vw had issues with)
grep -A1 'malformed example' ${CRONLOGDIR}/*.log-${DATE} | sed -e 's#/app/log/cronjobs/#\n#' >> ${FATALERRORS}

if [ -s ${FATALERRORS} ]; then
  mailx -s "Fatal errors from cronjobs on ${HOSTNAME}" $CONTACT < ${FATALERRORS}
fi

rm -f $FATALERRORS

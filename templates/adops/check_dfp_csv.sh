#!/bin/bash

# Checks the csv files downloaded from dfp, and sends an email alert if:
#   no file exists for today
#   file size is < 1MB
#   number of lines is < 20

CONTACT="adplatform@evolvemediallc.com,michelle.wilken@evolvemediallc.com"

CSVDIR=/app/shared/tmp/dfp_report_scheduler
CSVFILE=$(find $CSVDIR -mtime -1 -name \*.validated.csv | tail -1)

# Check that file exists
if [[ -z $CSVFILE ]]; then
    mailx -s "ALERT:  No validated dfp csv file was found for today" ${CONTACT} < /dev/null
    exit 1
fi    

# Check that file size is > 1024k
FILESIZE=$(ls -lk $CSVFILE | awk '{print $5}')
if [[ $FILESIZE -lt 1024 ]]; then
    mailx -s "ALERT:  The validated dfp csv file is smaller than usual.  Please investigate." ${CONTACT} < /dev/null
    exit 1
fi

# Check that number of lines is > 20
FILELINES=$(wc -l $CSVFILE | awk '{print $1}')
if [[ $FILELINES -lt 20 ]]; then
    mailx -s "ALERT:  The validated dfp csv file has fewer lines than usual.  Please investigate." ${CONTACT} < /dev/null
fi

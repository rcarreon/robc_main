#!/bin/bash
# wrapper to run manage-partition.pl for the first day
# of the next month

DATE="$(date --date="$(date +%Y-%m-15) +1 month" +%Y-%m-01)"

/usr/local/bin/manage-partition.pl ${DATE}

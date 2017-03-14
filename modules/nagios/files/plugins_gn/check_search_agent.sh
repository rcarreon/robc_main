#!/bin/bash

# $Id$

# That script is a wrapper a search for 'movie' on comingsoon.net 
# the purpose is to validate that the agent is effectively running everyday, we allow one day gracfe period

YESTERDAY=`date --date=yesterday +%Y-%m-%d`

URI="/?q=movie&site=2&category=All&mediatype=0&rpp=20&results=1&nwrlimit=3&response=xml&searchmode=1&ignore=1"


/usr/lib64/nagios/plugins/check_http -H search.atomiconline.com -u ${URI} -s ${YESTERDAY}



#!/bin/bash
# A simple script for submitting commit logs via email.
# Author: Jesus R. Camou <j@randroid.net>
# Date: 16/10/2010
# Definitions
PATH=/bin:/usr/bin:/usr/local/bin
REPO=$(echo $1 | cut -c 14-)
CMSG=$(svnlook log $1)
AUT=$(svnlook author -r $2 $1)
DIFF=$(svnlook diff -r $2 $1)
TMP=$(mktemp -t clog)
DATE=$(date)
MAILTO="roberto.carreon@gorillanation.com"

   # Build email message.
   echo "Author: $AUT"  > $TMP
   echo "Date: $DATE"  >> $TMP
   echo "New Revision: $2"  >> $TMP
   echo "$REPO repository"  >> $TMP
   echo "" >> $TMP
   echo "Log:" >> $TMP
   echo "$CMSG" >> $TMP
   echo "" >> $TMP
   echo "$DIFF" >> $TMP

      # Submit commit log as svn user.
      # This SUX:
      cat $TMP | sudo -u svn mail -s "svn commit: r$2 - $REPO" $MAILTO 

   # Clean up.
   rm -rf $TMP

exit 0;

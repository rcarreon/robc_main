#!/bin/sh
#
# Plugin to verify puppet daemon is running and that it updates a health
# file in a timely fashion
#
# by CRW 20100218, copyright Evolvmediacorp

if [ -x /usr/lib64/nagios/plugins/utils.sh ] ; then
  NAGLIBDIR=/usr/lib64/nagios/plugins
elif [ -x /usr/lib/nagios/plugins/utils.sh ] ; then
  NAGLIBDIR=/usr/lib/nagios/plugins
else
  echo "Utils file not found, plugins not installed\?"
  exit 3
fi

# Import the nagios library settings
. $NAGLIBDIR/utils.sh

NAGCHECKFILE=/var/tmp/puppet-nagios-verify.txt
PUPCHECKFILE=/var/lib/puppet/state/state.yaml
CURDATE=`/bin/date`

if [ ! -f $NAGCHECKFILE ] ; then
  echo "puppet UNKNOWN: $NAGCHECKFILE not found"
  echo "First nagios check run $CURDATE" > $NAGCHECKFILE
  exit $STATE_UNKNOWN
fi

if [ ! -f $PUPCHECKFILE ] ; then
  echo "puppet UNKNOWN: $PUPCHECKFILE not found"
  exit $STATE_CRITICAL
fi

LASTPUPPETRUN=`stat -c "%y" $PUPCHECKFILE`

if [ $PUPCHECKFILE -ot $NAGCHECKFILE ] ; then
  echo "puppet CRITICAL: puppet last run $LASTPUPPETRUN"
  exit $STATE_CRITICAL
fi

# Check puppet is running at all
$NAGLIBDIR/check_procs -C puppetd -c 1: > $NAGCHECKFILE 2>&1
if [ $? -ne 0 ] ; then
  /bin/cat $NAGCHECKFILE
  exit $STATE_CRITICAL
fi

# Everything looks good if we're here
echo "puppet OK:  puppet running and last updated $LASTPUPPETRUN"
exit $STATE_OK


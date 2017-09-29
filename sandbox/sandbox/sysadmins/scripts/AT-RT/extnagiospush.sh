#!/bin/sh
#
# This script will push external nagios configs into the cloud:
#   1. export the nagios config files
#   2. generate the AT assets with the export perl script
#   3. push to each server and set master links as needed
#

username=$(id -nu)
if [ "deploy" != "$username" ];then
   echo "Executing $0 as deploy"
   sudo -H -u deploy $0 "$@" 2>&1 

   exit 0
fi

GIT="/usr/bin/git clone"
RMRF="/bin/rm -rf"
ATEXPORT="/home/deploy/AT-RT/atnagiosexport.pl"
SSH="/usr/bin/ssh"
RSYNC="/usr/bin/rsync -rvze $SSH --delete"
LN="/bin/ln -s"
NAGCHECK="/usr/sbin/nagios -v /etc/nagios/nagios.cfg"
NAGRESTART="/usr/bin/sudo /etc/init.d/nagios restart"

NAGGITPATH="git@git.gnmedia.net:/puppet-modules"
LOCALPATH="nagios"
LOCALTMPPATH="/var/tmp/$LOCALPATH"
REMOTEUSER="deploy"
REMOTEPATH="/etc/nagios/"
# The next array is the list of monitoring stations, the first server is
# assumed to be the master
REMOTESERVERS=( mon1.aws1.gnmedia.net mon1.aws2.gnmedia.net )
#REMOTESERVERS=( mon1.aws3.gnmedia.net mon1.aws1.gnmedia.net mon1.aws2.gnmedia.net )
#REMOTESERVERS=( mon1.aws3.gnmedia.net )

DRYRUN=0

if [ -n "$1" ] ; then
    if [ "$1" == "--dryrun" ] ; then
        DRYRUN=1
    fi
fi

$RMRF $LOCALTMPPATH
if [ -e $LOCALTMPPATH ] ; then
    echo $LOCALTMPPATH failed to delete, permission problems
    exit 1
fi
$GIT $NAGGITPATH $LOCALTMPPATH
if [ ! -d $LOCALTMPPATH ] ; then
    echo Failed git clone from $NAGGITPATH to $LOCALTMPPATH
    exit 1
fi
$ATEXPORT
RESULTCODE=$?
if [ ! $RESULTCODE -o ! -d $LOCALTMPPATH/nagios/files/external/conf.d/auto ] ; then
    echo AT export script failed to create automatic files Return code $RESULTCODE
    exit 1
fi

if [ $DRYRUN -eq 1 ] ; then
    echo "Executed dryrun without deploying, check $LOCALTMPPATH for results."
    exit 0
fi

MASTER="1"
for server in ${REMOTESERVERS[@]} ; do
    $RSYNC $LOCALTMPPATH/nagios/files/external/ $REMOTEUSER@$server:$REMOTEPATH
    if [ "$MASTER" == "1" ] ; then
        SOURCEFILE="/etc/nagios/nagios-server.cfg"
        MASTER="0"
    else
        SOURCEFILE="/etc/nagios/nagios-slave.cfg"
    fi
    $SSH $server $LN $SOURCEFILE /etc/nagios/nagios.cfg
    $SSH $server $NAGCHECK
    RESULTCODE=$?
    if [ $RESULTCODE -ne 0 ] ; then
        echo SSH or Nagios checks failed server $server with return code $RESULTCODE
        exit $RESULTCODE
    fi
    $SSH $server $NAGRESTART
done

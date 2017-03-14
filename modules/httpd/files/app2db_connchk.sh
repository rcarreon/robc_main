#!/bin/bash
#
# /etc/cron.hourly/app2db_connchk.sh
# Dairenn Lombard <dairenn.lombard@gorillanation.com>
#
# 2011-08-09: Fixed overly greedy socket state filter.
# 2011-07-20: Added logging
# 2011-07-19: Better regexp to avoid invalid IP addresses and match more socket states
# 2011-07-06: Fixed syntax errors.
# 2011-07-05: MySQL is truncating expired entries now
# 2011-06-22: Ignore invalid IPs and invalid socket states.
# 2011-06-07: Record number of port 3306 connections per address
#	      Fix bug where local MySQL servers are captured in results.
# 2011-05-12: Initial Release

PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/bin
#set -e

# Config options:
curlarg="--max-time 60"

# Enable logging
enablelog="1"

# Run in "debug" mode
debug="0"

# Set URL of VIP Visualizer
targeturl="http://vipvisual.gnmedia.net"

# END CONFIG OPTIONS

logdir="/var/log"
logfile="app_to_sql.log"
logpath="$logdir/$logfile"
# Only an educated guess.
myip=`ifconfig eth0 | grep "inet addr" | cut -d ":" -f 2 | awk '{print $1}'`

if [ "$debug" = "1" ] ; then
	#port="8080"  <-- daemon on 8080 not running any more
	echo ; echo "My IP address is $myip"
	echo ; echo "My target URL is $targeturl:$port"
	else
	port="80"
fi

# MySQL Server is now auto-truncating this
#curl "$targeturl:$port/deleteNode?app_ip=$myip"
for connection_ip in `netstat -an | egrep -e "(*WAIT|SYN*|ESTABLISHED)" | grep ":3306 " | awk '{print $5}' | cut -d ":" -f 1 | sort -n | uniq`
	do
		conns=`netstat -an | grep " $connection_ip:" | egrep -e "(*WAIT|SYN*|ESTABLISHED)" | wc -l`
		curlurl="$targeturl:$port/insertNode?app_ip=$myip&sql_ip=$connection_ip&conns=$conns&nodetype=sql"
		if [ "$debug" = "1" ] ; then
			 echo ; echo "Transmitting HTTP Request $curlurl" ; echo
		fi
		# Don't bother setting a time stamp until after the processing is done and do
		# it for each iteration, not for the entire loop.
		curtime=`date "+%Y-%m-%d %H:%M:%S"`
		stamp="[$curtime]: "
		if [ "$enablelog" = "1" ] ; then
			echo -n "$stamp Transmitted HTTP Request: $curlurl with output from curl: " >> $logpath
			VERBAGE=$( curl $curlarg "$curlurl" 2>&1 )
                        CURLEXIT=$?
			echo "$VERBAGE" >> $logpath
			if [ "$debug" = "1" ] ; then
				echo "$VERBAGE"
			fi
		else
			# If not logging, just do this:
			if [ "$debug" = "1" ] ; then
				curl $curlarg -v "$curlurl"
                                CURLEXIT=$?
			else
				curl $curlarg "$curlurl" >/dev/null 2>&1
                                CURLEXIT=$?
			fi
		fi
	done
if [ "$debug" = "1" ] ; then
	echo ; echo "Done." ; echo
fi
exit $CURLEXIT

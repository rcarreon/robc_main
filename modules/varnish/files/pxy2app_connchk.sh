#!/bin/bash
#
# /etc/cron.hourly/pxy2app_connchk.sh
# Dairenn Lombard <dairenn.lombard@gorillanation.com>
#
# 2011-07-28: Filter out localhost TCP:80
# 2011-07-27: Post IP addresses in the correct order.
# 2011-07-19: Initial Release

PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/bin
#set -e

# Config options:


# Enable logging
enablelog="1"

# Run in "debug" mode
debug="0"

# Set URL of VIP Visualizer
targeturl="http://vipvisual.gnmedia.net"

######################
#		     #
# END CONFIG OPTIONS #
#		     #
######################



logdir="/var/log"
logfile="pxy_to_app.log"
logpath="$logdir/$logfile"
# Only an educated guess.
myip=`ifconfig eth0 | grep "inet addr" | cut -d ":" -f 2 | awk '{print $1}'`

if [ "$debug" = "1" ] ; then
	port="8080"
	echo ; echo "My IP address is $myip"
	echo ; echo "My target URL is $targeturl:$port" ; echo
	else
	port="80"
fi

# 87.238.37.6 resolves to odd.varnish-software.com and varnish sometimes phones
# home for some reason.
for connection_ip in `netstat -an | egrep "(*WAIT|SYN*|ESTABLISHED)" | awk '{print $5}' | grep ":80$" | egrep -v "(127.0.0.1|87.238.37.6)" | cut -d ":" -f 1 | sort -n | uniq`
	do
		conns=`netstat -an | grep $connection_ip | egrep "(*WAIT|SYN*|ESTABLISHED)" | wc -l`
		curlarg="$targeturl:$port/insertNode?pxy_ip=$myip&app_ip=$connection_ip&conns=$conns&nodetype=pxy"
		curtime=`date "+%Y-%m-%d %H:%M:%S"`
		stamp="[$curtime]:"
		if [ "$enablelog" = "1" ] ; then
			# No out of control, abandoned log files; only keep what we need.
			if [ -f "$logpath" ] ; then
				find $logpath -name "$logfile" -ctime +1 -exec rm -f {} \;
			fi
			echo -n "$stamp Transmitted HTTP Request: $curlarg with output from curl: " >> $logpath
			VERBAGE=$( { curl "$curlarg"; } 2>&1 )
			echo $VERBAGE >> $logpath
			if [ "$debug" = "1" ] ; then
				tail -1 $logpath
			fi
			else
			# If not logging, just do this:
			if [ "$debug" = "1" ] ; then
				curl -v "$curlarg"
				else
				curl "$curlarg"
			fi
		fi
	done
if [ "$debug" = "1" ] ; then
	echo ; echo "Done." ; echo
fi
exit $?

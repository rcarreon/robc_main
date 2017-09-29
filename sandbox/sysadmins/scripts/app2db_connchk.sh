#!/bin/bash
#
# /etc/cron.hourly/app2db_connchk.sh
# Dairenn Lombard <dairenn.lombard@gorillanation.com>
#
# 2011-06-07: Record number of port 3306 connections per address
# 2011-05-12: Initial Release

PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/bin
set -e

# Config options:
targeturl="http://vipvisual.gnmedia.net"
debug="1"

if [ "debug" = 1 ] ; then
	port="8080"
	else
	port="80"
fi

myip=`ifconfig eth0 | grep "inet addr" | cut -d ":" -f 2 | awk '{print $1}'`
curl "$targeturl:$port/deleteNode?app_ip=$myip"
for connection_ip in `netstat -an | grep 3306 | awk '{print $5}' | cut -d ":" -f 1 | sort -n | uniq`
	do
# Uncomment these line once VIP Visualizer does not break when getting the enhanced curl call
#		conns='netstat -an | grep $connection_ip | egrep "(SYN_SENT|ESTABLISHED|TIME_WAIT)" | wc -l'
#		curl "$targeturl:$port/insertNode?app_ip=$myip&sql_ip=$connection_ip&conns=$conns"
		curl "$targeturl:$port/insertNode?app_ip=$myip&sql_ip=$connection_ip"
	done
exit $?

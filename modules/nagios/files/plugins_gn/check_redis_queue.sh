#!/bin/bash

Dtimeout=1
Dlistname=lax1
Dport=6379
Dthreshold=50000
Dcmd="llen $Dlistname"

timeout=$Dtimeout
listname=$Dlistname
port=$Dport
threshold=$Dthreshold
cmd=$Dcmd

usage() {
cat<<-__EOF__
	Usage: $0 -l listname -t timeout -th threshold -p port -c cmd hostname
	defaults:
	listname = $Dlistname
	timeout = $Dtimeout
	port = $Dport
	threshold = $Dthreshold
	cmd = $Dcmd
__EOF__
exit 1
}

failConnect() {
	echo "Error: failed to connect."
	exit 1
}
failEmptyResult() {
	echo "Error: empty result."
	exit 1
}

while [ $# -gt 0 ]; do
	case $1 in
		-l) listname=$2; shift; shift;;
		-t) timeout=$2; shift; shift;;
		-th) threshold=$2; shift; shift;;
		-p) port=$2; shift; shift;;
		-h|--help) usage;;
		-c) cmd=$2; shift; shift;;
		-*) "unknown option: $1" usage;;
		*) hostname=$1; shift;;
	esac
done

test -z "$hostname" && echo "missing hostname" && usage

output=$(echo -e -n "${cmd}\r\n" | nc -i $timeout $hostname $port | sed 's/^://' | xargs echo || failConnect)

if [[ $output == "" ]]; then
	failEmptyResult
fi

if [[ $output -gt $threshold ]]; then
		echo "redisQueue: CRITICAL - $output > $threshold"
		exit 1
	else
		echo "redisQueue: OK - $output < $threshold"
fi

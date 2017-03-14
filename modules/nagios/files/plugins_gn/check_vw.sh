#!/bin/bash
#
# Modified by Fletcher for use with VW
#
#
# A Nagios Plugin that checks if there is any program listening on specified
# TCP/UDP port.  
#
# Copyright (C) 2007 by Cedric Defortis <cedric@aiur.fr>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

version=0.1
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4


progname=$(basename $0)

DEFAULT_PORT=26542
DEFAULT_HOSTNAME=localhost
DEFAULT_TIMEOUT=5
# this is a simple vw query... format: label importance tag|
# we might need to add features or something later to make it a more complete test
DEFAULT_QUERY='0 0 test|'

print_help()
{

echo "Usage: ${progname} [-H <HOSTNAME>] [-p <PORT>] [-t <TIMEOUTS in seconds>] [--help]"
echo ""
echo "A Nagios plugin to check if a VW daemon is alive and responding."
echo ""
echo "Options:"
echo ""
echo "  -h, --help                print this help message"
echo "  -v, --verbose             set -x"
echo "  -H, --hostname=<hostname> Specify the hostname (default: ${DEFAULT_HOSTNAME})"
echo "  -p, --port=<port>         Port number (default: ${DEFAULT_PORT})"
echo "  -t, --timeout=<timeout>   Timeout in seconds (default: ${DEFAULT_TIMEOUT})"
echo "  -q, --query=<query>       The string we send to the VW Daemon"
echo ""
echo "Examples:"
echo ""
echo "To check that a vw daemon is running on ${DEFAULT_HOSTNAME}, port ${DEFAULT_PORT}, timeout ${DEFAULT_TIMEOUT}"
echo "  $ ./check_vw"
echo ""
echo "To check that a vw daemon is running on app1v-vw.ci.dev.lax.gnmedia.net, port 26545, timeout 2 seconds"
echo "  $ ./check_vw -H app1v-vw.ci.dev.lax.gnmedia.net -p 26545 -t 2"
echo ""
echo "Report bugs to <fletcher.davis@evolvemediallc.com>"

} #

SHORTOPTS="hvH:p:t:q"
LONGOPTS="help,verbose,hostname,port,timeout,query"

if $(getopt -T >/dev/null 2>&1) ; [ $? = 4 ] ; then # New longopts getopt.
    OPTS=$(getopt -o $SHORTOPTS --long $LONGOPTS -n "$progname" -- "$@")
else # Old classic getopt.
    # Special handling for --help and --version on old getopt.
    case $1 in --help) print_help ; exit 0 ;; esac
    OPTS=$(getopt $SHORTOPTS "$@")
fi

if [ $? -ne 0 ]; then
    print_help;
    exit 1
fi

eval set -- "$OPTS"

# Ensure that $port is an integer
declare -i port
port=${DEFAULT_PORT}
hostname=${DEFAULT_HOSTNAME}
timeout=${DEFAULT_TIMEOUT}
query=${DEFAULT_QUERY}
while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -v|--verbose)
            set -x
            shift 2
            ;;
        -H|--hostname)
            hostname=$2
            shift 2
            ;;
        -p|--port)
            port=$2
            shift 2
            ;;
        -t|--timeout)
            timeout=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal Error: option processing error: $1" 1>&2
            exit 1
            ;;
    esac
done

MAX_PORT_NUM=65535
if test ! $port -eq $port 2> /dev/null
then
    echo "Invalid port number";
    exit 1;
fi;
if test $port -ge $MAX_PORT_NUM -o $port -le 0
then
    echo "You MUST specify a valid listening port with option: '--port=PORT'"
    exit 1;
fi;

# TODO ... it would be nice if nc's timeout did not fail silently...
OUTPUT=$(echo $query | nc -w $timeout $hostname $port 2>&1 )
LINES=$(echo "$OUTPUT" | wc -l)

# we expect back one line of output
if [ "$LINES" != "1" ]
then
    echo "CRITICAL - Unkown output: $OUTPUT"
    exit $STATE_CRITICAL;
fi

# we expect back something of the form: [0-9]\.[0-9]{6} <tag name>
echo $OUTPUT | grep -oE '[0-9]\.([0-9]){6}' 2>&1 >/dev/null
if [[ $? -ne 0 ]]
then
    echo "CRITICAL - Bad return value in: $OUTPUT"
    exit $STATE_CRITICAL;
else
    echo "OK - VW looks good"
    exit $STATE_OK;
fi


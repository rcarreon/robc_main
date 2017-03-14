#!/bin/bash
#
# Modified by Fletcher for use with xml widgets
#

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

DEFAULT_RETRY=1
DEFAULT_OPTS="--noout"
#default url not set, must be specified

progname=$(basename $0)

print_help()
{

echo "Usage: ${progname} -u url [-r|--retry n (num retries before success)] [-o|--opts 'extra xmllint options'] [--help]"
echo ""
echo "A Nagios plugin to check xml at some url"
echo ""
echo "Options:"
echo ""
echo "  -h, --help                print this help message"
echo "  -v, --verbose             set -x"
echo "  -u, --url=<url>           Specify the url"
echo "  -r, --retry=<n>           Retry n, fail if any attempt fails (DEFAULT: ${DEFAULT_RETRY}"
echo "  -o, --opts=<extra xmllint options>   Extra args passed to xmllint command (DEFAULT: ${DEFAULT_OPTS}"
echo "  -d, --domain=<domain>"
echo ""
echo "Examples:"
echo ""
echo "To check that a crowdignite widget is returning valid xml"
echo "  $ ./${progname} -u widget.crowdignite.com/widgets/17?content=xml"
echo ""
echo "Report bugs to <fletcher.davis@evolvemediallc.com>"

} #

SHORTOPTS="hvu:r:od:"
LONGOPTS="help,verbose,url,retry,opts"

if $(getopt -T >/dev/null 2>&1) ; [ $? = 4 ] ; then # New longopts getopt.
    OPTS=$(getopt -o $SHORTOPTS --long $LONGOPTS -n "$progname" -- "$@")
else # Old classic getopt.
    # Special handling for --help on old getopt.
    case $1 in --help) print_help ; exit 0 ;; esac
    OPTS=$(getopt $SHORTOPTS "$@")
fi

if [ $? -ne 0 ]; then
    print_help;
    exit 1
fi

eval set -- "$OPTS"

# Ensure that $port is an integer
declare -i retry 
retry=${DEFAULT_RETRY}
opts=${DEFAULT_OPTS}
#default url not set, must be specified
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
        -u|--url)
            url=$2
            shift 2
            ;;
        -r|--retry)
            retry=$2
            shift 2
            ;;
        -t|--timeout)
            timeout=$2
            shift 2
            ;;
        -d|--domain)
            domain=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal Error: option processing error: $1" 1>&2
            exit ${STATE_WARNING}
            ;;
    esac
done

# print error message, but don't go critical if someone puts a bad check into nagios
if [ ! -n "${url}" ]; then
    echo "ERROR - url must be specified"
    echo "${url}"
    print_help;
    exit ${STATE_WARNING}
fi

if [ -z "$domain" ] ; then
    domain="$(echo $url | sed 's/^\(http:\/\/\)\?\([^\/]\+\).\+$/\2/')"
fi

# if any attempt fails, we fail the check
FAILED=false
for x in $(seq 1 $retry); do
    curl -s -H "Host: ${domain}" "${url}" | xmllint - "${opts}" &>/dev/null
    if [ "$?" -ne 0 ]; then
        FAILED=true
        break
    fi
done

if ${FAILED}; then
    echo "CRITICAL - Bad xml found"
    exit ${STATE_CRITICAL}
else
    echo "OK - looks like xml"
    exit ${STATE_OK}
fi

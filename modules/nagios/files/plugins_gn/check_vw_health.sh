#!/bin/bash
#
# by Fletcher for use with VW
#

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

# make sure the files we need exist
CANNOT_RUN=false
for x in vwtest.sh a2g.input a2g.test.expected.out a2z.test.data a2z.test.expected.out h2z.input
do
    if [ ! -e "/etc/nrpe.d/vwhealth/${x}" ]
    then
        CANNOT_RUN=true
    fi
done

if [ ! -e "/usr/local/bin/vw" ]
then
    CANNOT_RUN=true
fi

if "$CANNOT_RUN"
then
    echo "VW WARNING - Missing files to run this check"
    exit ${STATE_WARNING}
fi

# run the vwtest suite courtesy of jcrawford
cd $(mktemp -d)
cp /etc/nrpe.d/vwhealth/* .
chmod +x ./vwtest.sh
./vwtest.sh
exit $?

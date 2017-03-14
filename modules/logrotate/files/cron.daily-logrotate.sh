#!/bin/sh

/usr/bin/logger -t logrotate "Starting log rotation"
/usr/sbin/logrotate /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
/usr/bin/logger -t logrotate "log rotation exited normally"
exit 0


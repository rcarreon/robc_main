#!/bin/bash

# exit if not running as the deploy user
if [[ $(id -u) -ne 10028 ]]; then
    echo "This script must be run as the deploy user.  Exiting.";
    exit 1;
fi

cp -rf /app/shared/public_html_widget /dev/shm
#rm -f /dev/shm/public_html_widget/lib/global_defines.php
#cp /app/shared/public_html/app/global_defines.php /dev/shm/public_html_widget/lib

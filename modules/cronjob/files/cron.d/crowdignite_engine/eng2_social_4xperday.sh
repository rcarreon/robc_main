#!/bin/sh

# run this script twice per day, 6 hours after eng2_social_2xperday.sh, making a total of 
# 4 times a day that these scripts will be run.

/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /social_pages/update_pages/0/0
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /history_social/update
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /social_pages/engine

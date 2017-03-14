#!/bin/sh

# run twice per day, twelve hours apart

/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /social_pages/update_pages/0/0
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /social_pages/update_pages/0/1
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /history_social/update
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /social_pages/engine

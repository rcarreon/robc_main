#!/bin/sh

/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /pages/clean_lru
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /pages/retire_expired
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/2 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/3 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/4 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/1 | ts >> /app/log/cronjobs/widget_engine_rebalance_website_chunks_1.log 2>&1
#/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /contextual_engine/engine_active
cp /dev/null /var/mail/root

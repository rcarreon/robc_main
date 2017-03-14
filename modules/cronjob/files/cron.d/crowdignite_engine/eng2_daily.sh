#!/bin/sh

#/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /similar_engine
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/5 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/7 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/8 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /widget_engine/rebalance_website_chunks/6
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /landing_page_engine/rebalance_full/1 >> /app/log/cronjobs/lpe_rebal_full_1.log 2>&1 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /landing_page_engine/rebalance_full/2 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /landing_page_engine/rebalance_full/3 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /landing_page_engine/rebalance_full/4

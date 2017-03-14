#!/bin/sh

/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /landing_page_engine/rebalance
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /landing_page_engine/add_top_page

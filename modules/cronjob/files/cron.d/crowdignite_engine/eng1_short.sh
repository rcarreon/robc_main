#!/bin/bash

# reads from memcache queue
# /usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /page_engine/update_click_counts
# reads from kestrel queue
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /page_engine/new_update_click_counts

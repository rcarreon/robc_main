#!/bin/sh


/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /ranker/engine
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /ranker/pending_chunk/1 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /ranker/pending_chunk/2 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /ranker/pending_chunk/3 &
/usr/bin/php -q /app/shared/public_html/app/cron_dispatcher.php /ranker/pending_chunk/4

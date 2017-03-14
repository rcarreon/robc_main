#!/bin/bash
sqlhostname=$(cat /app/shared/vipvisual/sqlhostname)
sqlpassword=$(cat /app/shared/vipvisual/sqlpassword)
set -x
mysql -u vipvisual -h $sqlhostname -p$sqlpassword < duplicate.sql
mysqldump -u vipvisual -h $sqlhostname -p$sqlpassword servers_buff > server_buff.sql
#echo "UNLOCK TABLES;">>server_buff.sql
#mysql -u vipvisual -h $sqlhostname -p$sqlpassword servers < clean.sql
service httpd stop
mysql -u vipvisual -h $sqlhostname -p$sqlpassword servers < server_buff.sql
service httpd start

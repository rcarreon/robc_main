#!/bin/bash

sqlhostname=$(cat /app/shared/vipvisual/sqlhostname)
sqlpassword=$(cat /app/shared/vipvisual/sqlpassword)

mysql -u vipvisual -h $sqlhostname -p$sqlpassword servers_buff< clean.sql

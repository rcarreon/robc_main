#!/bin/bash
sqlhostname=$(cat /app/shared/vipvisual/sqlhostname)
sqlpassword=$(cat /app/shared/vipvisual/sqlpassword)

mysql -u vipvisual -h $sqlhostname -p$sqlpassword <<EOFMYSQL
create database servers;
create database servers_buff;
EOFMYSQL
svn co https://svn.gnmedia.net/sysadmins/trunk/network/configs/rancid/configs
svn co https://svn.gnmedia.net/sysadmins/trunk/dns/zones

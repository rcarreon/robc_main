#!/bin/sh

# Revoke db user rights for monthly_earnings app
mysql mysql --execute="revoke all privileges on labMonthly.* from lab@localhost;"

# Shut down apache and mysql
/etc/init.d/httpd stop
/etc/init.d/mysql stop
sleep 2

# Fill up inodes on /var/lock/httpd (256 max inodes)
for file in `seq 1 256`
do
  touch /var/lock/httpd/.backups/backup.$file > /dev/null 2>&1
done

# Tear the php end tag out of monthly_earnings.php
sed -i 's/\?>//' /mnt/docroots/example.com/monthly_earnings.php

# Chown the mysql files to be owned by apache user
chown -R apache:apache /mnt/mysql

# Tear out the AddHandler section for parsing php files in php.conf
sed -i 's/AddHandler php5-script .php//' /mnt/apache/conf.d/php.conf

# Munge the mounts
umount /mnt/docroots /mnt/apache
sleep 2
mount -r /mnt/apache

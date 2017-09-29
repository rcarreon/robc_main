#!/bin/sh

# Restores lab01 to fully working webapp
# Complete with rip van winkle effect...

/etc/init.d/httpd stop
sleep 2
/etc/init.d/mysql stop
sleep 2
/bin/cp /usr/.labscripts/httpd.conf.system /etc/httpd/conf/httpd.conf
umount /var/lock/httpd /mnt/apache /mnt/docroots /mnt/mysql
sleep 2
ssh nfs1.lax3.gnmedia.net snap restore -f -t vol -s nonbroken_cleancopy lax3_lab01_data1
sleep 5
mount -a
/etc/init.d/mysql start
sleep 2
/etc/init.d/httpd start

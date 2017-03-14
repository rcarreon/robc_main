#! /bin/bash 

if [ -f '/usr/local/bin/sbx_setup.done' ];
then 
    echo "Setup script has already been run"
else

#    cd /app/shared/docroots/
#    sudo cp /home/deploy/pbsandbox/app_shared_docroots.tgz .
#    sudo tar xvfpz app_shared_docroots.tgz
#    sudo chown -R <%= username %>:<%= username %> *
#    sudo rm app_shared_docroots.tgz

    sudo useradd -M -u 115 -s /sbin/nologin -c "Memcached daemon" -d /var/run/memcached memcached

    sudo rm -rf /sql/data/mysql/*
    sudo rm -rf /sql/binlog/*
    sudo rm -rf /sql/log/*
    sudo -u mysql mysql_install_db  --datadir=/sql/data/mysql
    sudo service mysql start

    mysql -h localhost -u root --password= < /usr/local/bin/sbx_grants.sql

    echo $(date +%m-%d-%Y) > '/usr/local/bin/sbx_setup.done';

fi

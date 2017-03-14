# install mysqld grants
class mysqld::grants {

    # Please encrypt the hash, not the raw password.
    # There is a small chance that if you encrypt the raw password, that password will be written
    # to disk in the slow log.

    $dba_password = decrypt('fMdn3lyHyLxIV4WAAyYqA1UAmgl6eDoJOqtLCVt/jkLP/tqACdMwSXMatFxhcIrm')
    $em_password = decrypt('zViCg2HmuIvhBsHhRcnFf9PeOmX8ZZwtqIBLeUCZcDUYq2qYFqieUGKTo1PIlrd/')
    $nagios_password = decrypt('VV5iPZOvpKyE9+rCgFJl8p8j+81CegCvGa04F8zW1UgnK5ymCX3sh1z6SIC0E4eN')
    $logrotate_password = decrypt('jMcF+B6je9STa68ugci4OIWcOx05q+n8tpW2EqvHBKwh2TDdzuZWjEya7nC+QXkU')
    $zmanda_password = decrypt('zoTizAST7ameASLbXju8QvJzb/+CYG8YzTmgkEE0szenEl4lkwUop5fKYICQMXIF')
    $sqlrootprd_password = decrypt('VqY9qm5A6LYVBeKzEs3mhABDQ3ZwPVCGibH7aTSoepauXmADT4ju/gzG5PyTcU9J')
    $sqlrootdev_password = decrypt('+U+Y5dygpvV/2aBY1xA63Z3h68qwYfebhAciXoJuBSF3iKIU79jAPIktP0bJSVU1')
    $collectd_password = decrypt('fEOVSmMXxT3yE/5Zi3y4FL377KLP1KXAMte8uiqXPFCTgVZmkVXQI8nQQuURFsjt')
    $zmandaxworld_password = decrypt('zoTizAST7ameASLbXju8QvJzb/+CYG8YzTmgkEE0szenEl4lkwUop5fKYICQMXIF')
    $dbtoolsprd_password = decrypt('C0x2DAdmwS22kqLgPD+Ih/2HnAZcrbHg9YHoSRUQjwBLuyyHJ/TzaX3oO775c7Zp')
    $dbtoolsdev_password = decrypt('Ei7S3rkJvLpzlhp/spxeZjT73LKa2+dPWlSLEj3n75N1WVqjt6Gx9xrtLggzfHMp')
    $dbops_password = decrypt('r4VkowQsN/0dRR9YSkAW4cmEhzEi/FFekCgsATrHFVRAeVhuAIn4HTzerx1UORB9')
    $sqlcopy_password = decrypt('hz1eKWRVckMMoeBHVvYnG3KknzZXMA8mfFeM5o9+JbLZ+xpmucSxOZjbObvwMOk9')
    $vaquitaprd_password = decrypt('c8mYLl6Nv3jw9nU6PltEfdAQ5IwTDlYo1cWY/tFaNE3XFiWmPErmApXDeMs6jfSc')
    $vaquitadev_password = decrypt('tTFJCtru93sIS5SFhcWGHlof/e6ivAEvNlCl6KL2TpZl52OxyJ2srmjBeIBv99JU')
    $definer_password = decrypt('zoTizAST7ameASLbXju8QvJzb/+CYG8YzTmgkEE0szenEl4lkwUop5fKYICQMXIF')

    file { '/var/lib/puppet/grants':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    # mysql_root password
    exec { 'mysql_root_password':
        command     => "mysql --defaults-file=/etc/my.cnf -u root -e \"UPDATE mysql.user SET Password = \\\"${sqlrootprd_password}\\\" WHERE User = \\\"root\\\"; FLUSH PRIVILEGES;\" && touch /var/lib/puppet/grants/mysqlGrant-root; mysql -u root -e \"UPDATE mysql.user SET Password = \\\"${sqlrootprd_password}\\\" WHERE User = \\\"root\\\"; FLUSH PRIVILEGES;\" && touch /var/lib/puppet/grants/mysqlGrant-root",
        creates     => '/var/lib/puppet/grants/mysqlGrant-root',
        user        => 'root',
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock',
        require     => File['/var/lib/puppet/grants'],
    }


    # mysql grant for dba
    exec { "mysql -e \"GRANT ALL PRIVILEGES ON *.* to 'dba'@'192.168.240.%' IDENTIFIED BY PASSWORD '${dba_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dba.240":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dba.240',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    exec { "mysql -e \"GRANT ALL PRIVILEGES ON *.* to 'dba'@'192.168.1.%' IDENTIFIED BY PASSWORD '${dba_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dba.1":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dba.1',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    exec { "mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'dba'@'192.168.12.%' IDENTIFIED BY PASSWORD '${dba_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dba.12":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dba.12',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    exec { "mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'dba'@'app1v-xcat.tp.prd.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${dba_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dba.xcat":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dba.xcat',
        user        => root,
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    exec { "mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'dba'@'app1v-percona.tp.prd.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${dba_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dba.percona":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dba.percona',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for em_agent
    exec { "mysql -e \"GRANT SELECT, REPLICATION CLIENT, SHOW DATABASES, SUPER, PROCESS ON *.* TO  'em_agent'@'localhost' IDENTIFIED BY PASSWORD '${em_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-em_agent-db":
        creates     => '/var/lib/puppet/grants/mysqlGrant-em_agent-db',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    exec { "mysql -e \"GRANT CREATE, INSERT ON mysql.* TO  'em_agent'@'localhost';\" && touch /var/lib/puppet/grants/mysqlGrant-em_agent":
        creates     => '/var/lib/puppet/grants/mysqlGrant-em_agent',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for collectd
    exec { "mysql -e \"GRANT SELECT ON *.* TO 'collectd'@'localhost' IDENTIFIED BY PASSWORD '${collectd_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-collectd":
        creates     => '/var/lib/puppet/grants/mysqlGrant-collectd',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for nagios
    exec { "mysql -e \"GRANT SELECT, REPLICATION CLIENT ON *.* TO 'monitor'@'app%v-nagios.tp.%.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${nagios_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-nagiostpprd":
        creates     => '/var/lib/puppet/grants/mysqlGrant-nagiostpprd',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for logrotate
    exec { "mysql -e \"GRANT RELOAD ON *.* to 'logrotate'@'localhost' IDENTIFIED BY PASSWORD '${logrotate_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-logrotate":
        creates     => '/var/lib/puppet/grants/mysqlGrant-logrotate',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for dashboards (prd)
    exec { "mysql -e \"GRANT SELECT, RELOAD, PROCESS, SHOW DATABASES, SUPER, REPLICATION CLIENT ON *.* TO 'dbtool_ops'@'app1v-dashboards.tp.prd.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${dbtoolsprd_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dbtoolsprd":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dbtoolsprd',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for dbops app processes (prd)
    exec { "mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'dbops'@'app1v-dbops.tp.prd.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${dbops_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dbopsprd":
        creates     => '/var/lib/puppet/grants/mysqlGrant-dbopsprd',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for sqlcopy
    exec { "mysql -e \"GRANT ALL ON *.* TO 'sqlcopy'@'localhost' IDENTIFIED BY PASSWORD '${sqlcopy_password}' WITH GRANT OPTION;\" && touch /var/lib/puppet/grants/mysqlGrant-sqlcopy":
        creates     => '/var/lib/puppet/grants/mysqlGrant-sqlcopy',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }

    exec { "mysql -e \"GRANT PROXY ON ''@'' TO 'sqlcopy'@'localhost' WITH GRANT OPTION;\" && touch /var/lib/puppet/grants/mysqlGrant-sqlcopy-proxy-grant":
        creates     => '/var/lib/puppet/grants/mysqlGrant-sqlcopy-proxy-grant',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
    # mysql grant for vaquita prd
    exec { "mysql -e \"GRANT SELECT, RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'vaquita_backup'@'app1v-vaquita.tp.prd.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${vaquitaprd_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-vaquitaprd":
        creates     => '/var/lib/puppet/grants/mysqlGrant-vaquitaprd',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }

    if($::fqdn_env == 'dev') {
        # mysql grant for dashboards (dev)
        exec { "mysql -e \"GRANT SELECT, RELOAD, PROCESS, SHOW DATABASES, SUPER, REPLICATION CLIENT ON *.* TO 'dbtool_ops'@'app1v-dashboards.tp.dev.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${dbtoolsdev_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-dbtoolsdev":
            creates     => '/var/lib/puppet/grants/mysqlGrant-dbtoolsdev',
            user        => 'root',
            require     => Exec['mysql_root_password'],
            environment => 'HOME=/root',
            onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
        }
        # mysql grant for vaquita dev
        exec { "mysql -e \"GRANT SELECT, RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'vaquita_backup'@'app1v-vaquita.tp.dev.lax.gnmedia.net' IDENTIFIED BY PASSWORD '${vaquitadev_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-vaquitadev":
            creates     => '/var/lib/puppet/grants/mysqlGrant-vaquitadev',
            user        => 'root',
            require     => Exec['mysql_root_password'],
            environment => 'HOME=/root',
            onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
        }
    }
    # mysql grant for routines definer
        exec { "mysql -e \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, DROP, ALTER, EXECUTE, SUPER, EVENT ON *.* TO 'definer_rw'@'localhost' IDENTIFIED BY PASSWORD '${definer_password}';\" && touch /var/lib/puppet/grants/mysqlGrant-routinedefiner":
        creates     => '/var/lib/puppet/grants/mysqlGrant-routinedefiner',
        user        => 'root',
        require     => Exec['mysql_root_password'],
        environment => 'HOME=/root',
        onlyif      => '/usr/bin/test -e /var/lib/mysql/mysql.sock'
    }
}

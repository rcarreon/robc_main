# myqld server base
class mysqld::server_base {
    include mysqld::dirs
    sysctl::conf {'vm.swappiness': value => '1' }

    nagios::service{'mysql':
        command   => 'check_mysql!read!me',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mysql',
    }
    nagios::service{'mysqlstartupconf':
        command   => 'check_nrpe!check_mysqlstartupconf',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mysqlstartupconf',
    }
    nagios::service{'mysqlerrorlog':
        command              => 'check_nrpe!check_mysqlerror',
        use                  => 'mysql-services',
        max_check_attempts   => '1',
        notification_options => 'w,u,c,s',
        notes_url            => 'http://docs.gnmedia.net/wiki/Nagios-mysqlerror',
    }
    nagios::service{'mysqlroutines':
        command   => 'check_nrpe!check_mysqlroutines',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mysqlroutines',
    }

    if ($::architecture == 'x86_64') {
        $nagpluglibdir = 'lib64'
    } else {
        $nagpluglibdir = 'lib'
    }
    cron{'check_mysqlstartupconf':
        user    => 'root',
        minute  => '0',
        hour    => '*',
        command => "/usr/${nagpluglibdir}/nagios/plugins/check_mysqlstartupconf"
    }
    cron{'check_mysqlroutines':
        user    => 'root',
        minute  => '0',
        hour    => '*',
        command => "/usr/${nagpluglibdir}/nagios/plugins/check_mysqlroutines"
    }

    file{'/usr/local/bin/mysqlconfcheck':
        ensure => absent,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    file{'mysqld_error_file':
        path    => '/sql/log/error.log',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0664',
        require => File['mysqld_log_dir'],
    }

}

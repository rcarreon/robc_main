# Class: mysql-extra
#
# Sample Usage:
# - include mysqld::zmanda
#
class mysqld::zmanda {
    include yum::mysql_common
    package {'perl-XML-Parser':
        ensure  => installed,
        require => Class['mysqld::server'],
    }

    package {'MySQL-zrm-enterprise-client':
        ensure  => absent,
        require => [Package['perl-XML-Parser'],Class['mysqld::server']],
    }

    file{'netapp-snapmirror-label-fix':
        ensure  => absent,
        path    => '/usr/share/mysql-zrm/plugins/netapp-snapshot.pl',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0750',
        content => template('mysqld/netapp-snapshot.pl'),
        require => Package['MySQL-zrm-enterprise-client']
    }

    file{'socket-server-logrot-fix':
        ensure  => file,
        path    => '/usr/share/mysql-zrm/plugins/socket-server.pl',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0750',
        content => template('mysqld/socket-server.pl'),
        require => Package['MySQL-zrm-enterprise-client']
    }

}

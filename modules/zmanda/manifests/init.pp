# Class: zmanda
#
# Sample Usage:
# - include zmanda

class zmanda {
    include yum::mysql_common
    # package {'perl-XML-Parser':
    #    ensure  => installed,
    #    #require => Class['mysqld::server'],
    # }

    package {'MySQL-zrm-enterprise-client':
        ensure  => absent,
    #    require => [Package['perl-XML-Parser'],Class['yum::mysql_common']],
    }

    file{'netapp-snapmirror-label-fix':
        ensure  => absent,
        path    => '/usr/share/mysql-zrm/plugins/netapp-snapshot.pl',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0750',
        source => 'puppet:///modules/zmanda/netapp-snapshot.pl',
        require => Package['MySQL-zrm-enterprise-client']
    }

    file{'/sql/zmanda':
        ensure => absent,
        path   => '/sql/zmanda',
        recurse => true,
        purge   => true,
        force   => true,
    }

    file{'/usr/share/mysql-zrm':
        ensure => absent,
        path   => '/usr/share/mysql-zrm',
        recurse => true,
        purge   => true,
        force   => true,
    }
}

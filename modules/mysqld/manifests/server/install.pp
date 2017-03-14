# mysqld server installer class
define mysqld::server::install ($startagent, $sqlclass, $mysqldatadir='/sql/data/mysql', $version='5527') {

    case $sqlclass {
        'supported': {$supported = true}
        'unsupported': {$supported = false}
        default: {if $::fqdn_role != 'uid' {$supported = true} else {$supported = false}}
    }

    include xinetd::vaquita_df

    if $supported == true {
        # Box is Supp

        # grants
        include mysqld::grants
        # backup
        include mysqld::zmanda
        # monitoring stuff
        class { 'mysqld::agent': startagent => $startagent }

        # This file is different based on supp vs unsupp
        file { 'mysqld_config':
            ensure  => file,
            path    => '/etc/my.cnf',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template("mysqld/${version}/my.cnf-${name}.erb"),
        }

        # This file is only placed if the box is supported
        file{'root-my-cnf':
            ensure  => file,
            path    => '/root/.my.cnf',
            owner   => 'root',
            group   => 'root',
            mode    => '0640',
            content => template('mysqld/my.cnf-root.erb'),
        }

        file {'root-my-logrot-cnf':
            ensure  => file,
            path    => '/root/.my.logrot.cnf',
            owner   => 'root',
            group   => 'root',
            mode    => '0600',
            content => template('mysqld/my.logrot.cnf-root.erb'),
        }
    }
    else {
        # Box is Unsupp
        file { 'mysqld_config':
            ensure   => present,
            path     => '/etc/my.cnf',
            owner    => 'root',
            group    => 'root',
            mode     => '0644',
            replace  => false,
            content  => template("mysqld/${version}/my.cnf-${version}-default-uid.erb"),
        }
        file {'root-my-cnf':
            ensure  => file,
            path    => '/root/.my.cnf',
            owner   => 'root',
            group   => 'root',
            mode    => '0640',
            replace => false,
            content => '',
        }
    }

    case $version {
        '5527': {
            if $::lsbmajdistrelease == '5' {
                fail('MySQL 5.5.27 is not supported on centos 5.x, please rinstall -o centos6 first.')
            }
            $package='MySQL-server-advanced'
            package { $package:
                ensure  => '5.5.27-1.el6',
                require => [Class['mysqld::dirs'], Class['yum::mysql5527'], Package['mysql-libs'], File['mysqld_config'], Mount['/sql/data'], Mount['/sql/binlog'], Mount['/sql/log']],
            }

            service { 'mysql':
                enable    => true,
                hasstatus => true,
                require   => Package[$package],
            }
            package { 'mysql-libs':
                ensure  => absent,
                require => Package['MySQL-shared-compat-advanced'],
            }
        }
        default: {
            notify { 'mysqld::server::install REQUIRES A VERSION': }
        }
    }

    package {'collectd-mysql':
        ensure    => installed,
        require   => [Class['collectd::client'], Package[$package], File['/etc/collectd.d/mysql.conf']],
    }
    file {'/etc/collectd.d/mysql.conf':
        source => 'puppet:///modules/collectd/mysql.conf',
        notify => Class['collectd::service'],
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0644',
    }
}

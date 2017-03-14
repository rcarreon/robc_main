# dirs for sql servers
class mysqld::dirs {
    include mysqld::user

    # create folders
    file{'mysqld_base_dir':
        path   => '/sql',
        owner  => 'mysql',
        group  => 'mysql',
        mode   => '0755',
    }
    file{'mysqld_log_dir':
        path    => '/sql/log',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
        require => File['mysqld_base_dir'],
    }
    file{'mysqld_data_dir':
        path    => '/sql/data',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
        require => File['mysqld_base_dir'],
    }
    file{'mysqld_binlog_dir':
        path    => '/sql/binlog',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
        require => File['mysqld_base_dir'],
    }
    file{'mysqld_socket_dir':
        ensure => 'directory',
        path   => '/var/lib/mysql',
        owner  => 'mysql',
        group  => 'mysql',
        mode   => '0755',
    }
}

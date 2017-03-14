# mysqld server ci replication certs
class mysqld::server::ci_replcerts {
    file {'/etc/mysql':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    file {'/etc/mysql/ca-cert.pem':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/mysqld/replcerts/ca-cert.pem',
        require => File['/etc/mysql']
    }
    file {'/etc/mysql/client-cert.pem':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/mysqld/replcerts/client-cert.pem',
        require => File['/etc/mysql']
    }
    file {'/etc/mysql/client-key.pem':
        ensure  => file,
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0660',
        source  => 'puppet:///modules/mysqld/replcerts/client-key.pem',
        require => File['/etc/mysql']
    }
}

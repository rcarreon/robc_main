class postgres93::server {

    class{ 'postgres93::server::pkg':
        require => [ File['/etc/sysconfig/pgsql/postgresql-9.3'], File['/sql/data/pgsql'] ],
    }

    service{ 'postgresql-9.3':
        enable    => true,
        hasstatus => true,
        require   => Class['postgres93::server::pkg'],
    }

    class{ 'postgres93::server::user': }

    file{ '/etc/sysconfig/pgsql':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Class['postgres93::server::user'],
    }

    file{ '/etc/sysconfig/pgsql/postgresql-9.3':
        ensure  => present,
        content => 'PGDATA=/sql/data/pgsql',
        require => File['/etc/sysconfig/pgsql'],
    }

    file{ '/var/lib/pgsql':
        ensure  => directory,
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0700',
    }

    file{ '/sql/data/pgsql':
        ensure  => directory,
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0700',
        require => Class['postgres93::server::user'],
    }

}

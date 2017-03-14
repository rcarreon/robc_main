class postgres93::server::user {
    user {'postgres':
        ensure   => present,
        comment  => 'PostgreSQL account',
        uid      => '26',
        gid      => 'postgres',
        home     => "/var/lib/pgsql",
        shell    => '/bin/bash',
    }
}

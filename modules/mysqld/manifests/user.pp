# mysql user
class mysqld::user {
    user {'mysql':
        ensure   => present,
        comment  => 'MySQL service account',
        uid      => '27',
        gid      => '27',
        # home     => "/var/lib/mysql",
        shell    => '/sbin/nologin',
        require  => Group['mysql'],
    }
    group {'mysql':
        ensure   => present,
        gid      => '27',
    }
}

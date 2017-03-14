# required to allow mysql to auth with pam
class auth::mysql {
    file { '/etc/pam.d/mysql':
        ensure   => present,
        source   => 'puppet:///modules/auth/mysql.pam',
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
    }
}


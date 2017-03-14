# create dirs needed by postfix
class postfix::dirs {

    file{'postfix_base_dir':
        ensure  => directory,
        path    => '/app/shared/postfix',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file{'amavisd_base_dir':
        ensure  => directory,
        path    => '/app/shared/amavisd',
        owner   => 'amavis',
        group   => 'amavis',
        mode    => '0755',
    }

    file{'amavisd_tmp_dir':
        ensure  => directory,
        path    => '/app/shared/amavisd/tmp',
        owner   => 'amavis',
        group   => 'amavis',
        mode    => '0755',
    }

    file{'amavisd_db_dir':
        ensure  => directory,
        path    => '/app/shared/amavisd/db',
        owner   => 'amavis',
        group   => 'amavis',
        mode    => '0755',
    }

    file{'amavisd_quarantine_dir':
        ensure  => directory,
        path    => '/app/shared/amavisd/quarantine',
        owner   => 'amavis',
        group   => 'amavis',
        mode    => '0755',
    }

    file { 'postfix-symlink':
        ensure  => link,
        path    => '/var/spool/postfix',
        target  => '/app/shared/postfix',
    }

}

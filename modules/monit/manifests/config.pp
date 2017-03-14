# monit setup conf
class monit::config {
    file {'/etc/monit.d':
        ensure  => directory,
        require => Package['monit'],
        recurse => true, # enable recursive directory management
        purge   => true, # purge all unmanaged junk
        force   => true, # also purge subdirs and links etc.
        owner   => 'root',
        group   => 'root',
        mode    => '0644', # this mode will also apply to files from the source directory
        # puppet will automatically set +x for directories
        source  => 'puppet:///modules/common/empty-directory/',
        ignore  => '.svn',
    }

    file {'/etc/monit.d/system.conf':
        ensure  => present,
        notify  => Service['monit'],
        content => template('monit/system.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    # Logging config
    file {'/etc/monit.d/logging.conf':
        ensure  => present,
        content => template('monit/logging.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    if ($::lsbmajdistrelease == 5) {
        # Monit 4.x config location
        # not  needed anymore
        file {'/etc/monit.conf':
            ensure  => absent,
            notify  => Service['monit'],
        }
        # Monit 5.x config location
        # it can't be a symlink - monit does not like it
        file {'/etc/monitrc':
            content => template('monit/monit.conf.erb'),
            mode    => '0700',
            notify  => Service['monit'],
            require => Package['monit'],
            owner   => 'root',
            group   => 'root',
        }
    } else {
        file {'/etc/monitrc':
            ensure  => absent,
            notify  => Service['monit'],
        }
        file {'/etc/monit.conf':
            content => template('monit/monit.conf.erb'),
            mode    => '0700',
            notify  => Service['monit'],
            require => Package['monit'],
            owner   => 'root',
            group   => 'root',
        }
    }

    file {'/etc/monit.d/mysql.conf':
        ensure  => absent,
        notify  => Service['monit'],
    }
    # nagios::service { "monit":
        # command   => "check_monit",
        # notes_url => "http://${fqdn}:2812",
    # }
}

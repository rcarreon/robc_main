# The logrotate class installs and schedules logrotate.
# It is included by its subclasses.
# logrotate is also included in the node 'basenode' in site.pp.

class logrotate {
    include cron

    package {'logrotate':
        ensure => installed,
    }

    file {'/etc/cron.daily/logrotate':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/logrotate/cron.daily-logrotate.sh',
        require => [Package['logrotate'],Class['cron']],
    }

    file {'/etc/logrotate.d/syslog':
	ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/logrotate/syslog',
    }
}

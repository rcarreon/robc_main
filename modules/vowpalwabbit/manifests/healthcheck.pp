class vowpalwabbit::healthcheck {
    require ::vowpalwabbit::package

    file { '/etc/nrpe.d':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0755,
    }

    file { '/etc/nrpe.d/vwhealth':
        ensure  => directory,
        source  => 'puppet:///modules/vowpalwabbit/vwhealth',
        purge   => true,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 0755,
    }

    nagios::service {'check_vw_health':
        command => 'check_nrpe!check_vw_health',
        normal_check_interval => '60',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_vw_health',
        action_url => "http://gweb.gnmedia.net/?h=${fqdn}$&r=hour&metric_group=NOGROUPS&z=small",
    }
}

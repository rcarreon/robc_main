class vowpalwabbit::widget {
    require ::vowpalwabbit::package
    include ::vowpalwabbit::piddir

    file { '/etc/init.d/vw_widget':
        source  => 'puppet:///modules/vowpalwabbit/vw_widget',
        mode    => 0755,
        owner   => root,
        group   => root,
    }

    service { 'vw_widget':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        subscribe   => [ File['/etc/init.d/vw_widget'], File['/var/run/vw'] ],
    }

    nagios::service {'check_vw_widget':
        command => 'check_vw!26542',
        normal_check_interval => '3',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_vw',
        action_url => "http://gweb.gnmedia.net/?h=${fqdn}$&r=hour&metric_group=NOGROUPS&z=small",
    }
}


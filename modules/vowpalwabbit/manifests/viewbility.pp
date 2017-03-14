class vowpalwabbit::viewbility {
    require ::vowpalwabbit::package
    include ::vowpalwabbit::piddir

    file { '/etc/init.d/vw_widget_viewbility':
        source  => 'puppet:///modules/vowpalwabbit/vw_widget_viewbility',
        mode    => 0755,
        owner   => root,
        group   => root,
    }

    service { 'vw_widget_viewbility':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        subscribe   => [ File['/etc/init.d/vw_widget_viewbility'], File['/var/run/vw'] ],
    }

    nagios::service {'check_vw_widget_viewbility':
        command => 'check_vw!26542',
        normal_check_interval => '3',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_vw',
        action_url => "http://gweb.gnmedia.net/?h=${fqdn}$&r=hour&metric_group=NOGROUPS&z=small",
    }
}

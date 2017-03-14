node 'app1v-oncommand.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include sendmail::relay
    include httpd
    include ganglia::modules::netapp_api_vertical
    httpd::virtual_host {"oncommand.gnmedia.net":expect => "start.html",monitor => "false",}

    nagios::service {"app1v-oncommand.tp.prd.lax.gnmedia.net_oncommand.gnmedia.net_8080":
        command => "check_url_p!oncommand.gnmedia.net!/!start.html!8080",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios_check_oncommand_gn_net",
    }

    file {"/usr/local/sbin/NTAP-restart":
        content => "#!/bin/sh\n/sbin/service NTAPdfm stop\n/sbin/service NTAPdfm start\n",
        owner   => root,
        group   => root,
        mode    => 0755,
    }

    cron { "NTAP-restart":
        ensure    => present,
        user      => 'root',
        command   => '/usr/local/sbin/NTAP-restart',
        weekday   => '1',
        hour      => '8',
        minute    => '0',
    }

}

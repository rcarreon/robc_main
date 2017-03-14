node 'app3v-sorry.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
#        $httpd="sorry-farm"
#        include httpd
        class {'nginx::install': config_template=>'sorry'}
	include sysctl


        $project="admin"
        include common::app

        # For sorry server content
        file {
                "/usr/share/nginx/html/sorry.html":
                source => "puppet:///modules/nginx/sorry.html",
                mode    => 0644,
                owner   => root,
                group   => root,
                require => Package["nginx"],
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app3v-sorry.tp.prd.lax.gnmedia.net",
	}

}

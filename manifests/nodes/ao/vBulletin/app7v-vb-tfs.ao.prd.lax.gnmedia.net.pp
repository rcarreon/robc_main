node 'app7v-vb-tfs.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include common::app
    include cronjob
    include php::tfs
    include subversion::client
    include sendmail::use_gateway

    package { [ "php-pecl-json" ]:
        ensure => installed,
    }

    $project="vb"
    $script_path="vb"

    cronjob::do_cron_dot_d_cron_file { 'tfs_vbseo_sitemap.cron': }
    httpd::virtual_host { 'forums.thefashionspot.com': }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/vb-tfs-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/tfs-ugc",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app7v-vb-tfs.ao.prd.lax.gnmedia.net",
    }

    file { "/etc/httpd/conf.d/forums.tfs.logins":
        source => "puppet:///modules/httpd/htpasswords/atomic-sites/forums.tfs.logins",
        owner   => "deploy",
        group   => "deploy",
    }

}

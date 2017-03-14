node 'app2v-vb-tfs.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vbc6"
    $project="vb"
    $script_path="vb"

    include common::app
    include cronjob
    include git::client
    include php::tfs
    include mysqld56::client
  
    httpd::virtual_host { 'forums.thefashionspot.com': monitor => false}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/vb-tfs-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app2v-vb-tfs.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/vb-tfs-ugc",
    }

  file { "/etc/httpd/conf.d/forums.tfs.logins":
    source => "puppet:///modules/httpd/htpasswords/atomic-sites/forums.tfs.logins",
    owner   => "deploy",
    group   => "deploy",
  }

  #cronjob::do_cron_dot_d_cron_file {"tfs_vbseo_sitemap.cron": }

}

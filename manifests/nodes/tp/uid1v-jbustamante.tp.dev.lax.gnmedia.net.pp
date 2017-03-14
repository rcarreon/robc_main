node 'uid1v-jbustamante.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include memcached
    include common::app
    include httpd
    
    package {"php-ldap.x86_64":
      ensure => present,
    }  

    httpd::virtual_host {"docs.gnmedia.net": uri => '/wiki/Main_Page', expect => "Jabber",}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_shared/jbustamante-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/uid1v-jbustamante.tp.dev.lax.gnmedia.net",
    }
}

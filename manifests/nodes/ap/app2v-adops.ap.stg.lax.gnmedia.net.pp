node 'app2v-adops.ap.stg.lax.gnmedia.net' {
    include base
    $project='adops'
    include adops::packages
    include adops::packages::v3
    include adops::rbenv
    include adops::passenger4
    include adops::devmail
    include adopsV3::appdirs

    include adops::newrelic::apm

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    include pipestash

    package {'git':
      ensure => installed
    }

    file {'/etc/httpd/conf.d/passenger-adops.conf':
      ensure => absent
    }

    file {'/etc/httpd/conf.d/passenger.conf':
      ensure => absent
    }

    class { 'php::adops_memcache':
        memcache_servers => ['mem1v-adops.ap.stg.lax.gnmedia.net','mem2v-adops.ap.stg.lax.gnmedia.net']
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app2v-adops.ap.stg.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg",
    }

    # Vhosts
    httpd::virtual_host {'stg.adops.gorillanation.com': uri => '/sessions/login', expect => 'forgot your password'}
}

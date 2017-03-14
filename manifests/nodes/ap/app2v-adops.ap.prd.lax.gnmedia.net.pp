node 'app2v-adops.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="adops"
    include adops::packages
    include adops::packages::v3
    include adops::rbenv
    include adops::passenger4
    include adopsV3::appdirs
    include adops::newrelic::apm
    include adops::newrelic::sysmond
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

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app2v-adops.ap.prd.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd",
    }

    class { "php::adops_memcache":
        memcache_servers => ["mem1v-adops.ap.prd.lax.gnmedia.net","mem2v-adops.ap.prd.lax.gnmedia.net"]
    }

    # Vhosts
    httpd::virtual_host {"adops.gorillanation.com": uri => '/sessions/login', expect => 'forgot your password'}
    # newprod and cta pubops disabled on 5/12/2014
    #   httpd::virtual_host {"newprod.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
    #   httpd::virtual_host {"cta.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'norobots'}
    # pubops-legacy disabled around 2/2014
    #   httpd::virtual_host {"pubops-legacy.gorillanation.com": uri => '/sessions/login', expect => 'forgot your password'}

    # redirect vhost
    #   httpd::virtual_host {"pubops.gorillanation.com": monitor => false}
}

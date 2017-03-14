node 'app1v-build.og.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include common::app

    # PHP stuff
    include yum::ius
    include php::ius
    include php::ius::mcrypt

    # python used in jenkins builds for html reports, ansible used in deploys
    package { ['python-jinja2', 'python-lxml', 'python-argparse', 'php54-pecl-xdebug', 'ansible']: ensure => installed }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/build-shared",
    }

    common::nfsmount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/software",
    }
    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_log/app1v-build.og.dev.lax.gnmedia.net",
    }
}

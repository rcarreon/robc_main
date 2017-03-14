class triggertag::dev {
    include common::app
    include httpd
    include php

    # Mounts
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/tt-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/tt-ugc",
    }

    package { 'perl-DBD-MySQL':
        ensure => present,
    }

    # Vhosts
    httpd::virtual_host{'triggertag.dev.gorillanation.com': uri => '/js/triggertag.js', expect => 'getTrigger',}

}

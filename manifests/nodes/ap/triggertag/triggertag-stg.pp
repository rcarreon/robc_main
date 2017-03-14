# required by triggertag stg systems
class triggertag::stg {
    # moved to node scope because this doesn't work with dynamic scoping
    # $project='adops'
#    $svn_tt_repo='https://svn.gnmedia.net/triggertag/branches/production/'
#    $svn_siteanalytics_repo='https://svn.gnmedia.net/siteanalytics/branches/production/'
    include common::app
    include httpd
    include php

    # Mounts
    common::nfsmount { '/app/shared':
            device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/tt-shared',
    }

    common::nfsmount { '/app/ugc':
            device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/tt-ugc',
    }

    package { 'perl-DBD-MySQL':
        ensure => present,
    }

    # Vhosts
    httpd::virtual_host{'triggertag.stg.gorillanation.com': uri => '/js/triggertag.js', expect => 'getTrigger',}
# Disabled vhost on 5/12/14
#    httpd::virtual_host{'siteanalytics.stg.evolvemediametrics.com': uri => '/js/siteanalytics.js', expect => 'load_siteanalytics',}

}

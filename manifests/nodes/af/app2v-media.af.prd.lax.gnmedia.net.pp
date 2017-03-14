node 'app2v-media.af.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="affluent"
    include common::app
    include httpd
    include yum::mysql5627

    package { 'subversion': ensure => installed, }
    package { 'git': ensure => installed, }
    class { 'php::install':
        version => '5.3',
        extra_packages => ['php-ldap'],
    }

    httpd::virtual_host { 'origin.uk.video.martinimediainc.com':}  
    httpd::virtual_host { 'origin.video.martinimediainc.com': }
    httpd::virtual_host { 'secure.video.martinimediainc.com': }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_af_lax_prd_app_shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_af_lax_prd_app_log/app2v-media.af.prd.lax.gnmedia.net",
    }
}

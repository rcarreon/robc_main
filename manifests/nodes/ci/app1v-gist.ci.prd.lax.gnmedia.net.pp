node 'app1v-gist.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    include common::app
    include httpd::ssl
    $phpenv="gist"

    file {
       	# gorillanation.com wildcard cert
        "/etc/httpd/conf.d/gist.crowdignite.com.crt":
            owner  => "apache",
            group  => "apache",
            mode   => "0644",
            source => "puppet:///modules/httpd/certificates/gist.crowdignite.com.crt";
        "/etc/httpd/conf.d/gist.crowdignite.com.key":
            owner  => "apache",
            group  => "apache",
            mode   => "0644",
            source => "puppet:///modules/httpd/certificates/gist.crowdignite.com.key";
    }

    include php::browscap
    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::ius::imagick

    httpd::virtual_host {'gist.crowdignite.com': monitor => false,}

    common::nfsmount { '/app/shared':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/ci_gist",
    }
    common::nfsmount { '/app/log':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app1v-gist.ci.prd.lax.gnmedia.net",
    }
}

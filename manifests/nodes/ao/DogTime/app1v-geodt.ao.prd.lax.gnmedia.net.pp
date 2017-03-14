node 'app1v-geodt.ao.prd.lax.gnmedia.net' {
    $project="atomiconline"
    include base
    include httpd
    include rubygems
    include yum::postgres::beta

    package {['gcc','ruby-devel','GeoIP']:
    ensure => present,
    }
        httpd::virtual_host {"adopt.dogtime.com":}


}
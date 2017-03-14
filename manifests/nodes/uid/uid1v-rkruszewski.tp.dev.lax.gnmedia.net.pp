node 'uid1v-rkruszewski.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include httpd
    #include php::dh
    #include subversion::client


    file { "/app/shared/docroots":
            ensure => directory,
            owner   => deploy,
            group   => deploy,
            mode    => 755,
           #require => Mount["/app/shared"]
    }


}

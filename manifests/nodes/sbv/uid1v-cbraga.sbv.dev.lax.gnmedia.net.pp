node 'uid1v-cbraga.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='springboard'
    include common::app
    include php
    #include admin::nisdomain
    #include admin::ipv6_disable
    #include common::kernel
    #include glances
    # $logging=""

    file { 'docroots':
       ensure => 'directory',
       path  => '/app/shared/docroots',
    }
    file { 'admin_root':
       ensure => 'directory',
       path  => '/app/shared/docroots/admin',
    }
    file { 'teemip_docroots':
        ensure  => 'directory',
        path    => '/app/shared/docroots/admin/rackmonkey/',
        mode    => '0775',
        owner   => 'root',
        group   => 'root',
    }

}

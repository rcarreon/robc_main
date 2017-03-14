node 'app4v-puppet.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='admin'

#    include puppet_master_27

    file { ['/app/shared/manifests','/app/shared/modules','/app/shared/templates']:
        ensure  => directory,
        require => Mount['/app/shared'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_dev_app_log/app4v-puppet.tp.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/puppet/app4v-puppet.tp.dev.lax.gnmedia.net",
    }

}

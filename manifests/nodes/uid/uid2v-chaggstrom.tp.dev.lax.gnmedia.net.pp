node 'uid2v-chaggstrom.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    include common::app
    include puppet_agent::uid
    include subversion::client

    package { ['vim-enhanced','git','rpmdevtools','yum-utils','bash-completion']:
        ensure => installed,
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_shared/chaggstrom-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_log/uid2v-chaggstrom.tp.dev.lax.gnmedia.net',
    }

}

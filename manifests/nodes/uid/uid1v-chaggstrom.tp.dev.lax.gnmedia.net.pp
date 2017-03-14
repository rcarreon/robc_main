node 'uid1v-chaggstrom.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='admin'
    include common::app
    include puppet_agent::uid
    include subversion::client

    package { ['git','rpmdevtools','yum-utils','bash-completion','rubygems','rubygem-puppet-lint','php']:
        ensure => installed,
    }

    #notify{"role=$fqdn_role, incr=$fqdn_incr, type=$fqdn_type, vertical=$fqdn_vertical, env=$fqdn_env, loc=$fqdn_loc, domain=$fqdn_domain, tpdev=$fqdn_tpdev":}

    #if ($fqdn_env == 'dev') {
    #    notify{"fqdn_env does match dev":}
    #}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_shared/chaggstrom-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_log/uid1v-chaggstrom.tp.dev.lax.gnmedia.net',
    }
}

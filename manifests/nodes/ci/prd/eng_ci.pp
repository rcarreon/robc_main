class crowdignite::eng_ci_prd {

    ### Common pkgs
    include common::app
    include sysctl
    include php::browscap
    include logrotate::crowdignite_cronjobs
    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::ius::imagick
    include php::ius::redis

    vowpalwabbit::failurelogcheck { '/app/log/vw_landing-page-error_log' : }
    vowpalwabbit::failurelogcheck { '/app/log/vw_widget-error_log': }

    # we want the updates-live mysql-libs
    package { ['mysqlclient16', 'mysql55-libs']:
        ensure => absent,
    }

    package { 'moreutils':
      ensure => installed,
    }

    ### Common app conf
    file {'/app/log/cake_memcached.log':
        owner   => apache,
        group   => apache,
        mode    => '0644',
        ensure  => file,
        require => File['/app/log'],
    }

    file {'/app/log/cakephp':
        ensure  => directory,
        owner   => apache,
        group   => apache,
        require => File['/app/log'],
    }

    file {'/app/log/cron_log':
        owner   => root,
        group   => root,
        mode    => '0644',
        ensure  => file,
    }

    file { ['/app/log/cronjobs', '/app/log/cronjobs/jobspec/']:
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => '0755',
    }

    ### UGC
    common::nfsmount { '/app/ugc':
        device => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_ugc_tmp/upload'
    }
}

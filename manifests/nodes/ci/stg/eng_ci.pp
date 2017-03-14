class crowdignite::eng_ci_stg {

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
    $env='stg'

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
    # this is a shared vol btw dev and stg, don't panic, it is the correct vol :)
    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc/upload',
    }
}

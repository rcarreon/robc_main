node 'uid1v-orivera.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include httpd
    include yum::mariadb::wildwest
    common::add_profiled { 'vaquita_pythonpath.sh': }
    class {"mysqld56": template=>"orivera.tp.dev.lax-standalone"}
    #monit::use_template { 'vaquita_backup': }

    httpd::virtual_host { 'orivera.gnmedia.net': monitor => false, }
    httpd::virtual_host { 'viptrace.gnmedia.net': monitor => false, }
    httpd::virtual_host { 'dev.vaquita.gnmedia.net': monitor => false, }

    package { [ 'mysql-connector-python', 'MySQL-python', 'python-argparse', 'python-apscheduler', 'python-pip', 'python-sqlalchemy', 'rnetapp', 'mod_wsgi', 'subversion', 'git' ]:
        ensure => installed,
    }

    class { 'php::install':
        version => '5.3',
        extra_packages => ['php-ldap'],
    }

    # vaquita-backup paths
    $vaquita_local_path  = '/app/shared/docroots/vaquita.gnmedia.net'
    $vaquita_config_path = '/etc/vaquita-backup/config.ini'

    # vaquita-backup passwords
    $dev_scheduler_pass  = decrypt('enl4bE6Tr1mfczcy064+fw==')
    $dev_dbsource_pass   = decrypt('7c8uFm+agY//0SF4XLVHTQ==')
    $dev_dbtool_pass     = decrypt('p2PVKZZEju2pksJ27SG8tg==')
    $dev_webservice_pass = decrypt('jnvydXwHYm2B9WkoDeVd3g==')
    $dev_netapp_pass     = decrypt('psWZ/qTcYxNWHMVw7o9frw==')

    # vaquita-backup 
    file { '/app/log/vaquita-backup':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    # vaquita-backup config files
    file { '/etc/sysconfig/vaquita-backup':
        ensure  => file,
        owner   => 'root',
        group   => 'mysql',
        mode    => '0640',
        content => template('techplatform/vaquita-backup/vaquita-sysconfig'),
    }

    file { '/etc/vaquita-backup':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    #file { '/etc/vaquita-backup/config.ini':
    #    ensure  => file,
    #    owner   => 'root',
    #    group   => 'root',
    #    mode    => '0644',
    #    content => template('techplatform/vaquita-backup/dev-config.ini'),
    #}

    #file { '/etc/vaquita-backup/backups.json':
    #    ensure  => file,
    #    owner   => 'root',
    #    group   => 'root',
    #    mode    => '0644',
    #    content => template('techplatform/vaquita-backup/dev-backups.json'),
    #}

    file { '/app/log/vaquita-backup/dbbackup_webservice.err':
        ensure  => file,
        owner   => 'apache',
        group   => 'root',
        mode    => '0644',
    }

    file { '/app/log/vaquita-backup/dbbackup_webservice.log':
        ensure  => file,
        owner   => 'apache',
        group   => 'root',
        mode    => '0644',
    }

    #orivera
    cron { 'rancid_update':
        ensure      => present,
        user        => orivera,
        environment => 'MAILTO=omar.rivera@evolvemediallc.com',
        minute      => '*/5',
        command     => 'cd /usr/local/etc/viptrace && /usr/bin/svn up >/dev/null 2>&1'
    }
    
    #orivera
    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_orivera_tp_dev_lax_data",
    }
    
    #orivera
    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_orivera_tp_dev_lax_binlog",
    }
    
    #orivera
    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_log/uid1v-orivera.tp.dev.lax.gnmedia.net",
    }
}

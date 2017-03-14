node 'app1v-vaquita.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include httpd
    include yum::mysql5527

    common::add_profiled { 'vaquita_pythonpath.sh': }
    monit::use_template { 'vaquita_backup': }

    httpd::virtual_host {'dev.vaquita.gnmedia.net': monitor => false}

    nagios::service {"dev.vaquita.gnmedia.net_toolshed_json":
        command => "check_json.pl!http://dev.vaquita.gnmedia.net/toolshed",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_json",
    }
    nagios::service {"dev.vaquita.gnmedia.net_toolshed_backup_set_json":
        command => "check_json.pl!http://dev.vaquita.gnmedia.net/toolshed_backup_set",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_json",
    }



    package { [ 'mysql-connector-python', 'MySQL-python', 'python-argparse', 'python-apscheduler', 'python-devel', 'python-pip', 'python-sqlalchemy', 'rnetapp', 'mod_wsgi', 'subversion', 'git', 'rpm-build', 'mysql' ]:
        ensure => installed,
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/vaquita-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-vaquita.tp.dev.lax.gnmedia.net",
    }

    # vaquita-backup paths
    $vaquita_local_path  = '/app/shared/docroots/vaquita.gnmedia.net'
    $vaquita_config_path = '/etc/vaquita-backup/config.ini'

    # vaquita-backup passwords
    $dev_scheduler_pass  = decrypt('enl4bE6Tr1mfczcy064+fw==')
    $dev_dbsource_pass   = decrypt('7c8uFm+agY//0SF4XLVHTQ==')
    $dev_dbtool_pass     = decrypt('p2PVKZZEju2pksJ27SG8tg==')
    $dev_webservice_pass = decrypt('jnvydXwHYm2B9WkoDeVd3g==')
    $dev_netapp_pass     = decrypt('B0giKsLYcz/ec0NfbUDNEA==')

    # vaquita-backup netapp host
    $dev_netapp_host     = '10.64.44.8'

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

    file { '/etc/vaquita-backup/config.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('techplatform/vaquita-backup/dev-config.ini'),
    }

    file { '/etc/vaquita-backup/backups.json':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('techplatform/vaquita-backup/dev-backups.json'),
    }

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
}

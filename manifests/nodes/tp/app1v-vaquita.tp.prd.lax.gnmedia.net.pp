node 'app1v-vaquita.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include httpd
    common::add_profiled { 'vaquita_pythonpath.sh': }
    monit::use_template { 'vaquita_backup': }

    httpd::virtual_host {'vaquita.gnmedia.net': monitor => false}

    # We can uncomment when ready.  no need for alerts yet.
    #nagios::service {"vaquita.gnmedia.net_toolshed_json":
    #    command => "check_json.pl!http://vaquita.gnmedia.net/toolshed",
    #    notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_json",
    #}
    #nagios::service {"vaquita.gnmedia.net_toolshed_backup_set_json":
    #    command => "check_json.pl!http://vaquita.gnmedia.net/toolshed_backup_set",
    #    notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_json",
    #}

    package { [ 'mysql-connector-python', 'MySQL-python', 'python-argparse', 'python-apscheduler', 'python-pip', 'python-sqlalchemy', 'rnetapp', 'mod_wsgi', 'subversion', 'git', 'mysql' ]:
        ensure => installed,
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/vaquita-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-vaquita.tp.prd.lax.gnmedia.net",
    }

    # vaquita-backup paths
    $vaquita_local_path  = '/usr/lib/python2.6/site-packages/'
    $vaquita_config_path = '/etc/vaquita-backup/config.ini'

    # vaquita-backup passwords
    $prd_scheduler_pass  = decrypt('yqvslEyVkGnlUVGLPG4LVA==')
    $prd_dbsource_pass   = decrypt('hRFVjxVVILbjXCOuq6JHqQ==')
    $prd_dbtool_pass     = decrypt('8Rmr2XBuLR/7Rl2wLfJbRQ==')
    $prd_webservice_pass = decrypt('j6GRLN7JcxccPxpYeTevNg==')
    $prd_netapp_pass     = decrypt('B0giKsLYcz/ec0NfbUDNEA==')

    # vaquita-backup netapp host
    $prd_netapp_host     = '10.64.44.8'

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
        owner  => 'mysql',
        group  => 'mysql',
        mode   => '0755',
    }

    file { '/etc/vaquita-backup/config.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'mysql',
        mode    => '0644',
        content => template('techplatform/vaquita-backup/prd-config.ini'),
    }

    file { '/etc/vaquita-backup/backups.json':
        ensure  => file,
        owner   => 'root',
        group   => 'mysql',
        mode    => '0644',
        content => template('techplatform/vaquita-backup/prd-backups.json'),
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

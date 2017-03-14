node 'app1v-dashboards.tp.dev.lax.gnmedia.net' {
    include base
    $project='admin'
    include common::app
    include rubygems
    include httpd
    include subversion::client
    include git::client
    sudo::install_template { 'dba-root': }

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    class { 'php::install': version => '5.3' }

    httpd::virtual_host{ 'toolshed.gnmedia.net': uri => '/toolshed/', monitor => false,}

    package { 'mysql-connector-python':
        ensure => installed,
    }
    package { 'perl-suidperl':
        ensure => installed,
    }
    package { 'rrdtool':
        ensure => installed,
    }
    package {'rubygem-sinatra':
        ensure => present,
    }
    package { 'rubygem-json':
        ensure => present,
    }
    package { 'php-ldap':
        ensure => installed,
    }

	cron { "toolshed_refresh_db":
		ensure  => present,
		command => "date>>/app/log/toolshed_refresh_db.log;curl http://dev.toolshed.gnmedia.net/toolshed/sqlps_populate_servers_vm>>/app/log/toolshed_refresh_db.log 2>&1",
		user    => 'root',
		hour    => '*',
		minute  => '15',
	}

    cron { 'toolshed_db_parser':
        ensure  => absent,
        command => "date>>/app/log/toolshed_db_parser.log;curl http://toolshed.gnmedia.net/toolshed/sqlps_populate_server_list>>/app/log/toolshed_db_parser.log 2>&1",
        user    => 'root',
        hour    => '*',
        minute  => '15',
    }

    cron { 'sqlps_populate_server_list':
        ensure  => absent,
        user    => 'root',
        hour    => '*',
        minute  => '15',
        command => '/usr/bin/curl http://toolshed.gnmedia.net/toolshed/sqlps_populate_server_list 2>&1',
    }

    cron { 'sqldash_em_alerts':
        ensure  => absent,
        user    => 'root',
        hour    => '*',
        minute  => '*/1',
        command => '/usr/bin/curl http://toolshed.gnmedia.net/toolshed/sqldash_em_alerts 2>&1',
    }

    cron { 'vaquita_webservice_backup':
        ensure  => present,
        user    => 'root',
        hour    => '*/6',
        minute  => '1',
        command => '/usr/bin/curl http://dev.toolshed.gnmedia.net/toolshed/sqlvaquita_webservice 2>&1',
    }

    # password checker utility
    file {'/usr/local/bin/shadowcheck':
        owner   => root,
        group   => apache,
        mode    => '4550',
        source  => 'puppet:///modules/common/shadowcheck',
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/dashboards-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-dashboards.tp.dev.lax.gnmedia.net",
    }

    common::nfsromount { "/app/data/ganglia/tpprd":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_tp_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    }
    common::nfsromount { "/app/data/ganglia/tpdev":
        device  => "nfsA-netapp1.tp.dev.lax.gnmedia.net:/vol/nac1a_tp_lax_dev_app_gweb/gweb-data/ganglia/rrds",
    }
    common::nfsromount { "/app/data/ganglia/sbv":
        device  => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    }
    common::nfsromount { "/app/data/ganglia/ao":
        device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    }
    common::nfsromount { "/app/data/ganglia/ap":
        device  => "nfsA-netapp1.ap.prd.lax.gnmedia.net:/vol/nac1a_ap_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    }
    common::nfsromount { "/app/data/ganglia/ci":
        device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    }
    common::nfsromount { "/app/data/ganglia/si":
        device  => "nfsA-netapp1.si.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    }

}

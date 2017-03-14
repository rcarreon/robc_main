node 'app1v-dashboards.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
        class { 'php::install': version => '5.3' }
        include rubygems
        include httpd
	include subversion::client
	include git::client
        sudo::install_template { 'dba-root': }
        httpd::virtual_host{ "pb.health.gnmedia.net":
		expect => "up",
	}
        httpd::virtual_host{ "toolshed.gnmedia.net":
                uri => "/toolshed/",
		expect => "Extravaganza",
	}
        httpd::virtual_host{ "beer30.gnmedia.net":
                expect => "beer30countdown",
        }

	httpd::virtual_host{ "uptime.gnmedia.net":
		expect => "Overall Uptime",
	}
        package { "php-ldap":
                ensure => installed,
        }
        package { "perl-suidperl":
              ensure => installed,
        }
        package { "rrdtool":
              ensure => installed,
        }

        package {"rubygem-sinatra":
          ensure => present,
        }

        package { "rubygem-json":
                ensure => present,
        }

	# Uptime requires simplejson. Centos6 does not require simplejson
	package { "python-simplejson":
		ensure => present,
	}

	cron { "toolshed_refresh_db":
		ensure  => present,
		command => "date>>/app/log/toolshed_refresh_db.log;curl http://toolshed.gnmedia.net/toolshed/sqlps_populate_servers_vm>>/app/log/toolshed_refresh_db.log 2>&1",
		user    => 'root',
		hour    => '*',
		minute  => '15',
	}
	
	cron { "toolshed_db_parser":
		ensure  => present,
		command => "date>>/app/log/toolshed_db_parser.log;curl http://toolshed.gnmedia.net/toolshed/sqlps_populate_server_list>>/app/log/toolshed_db_parser.log 2>&1",
		user    => 'root',
		hour    => '*',
		minute  => '15',
	}

#	cron { "sqldash_em_alerts":
#		   user    => "root",
#		   ensure  => "absent",
#		   hour    => "*",
#		   minute  => "*/1",
#		   command => "/usr/bin/curl http://toolshed.gnmedia.net/toolshed/sqldash_em_alerts 2>&1",
#	}

        cron { 'vaquita_webservice_backup':
        	   ensure  => present,
        	   user    => 'root',
        	   hour    => '*/6',
                   minute  => "1",
        	   command => '/usr/bin/curl http://toolshed.gnmedia.net/toolshed/sqlvaquita_webservice 2>&1',
    	}

        common::nfsmount { "/app/images_snapshots":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/ci-website_snapshots",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/dashboards-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-dashboards.tp.prd.lax.gnmedia.net",
        }

        # Martin's password checker utility
        file {"/usr/local/bin/shadowcheck":
                owner   => root,
                group   => apache,
                mode    => 4550,
                source  => "puppet:///modules/common/shadowcheck",
        }

	cron { "uptime":
		user    => "deploy",
		command => "cd /home/deploy/AT-RT; ./pingdom-uptime.py -o /app/shared/docroots/uptime/uptime.json -d /app/shared/docroots/uptime/date",
		hour    => "0",
		minute  => "1",
	}
        nagios::service {"uptimeStatus":
            command => "check_uptime_gn_net",
            notes_url => "http://docs.gnmedia.net/wiki/check_uptime_gn_net",
        }

	cron { "copy_shared_pma":
             ensure  => present,
             command => "/app/shared/docroots/toolshed.gnmedia.net/pma/scripts/copy_shared_pma 2>&1",
             user    => 'root',
             minute  => [15, 45]
        }


    #common::nfsromount { "/app/data/ganglia/tpprd":
        #device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_tp_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    #}
    #common::nfsromount { "/app/data/ganglia/tpdev":
        #device  => "nfsA-netapp1.tp.dev.lax.gnmedia.net:/vol/nac1a_tp_lax_dev_app_gweb/gweb-data/ganglia/rrds",
    #}
    #common::nfsromount { "/app/data/ganglia/sbv":
        #device  => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    #}
    #common::nfsromount { "/app/data/ganglia/ao":
        #device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    #}
    #common::nfsromount { "/app/data/ganglia/ap":
        #device  => "nfsA-netapp1.ap.prd.lax.gnmedia.net:/vol/nac1a_ap_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    #}
    #common::nfsromount { "/app/data/ganglia/ci":
        #device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    #}
    #common::nfsromount { "/app/data/ganglia/si":
        #device  => "nfsA-netapp1.si.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_gweb/gweb-data/ganglia/rrds",
    #}

}

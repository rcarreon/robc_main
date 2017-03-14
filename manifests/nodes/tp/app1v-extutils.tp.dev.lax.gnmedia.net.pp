node 'app1v-extutils.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
        include httpd
        include php
	httpd::virtual_host {"utils.gorillanation.com":monitor => "false",}
	httpd::virtual_host {"standup.evolvemediallc.com":monitor => "false",}
	httpd::virtual_host {"standup.gorillanation.com":monitor => "false",}

        package { [ 'perl-JSON','perl-Time-Piece','perl-Mail-Sendmail', 'subversion' ]:
              ensure => present 
              }

        cron { 'akamai_content_refresh.cron':
                user => 'root',
                ensure  => present,
                minute => '*/10',
                command => '/app/shared/docroots/utils.gorillanation.com/htdocs/docroot/utilities/akamai_content_refresh.cron',
        }

        file { "/etc/httpd/conf.d/utils.logins":
                source => "puppet:///modules/httpd/htpasswords/admin/extutils.logins";
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/extutils-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-extutils.tp.dev.lax.gnmedia.net",
        }
}

node 'app1v-yum.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
	include httpd
        include rubygems
	include subversion::client

	httpd::virtual_host {"yum.gnmedia.net":}
	httpd::virtual_host {"yumoter.gnmedia.net":}
        httpd::virtual_host {"pip.gnmedia.net":}
        httpd::virtual_host {"gem.gnmedia.net":}

	$yumPackages=["createrepo", "python-argparse"]

	package { $yumPackages:
		ensure => installed,
	}

        file { '/usr/local/bin/pkg-promo':
            ensure => link,
            target => '/mnt/yum_repos/yumoter/pkg-promo.py',
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/yum-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-yum.tp.prd.lax.gnmedia.net",
        }

	common::nfsmount { "/mnt/yum_repos":
		device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_yumrepos",
	}

        file {"/mnt/yum_repos":
                ensure  => directory,
                owner   => "root",
                group   => "root",
        }


}

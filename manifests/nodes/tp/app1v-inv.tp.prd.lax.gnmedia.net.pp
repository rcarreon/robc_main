node 'app1v-inv.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
	include subversion::client

    	# DEFINE URL's for RT/AT
    	$rt_url = 'inventory.gnmedia.net'


        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-inv.tp.prd.lax.gnmedia.net",
        }

        # need to change after new sql up
    	# INSTALL
    	 include rt
    	 rt::config::rt_vhost {"$rt_url": db_host => "vip-sqlrw-inv.tp.prd.lax.gnmedia.net", db_user => "rt_w", db_pass => "dKtqmoMd", sso => true,}

}
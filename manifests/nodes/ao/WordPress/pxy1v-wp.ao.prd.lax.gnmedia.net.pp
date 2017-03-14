node 'pxy1v-wp.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="atomiconline"
        include geoip_plugin
        varnish::accelerates {"pb_wp":
            version => "c6_2_1_5_5",
        }

         file{"/etc/varnish/plugin.vcl":
                source  => "puppet:///modules/varnish/geoip_wp.vcl",
                owner   => 'root',
                group   => 'root',
                require => Class["geoip_plugin"],
        }
	file {"/etc/init.d/varnish2logstash":
		source	=>  "puppet:///modules/varnish/varnish2logstash",
		owner	=>  'root',
		group	=>  'root',		
		require => File["/etc/varnish/varnish2logstash.sh"],	
	}
        file {"/etc/varnish/varnish2logstash.sh":
                source  =>  "puppet:///modules/varnish/varnishncs2logstash.sh",
                owner   =>  'root',
                group   =>  'root',                
        }


        schedule { monthly:
                period => monthly,
        }

        exec { "/usr/bin/geoipupdate":
                schedule => monthly,
                require  => File["/etc/GeoIP.conf"],
        }

        common::nfsmount { "/pxy/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_pxy_log/pxy1v-wp.ao.prd.lax.gnmedia.net",
        }
}

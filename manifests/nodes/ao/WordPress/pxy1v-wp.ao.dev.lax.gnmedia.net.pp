node 'pxy1v-wp.ao.dev.lax.gnmedia.net' {
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

        schedule { monthly:
                period => monthly,
        }

        exec { "/usr/bin/geoipupdate":
                schedule => monthly,
                require  => File["/etc/GeoIP.conf"],
        }
        

        common::nfsmount { "/pxy/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_pxy_log/pxy1v-wp.ao.dev.lax.gnmedia.net",
        }
}

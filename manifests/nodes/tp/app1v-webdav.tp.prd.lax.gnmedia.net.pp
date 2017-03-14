node 'app1v-webdav.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base


    $project = "admin"
    include httpd::ssl
    httpd::virtual_host {"webdav.gorillanation.com": expect => "up",}

    file {
        # gorillanation.com wildcard cert
        "/etc/pki/tls/certs/gorillanation.com.crt":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/certificates/gorillanation.com.crt";
        "/etc/pki/tls/private/gorillanation.com.key":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/certificates/gorillanation.com.key";


    # http access list
    # those are not in svn for security check puppet.lax3:/var/lib/puppet/httpd/htpasswords/admin/
    # hockeysfuture.logins  sherdog.logins  soapoperafan.logins  wrestlezone.logins
        "/etc/httpd/conf.d/wrestlezone.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/wrestlezone.logins";
        "/etc/httpd/conf.d/sherdog.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/sherdog.logins";
        #"/etc/httpd/conf.d/drinksmixer.logins":
            #source => "puppet:///modules/httpd/htpasswords/admin/drinksmixer.logins";
        #"/etc/httpd/conf.d/myanimelist.logins":
            #source => "puppet:///modules/httpd/htpasswords/admin/myanimelist.logins";
        #"/etc/httpd/conf.d/hockeysfuture.logins":
            #source => "puppet:///modules/httpd/htpasswords/admin/hockeysfuture.logins";
        #"/etc/httpd/conf.d/actiontrip.logins":
            #source => "puppet:///modules/httpd/htpasswords/admin/actiontrip.logins";
        "/etc/httpd/conf.d/videoupload.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/videoupload.logins";
        "/etc/httpd/conf.d/test.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/test.logins";
        "/etc/httpd/conf.d/test2.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/test2.logins";
        "/etc/httpd/conf.d/monstrous.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/monstrous.logins";
        "/etc/httpd/conf.d/puff.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/puff.logins";
        "/etc/httpd/conf.d/qj.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/qj.logins";
        "/etc/httpd/conf.d/chaptercheats.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/chaptercheats.logins";
        "/etc/httpd/conf.d/nexusis.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/nexusis.logins";
        "/etc/httpd/conf.d/spoonyexperiment.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/spoonyexperiment.logins";
    	"/etc/httpd/conf.d/vegtv.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/vegtv.logins";
        "/etc/httpd/conf.d/konsolekingz.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/konsolekingz.logins";
        "/etc/httpd/conf.d/movy.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/movy.logins";
        "/etc/httpd/conf.d/thatruled.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/thatruled.logins";
        "/etc/httpd/conf.d/martini.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/martini.logins";
        "/etc/httpd/conf.d/stupiddope.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/stupiddope.logins";
        "/etc/httpd/conf.d/devran.tb.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/atomic-sites/devran.tb.logins";
        "/etc/httpd/conf.d/ugcsi.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/admin/ugcsi.logins";
	"/etc/httpd/conf.d/gumgum.logins":
            owner  => "deploy",
            group  => "deploy",
            mode   => "0644",
            source => "puppet:///modules/httpd/htpasswords/sbv/gumgum.logins";
    }


# LEGACY
# Uncomment the below and comment out the other line when admin/media.sk cuts over to KVM

    common::nfsmount { "/app/ugc_ap/gumgum":
       device => "nfsA-netapp1.ap.prd.lax.gnmedia.net:/vol/nac1a_ap_lax_prd_app_ugc_gum",
    }   
   

    common::nfsmount { "/app/sherdog":
        device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_sdvideos_ao_lax_prd_app_shared",
    }


    common::nfsmount { "/app/sbv":
        device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_ugc/ugc/storage",
    }

    common::nfsmount { "/app/videoupload":
	device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/preroll-shared",
    }

    common::nfsmount { "/app/mediaads":
        device => "nfsA-netapp1.ap.prd.lax.gnmedia.net:/vol/nac1a_ap_lax_prd_app_mediaads/mediaads-shared/docroots/mediaads",
    }

    common::nfsmount { "/app/assets_si":
        device => "nfsA-netapp1.si.prd.lax.gnmedia.net:/vol/nac1a_si_lax_prd_app_shared/assets-shared",
    }

    common::nfsmount { "/app/stg_assets_si":
        device => "nfsA-netapp1.si.stg.lax.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared/assets-shared",
    }

    common::nfsmount { "/app/tb":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/tb-media/static",
    }

    common::nfsmount { "/app/martinimedia":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_af_lax_prd_app_shared",
    }

    common::nfsmount { "/app/prd_ugc_si":
        device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_ugc",
    }

    common::nfsmount { "/app/ugc_si/dev":
        device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_dev_app_ugc",
    }

    common::nfsmount { "/app/ugc_si/stg":
        device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_ugc",
    }
}


class doublehelix::fe_sites ( $monitor = true ) {
	# moved to node scope because this doesn't work with dynamic scoping
        # $project = "doublehelix"
	include httpd
	#include php::dh
	include subversion::client
        if ($::fqdn_env == 'dev') {
            include php::si_54
        }else{
            include php::dh
        }
	httpd::sicampaign_vhost{"craveonline.com": expect => "campaigns.craveonline.com",}
	httpd::sicampaign_vhost{"drinksmixer.com": expect => "campaigns.drinksmixer.com",}
	httpd::sicampaign_vhost{"gamerevolution.com": expect => "campaigns.gamerevolution.com",}
	httpd::sicampaign_vhost{"gorillanation.com": expect => "campaigns.gorillanation.com",}
	httpd::sicampaign_vhost{"iconator.com": expect => "campaigns.iconator.com",}
	httpd::sicampaign_vhost{"momtastic.com": expect => "campaigns.momtastic.com",}
	httpd::sicampaign_vhost{"sherdog.com": expect => "campaigns.sherdog.com",}
	httpd::sicampaign_vhost{"superherohype.com": expect => "campaigns.superherohype.com",}
	httpd::sicampaign_vhost{"thefashionspot.com": expect => "campaigns.thefashionspot.com",}
	httpd::sicampaign_vhost{"liveoutdoors.com": expect => "campaigns.liveoutdoors.com",}
	httpd::sicampaign_vhost{"totallyher.com": expect => "campaigns.totallyher.com",}
	httpd::sicampaign_vhost{"youthologymedia.com": expect => "campaigns.youthologymedia.com",}
	httpd::sicampaign_vhost{"globetrottingdigitalmedia.com": expect => "campaigns.globetrottingdigitalmedia.com",}
	httpd::sicampaign_vhost{"springboardvideo.com": expect => "campaigns.springboardvideo.com",}
	httpd::sicampaign_vhost{"actiontrip.com": expect => "campaigns.actiontrip.com",}
	httpd::sicampaign_vhost{"comingsoon.net": expect => "campaigns.comingsoon.net",}
	httpd::sicampaign_vhost{"teenspot.com": expect => "campaigns.teenspot.com",}
	httpd::sicampaign_vhost{"evolvemediacorp.com": expect => "campaigns.evolvemediacorp.com",}
	httpd::sicampaign_vhost{"dvdfile.com": expect => "campaigns.dvdfile.com",}
	httpd::sicampaign_vhost{"totallyhermedia.co.uk": expect => "campaigns.totallyhermedia.co.uk",}
	
	httpd::virtual_host {"rmdemo.evolvemediacorp.com": uri => '/', expect => 'All Rights Reserved. EVOLVE MEDIA CORP', monitor => $monitor, }
	httpd::virtual_host {"e3craveisland.com": monitor => false,}
        httpd::virtual_host {"iframe.evolvemediallc.com": monitor => false,}

	file { "/app/shared/docroots":
		ensure => directory,
		owner	=> deploy,
		group	=> deploy,
		mode    => 755,
		require => Mount["/app/shared"]
	}

        file { "/app/shared/doublehelix-httpd-conf.d":
                ensure => directory,
                owner   => deploy,
                group   => deploy,
                mode    => 755,
                require => Mount["/app/shared"]
        }

        file { "/app/shared/microsites-httpd-conf.d":
                ensure => directory,
                owner   => root,
                group   => root,
                mode    => 755,
                require => Mount["/app/shared"]
        }

	file { "/etc/httpd/conf.d/doublehelix.conf":
		ensure  => file,
		mode    => 644,
		content => "Include /app/shared/doublehelix-httpd-conf.d/*.conf",
		require => File["/app/shared/docroots"]
	}
	file { "/etc/httpd/conf.d/microsites.conf":
		ensure  => file,
		mode    => 644,
		content => "Include /app/shared/microsites-httpd-conf.d/*.conf",
		require => File["/app/shared/docroots"]
	}
	file { "httpd_db_migrations":
		ensure	=> directory,
		owner	=> deploy,
		group	=> root,
		mode	=> 755,
		path	=> "/app/shared/db_migrations",
	}

        # needed to avoid warnings on first install, because the httpd::virtual_host called above does not create dir
        file { "/app/shared/docroots/rmdemo.evolvemediacorp.com":
                ensure  => directory,
                owner   => deploy,
                group   => deploy,    
                mode    => 755,       
                require => File["/app/shared/docroots"]
        }
        
        # needed to avoid warnings on first install, because the httpd::virtual_host called above does not create dir
        file { "/app/shared/docroots/www.evolvemediallc.com":
                ensure  => directory,
                owner   => deploy,
                group   => deploy,
                mode    => 755,
                require => File["/app/shared/docroots"]
        }

	file { "/etc/httpd/conf.d/www.evolvemediacorp.com.conf":
		ensure  => absent,
        }
}	

class doublehelix::assets_sites {
        # moved to node scope because this doesn't work with dynamic scoping
        # $project = "doublehelix"
	include httpd
	#include php::dh
        if ($::fqdn_env == 'dev') {
            include php::si_54
        }else{
            include php::dh
        }

	httpd::siassets_vhost{"evolvemediallc.com": expect => "evolvemediallc",}
	httpd::siassets_vhost{"evolvemediacorp.com": expect => "evolvemediacorp",}
	httpd::siassets_vhost{"craveonline.com": expect => "craveonline",}
	httpd::siassets_vhost{"gorillanation.com": expect => "gorillanation",}
	httpd::siassets_vhost{"momtastic.com": expect => "momtastic",}
	httpd::siassets_vhost{"drinksmixer.com": expect => "drinksmixer",}
	httpd::siassets_vhost{"thefashionspot.com": expect => "thefashionspot",}
	httpd::siassets_vhost{"gamerevolution.com": expect => "gamerevolution",}
	httpd::siassets_vhost{"sheknows.com": expect => "sheknows",}
	httpd::siassets_vhost{"sherdog.com": expect => "sherdog",}
	httpd::siassets_vhost{"liveoutdoors.com": expect => "liveoutdoors",}
	httpd::siassets_vhost{"totallyher.com": expect => "totallyher",}
	httpd::siassets_vhost{"youthologymedia.com": expect => "youthologymedia",}
	httpd::siassets_vhost{"globetrottingdigitalmedia.com": expect => "globetrottingdigitalmedia",}
	httpd::siassets_vhost{"springboardvideo.com": expect => "springboardvideo",}
	httpd::siassets_vhost{"actiontrip.com": expect => "actiontrip",}
	httpd::siassets_vhost{"comingsoon.net": expect => "comingsoon",}
	httpd::siassets_vhost{"teenspot.com": expect => "teenspot",}
	httpd::siassets_vhost{"dvdfile.com": expect => "dvdfile",}
	httpd::siassets_vhost{"totallyhermedia.co.uk": expect => "totallyhermedia",}
	
	httpd::virtual_host {"files.evolvemediacorp.com": uri => '/', expect => 'Evolve',}
	httpd::virtual_host {"videos.evolvemediacorp.com": uri => '/', expect => 'videos',}
}


class doublehelix::nodejs {


   $packages_nodejs = ["nodejs",
    "nodejs-abbrev",
    "nodejs-ansi",
    "nodejs-archy",
    "nodejs-block-stream",
    "nodejs-chownr",
    #"nodejs-compat-symlinks", #  No longer needed with EPEL?
    "nodejs-devel",
    #"nodejs-fast-list", # handled in npm now?
    "nodejs-fstream",
    "nodejs-fstream-ignore",
    "nodejs-fstream-npm",
    "nodejs-glob",
    "nodejs-graceful-fs",
    "node-gyp",  # replacement for nodejs-waf, not sure if needed but included in case.
    "nodejs-inherits",
    "nodejs-ini",
    "nodejs-lru-cache",
    "nodejs-minimatch",
    "nodejs-mkdirp",
    "nodejs-node-uuid",
    "nodejs-nopt",
    "nodejs-proto-list",
    "nodejs-read",
    "nodejs-request",
    "nodejs-rimraf",
    "nodejs-semver",
    #"nodejs-slide-flow-control",  #called slide in npm?
    #"nodejs-stable-release",  #no longer needed with EPEL?
    "nodejs-tar",
    "nodejs-uid-number",
    #"nodejs-waf",  # deprecated in favor of gyp?
    "nodejs-which"]

       package{$packages_nodejs:
               ensure  => installed,
       }  
       #if ($fqdn_env != 'dev') {
       #    include yum::nodejs-live
       #}
       nodejs::service{ "paparazzo.evolvemediacorp.com":
           nodeappname => "paparazzo",
           nodeappjs => "current/app.js",
           nodeport => "82",
       }
       package{"phantomjs":
               ensure  => installed,
       }  

}


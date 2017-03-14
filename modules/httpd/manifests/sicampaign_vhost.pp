# SI campaign virtual hosts

    define httpd::sicampaign_vhost($ensure = 'enabled', $uri = '/', $expect = 'href', $logging = $defaulthttpdlogging) {
        $sitehash = md5("campaigns.${name}")

    file { "/etc/httpd/conf.d/campaigns.${name}.conf":
        content   => template("httpd/${project}/campaigns.erb"),
        require   => Package[httpd],
        notify    => Service[httpd],
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    nagios::service {"campaigns.${name}":
        command   => "check_url!campaigns.${name}!${uri}!${expect}",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_url',
    }

    # create docroot and index.html
    file { "/app/shared/docroots/campaigns.${name}":
        ensure    => directory,
        owner     => 'deploy',
        group     => 'deploy',
        mode      => '0755',
    }

    file { "/app/shared/docroots/campaigns.${name}/index.html":
        content   => "campaigns.${name} <!-- monitoring_string = ${sitehash} -->",
        require   => File["/app/shared/docroots/campaigns.${name}"],
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
    }
}

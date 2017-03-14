# SI assets virtual hosts
    define httpd::siassets_vhost($ensure = 'enabled', $uri = '/', $expect = 'href', $logging = $defaulthttpdlogging) {
        file { "/etc/httpd/conf.d/assets.${name}.conf":
            content   => template("httpd/${project}/assets.erb"),
            require   => Package[httpd],
            notify    => Service[httpd],
            owner     => 'root',
            group     => 'gncdn',
            mode      => '0644',
        }

        nagios::service {"assets.${name}":
            command   => "check_url!assets.${name}!${uri}!${expect}",
            notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_url',
        }

        # create docroot and index.html
        file { "/app/shared/docroots/assets.${name}":
            ensure    => directory,
            owner     => 'apache',
            group     => 'gncdn',
            mode      => '2775',
        }

        file{ "/app/shared/docroots/assets.${name}/index.html":
            content   => "assets.${name}",
            require   => File["/app/shared/docroots/assets.${name}"],
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
        }
    }

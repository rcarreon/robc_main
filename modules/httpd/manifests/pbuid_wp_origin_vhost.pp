#### TitanWP SBX Origin
    define httpd::pbuid_wp_origin_vhost($logging = $defaulthttpdlogging) {
        file {
            "/etc/httpd/conf.d/origin.${name}.conf":
            content => template("httpd/${project}/uid_wordpress_origin_vhost.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

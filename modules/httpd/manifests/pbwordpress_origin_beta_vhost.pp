#### TitanWP beta origin template
    define httpd::pbwordpress_origin_beta_vhost($logging = $defaulthttpdlogging) {
        file {
            "/etc/httpd/conf.d/origin.${name}.conf":
            content => template("httpd/${project}/cdn_wordpress_beta_vhost.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }
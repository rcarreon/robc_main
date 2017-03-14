#### TitanWP Beta mobile template
    define httpd::pbwordpress_mobile_beta_vhost($logging = $defaulthttpdlogging) {
        file {
            "/etc/httpd/conf.d/m.${name}.conf":
            content => template("httpd/${project}/mobile_wordpress_beta_vhost.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

#### TitanWP mobile template
    define httpd::pbwordpress_mobile_vhost($logging = $defaulthttpdlogging) {
        file {
            "/etc/httpd/conf.d/m.${name}.conf":
            content => template("httpd/${project}/mobile_wordpress_vhost.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

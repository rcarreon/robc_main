# TitanWP vhost template

#### Create virtual hosts
define httpd::pbwordpress_vhost($uri = '/', $expect = 'href', $needextra = false, $logging = $defaulthttpdlogging, $enable_pipestash = false) {
    file {
        "/etc/httpd/conf.d/${name}.conf":
        content => template("httpd/${project}/wordpress_vhost.erb"),
        require => Package[httpd],
        notify  => Service[httpd],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }


#### Origin
    httpd::pbwordpress_origin_vhost { $name: logging => $logging }

#### Mobile
    httpd::pbwordpress_mobile_vhost { $name: logging => $logging }


#### Site-specific configuration options
    if $needextra {
        file {
            "/etc/httpd/conf.d/${name}.conf.extra":
            source  => "puppet:///modules/httpd/${project}/${name}.conf.extra",
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0644',
        }
    }


#### Nagios Checks
    if ($expect != 'false') {
        nagios::service {$name:
        command     => "check_url!${name}!${uri}!${expect}",
        notes_url   => 'http://docs.gnmedia.net/wiki/Nagios-check_url',
        }
    }

}

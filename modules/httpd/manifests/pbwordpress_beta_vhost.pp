#### TitanWP beta vhost

define httpd::pbwordpress_beta_vhost($uri = '/', $expect = 'href', $needextra = false, $logging = $defaulthttpdlogging) {
    file {
        "/etc/httpd/conf.d/${name}.conf":
        content => template("httpd/${project}/wordpress_beta_vhost.erb"),
        require => Package[httpd],
        notify  => Service[httpd],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }


#### CDN-Origin
    httpd::pbwordpress_origin_beta_vhost { $name: logging => $logging }

#### Mobile
    httpd::pbwordpress_mobile_beta_vhost { $name: logging => $logging }


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
}

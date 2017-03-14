#### TitanWP SBX vhost template
    define httpd::pbuid_wpvhost($uri = '/', $expect = 'href', $needextra = false, $logging = $defaulthttpdlogging) {
        file {
        "/etc/httpd/conf.d/${name}.conf":
            content => template("httpd/${project}/uid_wordpress_vhost.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }

#### CDN-Origin
    httpd::pbuid_wp_origin_vhost { $name: logging => $logging }

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


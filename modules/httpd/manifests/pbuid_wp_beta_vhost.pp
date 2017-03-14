#### TitanWP SBX beta vhost

    define httpd::pbuid_wp_beta_vhost($uri = '/', $expect = 'href', $needextra = false, $logging = $defaulthttpdlogging) {
        file {
            "/etc/httpd/conf.d/sbb.${name}.conf":
            content => template("httpd/${project}/uid_wordpress_beta_vhost.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }

#### CDN-Origin
    httpd::pbuid_wp_origin_beta_vhost { $name: logging => $logging }

#### Site-specific configuration options
    if $needextra {
        file {
            "/etc/httpd/conf.d/sbb.${name}.conf.extra":
            source  => "puppet:///modules/httpd/${project}/${name}.conf.extra",
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0644',
        }
    }
}

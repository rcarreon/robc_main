# virtual hosts

    define httpd::virtual_host($ensure = 'present', $uri = '/', $expect = 'href', $monitor = true, $logging = $defaulthttpdlogging) {
        file { "/etc/httpd/conf.d/${name}.conf":
            ensure  => $ensure,
            content => template("httpd/${project}/${name}.erb"),
            require => Package[httpd],
            notify  => Service[httpd],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }

        if $monitor == true {
            nagios::service {$name:
                command               => "check_url!${name}!${uri}!${expect}",
                normal_check_interval => '3',
                notes_url             => 'http://docs.gnmedia.net/wiki/Nagios-check_url',
                action_url            => "http://gweb.gnmedia.net/?h=${::fqdn}$&r=hour&metric_group=NOGROUPS&z=small",
            }
        }

    }

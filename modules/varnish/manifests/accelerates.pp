    # Our function to generate and load the config
    define varnish::accelerates($version= '2_1') {
        include varnish::service, varnish::configuration, varnish::monitor
        case $version {
        2_1:         { include varnish::install2_1 }
        c6_2_1:      { include varnish::installc6_2_1 }
        c6_2_1_5_5:  { include varnish::installc6_2_1_5_5 }
        default:     { include varnish::install2_1 }
        }

        file {'/etc/varnish/varnish.vcl':
        content => template("varnish/${name}.vcl.erb"),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        }

        # For pxy to app mapping in vip visual
        file {'/etc/cron.hourly/pxy2app_connchk.sh':
                owner   => root,
                group   => root,
                mode    => '0755',
                source  => 'puppet:///modules/varnish/pxy2app_connchk.sh',
        }

        file {'/etc/logrotate.d/varnish':
                owner   => root,
                group   => root,
                mode    => '0644',
                source  => [
                        "puppet:///modules/varnish/logrotate-${name}.varnish",
                        'puppet:///modules/varnish/logrotate.varnish',
                ]
        }

        file {'/etc/cron.hourly/logrotate.varnish':
                owner   => root,
                group   => root,
                mode    => '0755',
                source  => [
                        "puppet:///modules/varnish/logrotate-${name}.varnish.cron",
                        'puppet:///modules/varnish/logrotate.varnish.cron',
                ]
        }
    }

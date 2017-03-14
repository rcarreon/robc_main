# FIXME: no way to uninstall a nodejs service
define nodejs::service ( $nodeappname, $nodeappjs, $nodeport, $monitor = true, $uri = "/", $expect = "html" ) {
# FIXME: should http be separate?  Could more than one vhost be pointed at the same app?
    if ( $nodeport != 80 ) {
        file {"/etc/httpd/conf.d/nodejs-$name.conf":
            ensure  => file,
            content => template("nodejs/nodejs-httpdconf.erb"),
            owner   => "root",
            group   => "root",
            mode    => '0644',
            notify  => Service['httpd'],
        }
    }
    file {"/etc/rc.d/init.d/nodejs-$nodeappname":
        ensure  => file,
        content => template("nodejs/nodejs-init.erb"),
        owner   => "root",
        group   => "root",
        mode    => '0755',
    }
    service { "nodejs-$nodeappname":
        ensure      => running,
        enable      => true,
        hasstatus   => true,
    }
    if $monitor == true {
        nagios::service {"$name":
        command                 => "check_url_p!${name}!${uri}!${expect}!${nodeport}",
        normal_check_interval   => "3",
        notes_url               => "http://docs.gnmedia.net/wiki/Nagios-check_url",
        }
    }

}


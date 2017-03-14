# Class httpd::ssl::virtual_host

    # virtual hosts on https
    define httpd::ssl::virtual_host($ensure = 'enabled', $uri = '/', $expect = 'href', $monitor = true, $httpservername='', $logging = $defaulthttpdlogging) {
        file { "/etc/httpd/conf.d/00-$name.conf":
            content   => template("httpd/$project/$name.erb"),
            notify    => Service[httpd],
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
    }

        if $monitor == true {
            nagios::service {$name:
                command   => "check_url_s!${name}!${uri}!${expect}",
                notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_url_s',
            }
        }
    }

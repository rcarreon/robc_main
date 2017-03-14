# Varnish services

class varnish::service {

    # All the services below must be restarted if varnish.vcl changes
    Service {
        require    => Class['varnish::base'],
        enable     => true,
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        subscribe  => File['/etc/varnish/varnish.vcl'],
    }

    # main service, running the reverse proxy
        service {'varnish':}

    # logger daemon
        service {'varnishncsa':
        ensure     => running,
        enable     => true,
    }
}

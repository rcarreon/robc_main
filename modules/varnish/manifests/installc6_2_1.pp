# Install Varnish 2.1 on Centos 6.4 boxen
class varnish::installc6_2_1 {
    include varnish::base

    package {'varnish':
        ensure  => '2.1.5-1.el6',
    }
}

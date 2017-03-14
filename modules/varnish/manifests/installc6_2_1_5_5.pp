# Install Varnish 2.1.5-5 on Centos 6.5 boxen
class varnish::installc6_2_1_5_5 {
    include varnish::base

    package {'varnish':
        ensure  => '2.1.5-5.el6',
    }
}

# Install Varnish 2.1
class varnish::install2_1 {
    include varnish::base

    package {'varnish-2.1.5-1.x86_64':
        ensure  => 'present',
    }
}

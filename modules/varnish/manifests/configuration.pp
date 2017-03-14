# Varnish Configuration

class varnish::configuration {
    File {
        ensure  => present,
        owner   => root,
        group   => root,
    }

    file {'/etc/sysconfig/varnish':
        content => template('varnish/sysconfig.erb'),
        notify  => Class['varnish::service'],
        mode    => '0644',
        }

    file {'/etc/varnish/default.vcl':
        content => template('varnish/default.vcl.erb'),
        notify  => Class['varnish::service'],
        mode    => '0644',
        }
}

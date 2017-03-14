# nagios server certs
class nagios::server::certs {
    file { "/etc/httpd/conf.d/${httpservername}.key":
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/nagios/ssl/${httpservername}.key",
    }
    file { "/etc/httpd/conf.d/${httpservername}.csr":
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/nagios/ssl/${httpservername}.csr",
    }
    file { "/etc/httpd/conf.d/${httpservername}.crt":
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/nagios/ssl/${httpservername}.crt",
    }

    file { '/usr/share/nagios/html/main.php':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => "<!-- local GN change, see the puppet module -->\n<?php header( 'Location: /cgi-bin/tac.cgi' ) ; ?>",
    }
}

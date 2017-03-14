# nagios server ssl
class nagios::server::ssl {
    include nagios::server::certs
    include httpd::ssl
    httpd::ssl::virtual_host{ 'nagios':
        uri               => '/robots.txt',
        httpservername    => $httpservername,
        expect            => 'Disallow:',
    }

    # This file comes with the package to password-protect the directory, but
    # we do it another way
    file {'/etc/httpd/conf.d/nagios.conf':
        ensure => absent,
    }
}

# Class httpd::ssl

class httpd::ssl inherits httpd::base {

# Self-signed certificate
#
# Use genkey --days 365 test.example.net from the crypto-utils package
#
# Cert will be in /etc/pki/tls/certs/test.example.net.cert
# CertKey in /etc/pki/tls/private/test.example.net.key
# Move `facter fqdn`.key `facter fqdn`.crt wherever you need
# see httpd/$project/$name.erb


    $ssl_packages = ['mod_ssl', 'mod_authz_ldap', 'crypto-utils']
    package { $ssl_packages:
        ensure    => present,
    }

    file { '/etc/httpd/conf.d/ssl.conf':
        group     => 'root',
        owner     => 'root',
        source    => 'puppet:///modules/httpd/ssl.conf',
        mode      => '0644',
    }

}

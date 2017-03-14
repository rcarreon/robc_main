class subversion::server inherits subversion::client {

    $subversion_packages = ['mod_dav_svn', 'websvn']

    package {$subversion_packages:
        ensure => present,
    }

    $project = 'admin'
    include httpd::ssl

    class { 'php::install':
        version      => '5.3',
        ini_template => 'php.ini-svn.erb',
    }

    # To enable svnserve - the daemon that listens for svn:// requests.

    file{'/etc/init.d/subversion':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/subversion/init.d/subversion',
    }

    file{'/etc/sysconfig/subversion':
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/subversion/sysconfig/subversion',
    }

    service { 'svnserve':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        hasrestart  => true,
    }

    # we have multi vhosts using ssl, httpd+ssl doesn't like that unless you force it with ...
    file{ '/etc/httpd/conf.d/named-ssl.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'NameVirtualHost *:443'
    }

    httpd::ssl::virtual_host{'svn.gnmedia.net': monitor => false,}
    httpd::ssl::virtual_host{'svnsites.gnmedia.net': monitor => false,}
    httpd::ssl::virtual_host{'websvn.gnmedia.net': monitor => false,}

    subversion::websvn_conf{'svn':}
    subversion::websvn_conf{'svnsites':}


    File {
        ensure => present,
        owner  => 'root',
        group  => 'root',
    }

    file {'/etc/httpd/conf.d/websvn.conf': # remove the rpm-supplied config
        ensure => absent;
    }
    file {'/etc/httpd/conf.d/svn.gnmedia.net.acl':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('subversion/headers.acl.erb','subversion/svn.gnmedia.net.acl.erb'),
    }

    file {'/etc/httpd/conf.d/svnsites.gnmedia.net.acl':
        content => template('subversion/headers.acl.erb', 'subversion/svnsites.gnmedia.net.acl.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file {'/etc/httpd/conf.d/svn.gnmedia.net.csr':
        mode   => '0640',
        source => 'puppet:///modules/httpd/certificates/svn.gnmedia.net.csr',
        owner  => 'root',
        group  => 'root',
    }
    file {'/etc/httpd/conf.d/svn.gnmedia.net.key':
        mode   => '0640',
        source => 'puppet:///modules/httpd/certificates/svn.gnmedia.net.key',
        owner  => 'root',
        group  => 'root',
    }
    file {'/etc/httpd/conf.d/svn.gnmedia.net.crt':
        owner  => 'root',
        group  => 'root',
        mode   => '0640',
        source => 'puppet:///modules/httpd/certificates/svn.gnmedia.net.crt',
    }
# $svndir  must be defined in the node manifest
}

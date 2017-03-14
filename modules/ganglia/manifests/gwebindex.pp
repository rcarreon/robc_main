class ganglia::gwebindex {
    include httpd
    httpd::virtual_host{'gweb.gnmedia.net':}
    file { '/app/shared/docroots/gweb':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    file { '/app/shared/docroots/gweb/index.cgi':
        ensure => file,
        source => 'puppet:///modules/ganglia/gweb-index.cgi',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    package {'perl-XML-Simple':
        ensure => installed,
    }
}
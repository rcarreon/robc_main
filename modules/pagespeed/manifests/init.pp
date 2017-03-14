class pagespeed {
	package {['mod-pagespeed-stable']:
      	ensure => installed
    }

        file { '/etc/httpd/conf.d/pagespeed.conf':
        ensure    => file,
        source    => "puppet:///modules/httpd/pagespeed.conf",
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }
}

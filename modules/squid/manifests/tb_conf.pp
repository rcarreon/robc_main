class squid::tb_conf inherits squid {

       file { "/etc/squid/squid.conf":
                ensure => present,
		content  => template( "squid/squid-tb.conf.erb"),
                group => "squid",
                owner => "root",
                mode  => "0644",
		require => File ["/etc/squid"]
        }
	service { "squid":
		subscribe => File["/etc/squid/squid.conf"],
		enable => true,
		hasrestart => true
	}
	

}	

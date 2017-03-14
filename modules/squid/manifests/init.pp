class squid {

	package { "squid.x86_64":
	   ensure => "present",
	}

	file { "/etc/squid":
	    ensure => directory,
	    group => "root",
	    owner => "root",
	    mode => "0755"	
	}
	
}

class postgres93::server::pkg {
	package{ "postgresql93-server":
        ensure => installed,
    }
}
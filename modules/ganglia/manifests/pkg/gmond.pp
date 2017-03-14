class ganglia::pkg::gmond ( $pkgInstall = "installed" ) {
    package { "ganglia-gmond":
        ensure  => $pkgInstall,
	require => Class["ganglia::cfg::gmond"]
    }
    package { "ganglia-gmond-modules-python":
        ensure  => $pkgInstall,
	require => Class["ganglia::cfg::gmond"]
    }
    package { "hsflowd":
        ensure  => $pkgInstall,
	require => Class["ganglia::cfg::gmond"]
    }
    package { "libganglia":
        ensure  => $pkgInstall,
        require => Class["ganglia::cfg::gmond"]
    }
    if ( $pkgInstall != "absent" ) {
        file { "/etc/ganglia/conf.d/procstat.pyconf":
            # This test doesn't actually work... it just errors or gives zeros.
            ensure  => absent,
            notify  => Service["gmond"],
            require => Package["ganglia-gmond-modules-python"]
        }
    }
}

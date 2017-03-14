class ganglia::pkg::gweb ( $pkgInstall = "installed", $rrdInstall = false) {
    package { "ganglia-gmetad":
        ensure  => $pkgInstall,
	require => Class["ganglia::cfg::gweb"],
    }

    package { "ganglia-web":
        ensure  => $pkgInstall,
        require => Class["ganglia::cfg::gweb"],
    }

    if ($rrdInstall == true) { 
        package { "rrdtool":
            ensure => $pkgInstall,
            require => Class["ganglia::cfg::gweb"],
        }
    }
}

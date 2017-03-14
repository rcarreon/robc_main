class ganglia::svc::gmond ( $serviceStart = "running", $serviceEnable = "true" ) {
	service { "gmond":
		ensure  => $serviceStart,
		enable  => $serviceEnable,
		require => Class["ganglia::pkg::gmond"],
	}
	service { "hsflowd":
		ensure  => $serviceStart,
		enable  => $serviceEnable,
		require => Class["ganglia::pkg::gmond"],
	}
}

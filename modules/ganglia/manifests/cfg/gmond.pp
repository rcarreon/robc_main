class ganglia::cfg::gmond ( $noConfigs = "false" ) {

    # Need sampling vars in this namespace, but want them to come from init.pp, not re-intialized from data/*
    $sampling = $ganglia::sampling
    $samplingHttp = $ganglia::samplingHttp
    $samplingMemcache = $ganglia::samplingMemcache

    if ( $noConfigs == "false" ) {
        $fileEnsure = "present"
        $fileContentGmond = template("ganglia/gmond.conf.erb")
        $fileContentHsflowd = template("ganglia/hsflowd.conf.erb")
        $fileContentNfsstat = template("ganglia/modules/nfsstats.pyconf.erb")
    } else {
        $fileEnsure = "absent"
        $fileContentGmond = ""
        $fileContentHsflowd = ""
        $fileContentNfsstat = ""
    }

    file { "/etc/ganglia/gmond.conf":
        ensure  => $fileEnsure,
        mode    => "644",
        owner   => "ganglia",
        group   => "ganglia",
        content => $fileContentGmond,
    }
    file { "/etc/hsflowd.conf":
        ensure  => $fileEnsure,
        mode    => "644",
        owner   => "root",
        group   => "root",
        content => $fileContentHsflowd,
    }
    file { "/etc/ganglia/conf.d/nfsstats.pyconf":
        ensure  => $fileEnsure,
        mode    => "644",
        owner   => "root",
        group   => "root",
        content => $fileContentNfsstat,
    }
}


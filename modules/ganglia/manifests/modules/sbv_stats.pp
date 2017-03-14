class ganglia::modules::sbv_stats {
    file { "/etc/ganglia/conf.d/sbv_stats.pyconf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/sbv_stats.pyconf.erb"),
        notify  => Service["gmond"],
    }

    file { "/usr/lib64/ganglia/python_modules/sbv_stats.py":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/sbv_stats.py.erb"),
        notify  => Service["gmond"],
    }
}
